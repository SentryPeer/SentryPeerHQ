# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2025 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.SentrypeerEvents.Query do
  import Ecto.Query
  alias Sentrypeer.SentrypeerEvents

  @moduledoc """
  The SentrypeerEvents query context.
  """

  def base do
    SentrypeerEvents
  end

  def for_client(query \\ base(), client_id) do
    query
    |> where([e], e.client_id == ^client_id)
  end
end
