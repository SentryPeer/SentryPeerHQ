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

defmodule SentrypeerWeb.PageController do
  use SentrypeerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home,
      current_user: get_session(conn, :current_user),
      layout: false,
      page_title: "Home"
    )
  end

  def privacy_policy(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :privacy_policy,
      current_user: get_session(conn, :current_user),
      layout: false,
      page_title: "Privacy Policy"
    )
  end

  def terms_and_conditions(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :terms_and_conditions,
      current_user: get_session(conn, :current_user),
      layout: false,
      page_title: "Terms and Conditions"
    )
  end

  def acceptable_use_policy(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :acceptable_use_policy,
      current_user: get_session(conn, :current_user),
      layout: false,
      page_title: "Acceptable Use Policy"
    )
  end
end
