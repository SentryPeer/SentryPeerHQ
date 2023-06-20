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

defmodule SentrypeerWeb.IntegrationLiveTest do
  use SentrypeerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sentrypeer.IntegrationsFixtures

  @create_attrs %{
    auth_id: "some auth_id",
    description: "some description",
    enabled: true,
    message: "some message",
    name: "some name",
    subject: "some subject",
    type: "some type",
    url: "some url"
  }
  @update_attrs %{
    auth_id: "some updated auth_id",
    description: "some updated description",
    enabled: false,
    message: "some updated message",
    name: "some updated name",
    subject: "some updated subject",
    type: "some updated type",
    url: "some updated url"
  }
  @invalid_attrs %{
    auth_id: nil,
    description: nil,
    enabled: false,
    message: nil,
    name: nil,
    subject: nil,
    type: nil,
    url: nil
  }

  defp create_integration(_) do
    integration = integration_fixture()
    %{integration: integration}
  end

  describe "Index" do
    setup [:create_integration]

    test "lists all integrations", %{conn: conn, integration: integration} do
      {:ok, _index_live, html} = live(conn, ~p"/integrations")

      assert html =~ "Listing Integrations"
      assert html =~ integration.description
    end

    test "saves new integration", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/integrations")

      assert index_live |> element("a", "New Integration") |> render_click() =~
               "New Integration"

      assert_patch(index_live, ~p"/integrations/new")

      assert index_live
             |> form("#integration-form", integration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#integration-form", integration: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/integrations")

      html = render(index_live)
      assert html =~ "Integration created successfully"
      assert html =~ "some description"
    end

    test "updates integration in listing", %{conn: conn, integration: integration} do
      {:ok, index_live, _html} = live(conn, ~p"/integrations")

      assert index_live |> element("#integrations-#{integration.id} a", "Edit") |> render_click() =~
               "Edit Integration"

      assert_patch(index_live, ~p"/integrations/#{integration}/edit")

      assert index_live
             |> form("#integration-form", integration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#integration-form", integration: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/integrations")

      html = render(index_live)
      assert html =~ "Integration updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes integration in listing", %{conn: conn, integration: integration} do
      {:ok, index_live, _html} = live(conn, ~p"/integrations")

      assert index_live
             |> element("#integrations-#{integration.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#integrations-#{integration.id}")
    end
  end

  describe "Show" do
    setup [:create_integration]

    test "displays integration", %{conn: conn, integration: integration} do
      {:ok, _show_live, html} = live(conn, ~p"/integrations/#{integration}")

      assert html =~ "Show Integration"
      assert html =~ integration.description
    end

    test "updates integration within modal", %{conn: conn, integration: integration} do
      {:ok, show_live, _html} = live(conn, ~p"/integrations/#{integration}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Integration"

      assert_patch(show_live, ~p"/integrations/#{integration}/show/edit")

      assert show_live
             |> form("#integration-form", integration: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#integration-form", integration: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/integrations/#{integration}")

      html = render(show_live)
      assert html =~ "Integration updated successfully"
      assert html =~ "some updated description"
    end
  end
end
