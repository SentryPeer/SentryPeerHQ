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

defmodule Sentrypeer.IntegrationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sentrypeer.Integrations` context.
  """

  @doc """
  Generate a integration.
  """
  def integration_fixture(attrs \\ %{}) do
    {:ok, integration} =
      attrs
      |> Enum.into(%{
        auth_id: "some auth_id",
        description: "some description",
        destination: "some url",
        enabled: true,
        message: "some message",
        name: "some name",
        subject: "some subject",
        type: "some type"
      })
      |> Sentrypeer.Integrations.create_integration()

    integration
  end
end
