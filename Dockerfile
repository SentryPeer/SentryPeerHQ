# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 Gavin Henry <ghenry@sentrypeer.org>
#
#   _____            _              _____
#  / ____|          | |            |  __ \
# | (___   ___ _ __ | |_ _ __ _   _| |__) |__  ___ _ __
#  \___ \ / _ \ '_ \| __| '__| | | |  ___/ _ \/ _ \ '__|
#  ____) |  __/ | | | |_| |  | |_| | |  |  __/  __/ |
# |_____/ \___|_| |_|\__|_|   \__, |_|   \___|\___|_|
#                              __/ |
#                             |___/
#
# Find eligible builder and runner images on Docker Hub. We use Ubuntu/Debian
# instead of Alpine to avoid DNS resolution issues in production.
#
# https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=ubuntu
# https://hub.docker.com/_/ubuntu?tab=tags
#
# This file is based on these images:
#
#   - https://hub.docker.com/r/hexpm/elixir/tags - for the build image
#   - https://hub.docker.com/r/hexpm/elixir/tags?page=1&name=1.14.5-erlang-25.3.2.2 - for the release image
#   - https://pkgs.org/ - resource for finding needed packages
#   - Ex: hexpm/elixir:1.14.5-erlang-25.3.2.2-debian-bullseye-20230522-slim
#
ARG ELIXIR_VERSION=1.14.5
ARG OTP_VERSION=25.3.2.2
ARG DEBIAN_VERSION=bullseye-20230522-slim

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

ARG GIT_REV=unknown

FROM ${BUILDER_IMAGE} as builder

SHELL ["/bin/bash", "-c"]

# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git \
    && apt-get clean && rm -f /var/lib/apt/lists/*_*

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV="prod"
ENV GIT_REV=${GIT_REV}

# set APP_REVISION for AppSignal
ENV APP_REVISION=${APP_REVISION}

# install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN --mount=type=secret,id=AUTH0_DOMAIN \
    --mount=type=secret,id=AUTH0_AUDIENCE \
    --mount=type=secret,id=AUTH0_CLIENT_ID \
    --mount=type=secret,id=AUTH0_CLIENT_SECRET \
    --mount=type=secret,id=AUTH0_LOGOUT_REDIRECT_URL \
    AUTH0_DOMAIN=$(cat /run/secrets/AUTH0_DOMAIN) \
    AUTH0_AUDIENCE=$(cat /run/secrets/AUTH0_AUDIENCE) \
    AUTH0_CLIENT_ID=$(cat /run/secrets/AUTH0_CLIENT_ID) \
    AUTH0_CLIENT_SECRET=$(cat /run/secrets/AUTH0_CLIENT_SECRET) \
    AUTH0_LOGOUT_REDIRECT_URL=$(cat /run/secrets/AUTH0_LOGOUT_REDIRECT_URL) \
    mix deps.compile

COPY priv priv

COPY lib lib

COPY assets assets

# compile assets
RUN --mount=type=secret,id=AUTH0_DOMAIN \
    --mount=type=secret,id=AUTH0_AUDIENCE \
    --mount=type=secret,id=AUTH0_CLIENT_ID \
    --mount=type=secret,id=AUTH0_CLIENT_SECRET \
    --mount=type=secret,id=AUTH0_LOGOUT_REDIRECT_URL \
    AUTH0_DOMAIN=$(cat /run/secrets/AUTH0_DOMAIN) \
    AUTH0_AUDIENCE=$(cat /run/secrets/AUTH0_AUDIENCE) \
    AUTH0_CLIENT_ID=$(cat /run/secrets/AUTH0_CLIENT_ID) \
    AUTH0_CLIENT_SECRET=$(cat /run/secrets/AUTH0_CLIENT_SECRET) \
    AUTH0_LOGOUT_REDIRECT_URL=$(cat /run/secrets/AUTH0_LOGOUT_REDIRECT_URL) \
    mix assets.deploy

# Compile the release
RUN --mount=type=secret,id=AUTH0_DOMAIN \
    --mount=type=secret,id=AUTH0_AUDIENCE \
    --mount=type=secret,id=AUTH0_CLIENT_ID \
    --mount=type=secret,id=AUTH0_CLIENT_SECRET \
    --mount=type=secret,id=AUTH0_LOGOUT_REDIRECT_URL \
    AUTH0_DOMAIN=$(cat /run/secrets/AUTH0_DOMAIN) \
    AUTH0_AUDIENCE=$(cat /run/secrets/AUTH0_AUDIENCE) \
    AUTH0_CLIENT_ID=$(cat /run/secrets/AUTH0_CLIENT_ID) \
    AUTH0_CLIENT_SECRET=$(cat /run/secrets/AUTH0_CLIENT_SECRET) \
    AUTH0_LOGOUT_REDIRECT_URL=$(cat /run/secrets/AUTH0_LOGOUT_REDIRECT_URL) \
    mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

COPY rel rel
RUN --mount=type=secret,id=AUTH0_DOMAIN \
    --mount=type=secret,id=AUTH0_AUDIENCE \
    --mount=type=secret,id=AUTH0_CLIENT_ID \
    --mount=type=secret,id=AUTH0_CLIENT_SECRET \
    --mount=type=secret,id=AUTH0_LOGOUT_REDIRECT_URL \
    AUTH0_DOMAIN=$(cat /run/secrets/AUTH0_DOMAIN) \
    AUTH0_AUDIENCE=$(cat /run/secrets/AUTH0_AUDIENCE) \
    AUTH0_CLIENT_ID=$(cat /run/secrets/AUTH0_CLIENT_ID) \
    AUTH0_CLIENT_SECRET=$(cat /run/secrets/AUTH0_CLIENT_SECRET) \
    AUTH0_LOGOUT_REDIRECT_URL=$(cat /run/secrets/AUTH0_LOGOUT_REDIRECT_URL) \
    mix release

# start a new build stage so that the final image will only contain
# the compiled release and other runtime necessities
FROM ${RUNNER_IMAGE}

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR "/app"
RUN chown nobody /app

# set runner ENV
ENV MIX_ENV="prod"

# Only copy the final release from the build stage
COPY --from=builder --chown=nobody:root /app/_build/${MIX_ENV}/rel/sentrypeer ./

USER nobody

CMD ["/app/bin/server"]

# Appended by flyctl
ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"

# Appended by flyctl
ENV ECTO_IPV6 true
ENV ERL_AFLAGS "-proto_dist inet6_tcp"
