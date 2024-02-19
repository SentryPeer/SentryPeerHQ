# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2024 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.IntegrationsTest do
  use Sentrypeer.DataCase

  alias Sentrypeer.Integrations

  describe "integrations" do
    alias Sentrypeer.Integrations.Integration

    import Sentrypeer.IntegrationsFixtures

    @invalid_attrs %{
      auth_id: nil,
      description: nil,
      destination: nil,
      enabled: nil,
      message: nil,
      name: nil,
      subject: nil,
      type: nil
    }

    test "list_integrations/0 returns all integrations" do
      integration = integration_fixture()
      assert Integrations.list_integrations() == [integration]
    end

    test "get_integration!/1 returns the integration with given id" do
      integration = integration_fixture()
      assert Integrations.get_integration!(integration.id) == integration
    end

    test "create_integration/1 with valid data creates a integration" do
      valid_attrs = %{
        auth_id: "some auth_id",
        description: "some description",
        destination: "some url",
        enabled: true,
        message: "some message",
        name: "some name",
        subject: "some subject",
        type: "some type"
      }

      assert {:ok, %Integration{} = integration} = Integrations.create_integration(valid_attrs)
      assert integration.auth_id == "some auth_id"
      assert integration.description == "some description"
      assert integration.destination == "some url"
      assert integration.enabled == true
      assert integration.message == "some message"
      assert integration.name == "some name"
      assert integration.subject == "some subject"
      assert integration.type == "some type"
    end

    test "create_integration/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Integrations.create_integration(@invalid_attrs)
    end

    test "update_integration/2 with valid data updates the integration" do
      integration = integration_fixture()

      update_attrs = %{
        auth_id: "some updated auth_id",
        description: "some updated description",
        destination: "some updated url",
        enabled: false,
        message: "some updated message",
        name: "some updated name",
        subject: "some updated subject",
        type: "some updated type"
      }

      assert {:ok, %Integration{} = integration} =
               Integrations.update_integration(integration, update_attrs)

      assert integration.auth_id == "some updated auth_id"
      assert integration.description == "some updated description"
      assert integration.destination == "some updated url"
      assert integration.enabled == false
      assert integration.message == "some updated message"
      assert integration.name == "some updated name"
      assert integration.subject == "some updated subject"
      assert integration.type == "some updated type"
    end

    test "update_integration/2 with invalid data returns error changeset" do
      integration = integration_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Integrations.update_integration(integration, @invalid_attrs)

      assert integration == Integrations.get_integration!(integration.id)
    end

    test "delete_integration/1 deletes the integration" do
      integration = integration_fixture()
      assert {:ok, %Integration{}} = Integrations.delete_integration(integration)
      assert_raise Ecto.NoResultsError, fn -> Integrations.get_integration!(integration.id) end
    end

    test "change_integration/1 returns a integration changeset" do
      integration = integration_fixture()
      assert %Ecto.Changeset{} = Integrations.change_integration(integration)
    end
  end
end
