# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2026 Gavin Henry <ghenry@sentrypeer.org>
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

defimpl FunWithFlags.Actor, for: Sentrypeer.Auth.Auth0User do
  @moduledoc """
  Implement the FunWithFlags.Actor protocol for Auth0User.
  """

  def id(%{id: id}) do
    "user:#{id}"
  end
end

defimpl FunWithFlags.Group, for: Sentrypeer.Auth.Auth0User do
  def in?(%{groups: list}, group_name), do: group_name in list
end

defmodule Sentrypeer.Auth.Auth0User do
  @moduledoc """
  The Auth0User struct.
  """

  defstruct [:id, :name, :avatar, :email, :latest_login, groups: []]
end
