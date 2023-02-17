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

defmodule SentrypeerWeb.UserLiveAuth do
  import Phoenix.Component
  import Phoenix.LiveView

  @moduledoc """
   See https://hexdocs.pm/phoenix_live_view/security-model.html#mounting-considerations
  """
  def on_mount(:default, _params, %{"current_user" => current_user} = _session, socket) do
    socket =
      assign_new(socket, :current_user, fn ->
        current_user
      end)

    if socket.assigns.current_user do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/")}
    end
  end
end
