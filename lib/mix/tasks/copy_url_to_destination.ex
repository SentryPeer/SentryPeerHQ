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

defmodule Mix.Tasks.CopyUrlToDestination do
  use Mix.Task

  alias Sentrypeer.Integrations.Integration
  alias Sentrypeer.Repo

  @moduledoc """
  Copy the url field to the destination field for all integrations

  This is also a good example of how to run a task from the command line
  so we are keeping it around.
  """

  def run(_) do
    Mix.Task.run("app.start")

    # https://hexdocs.pm/cloak_ecto/encrypt_existing_data.html#copy-data-to-new-fields
    Integration
    |> Repo.all()
    |> Enum.map(fn integration ->
      integration
      |> Ecto.Changeset.change(%{
        destination: integration.url
      })
      |> Repo.update!()
    end)
  end
end
