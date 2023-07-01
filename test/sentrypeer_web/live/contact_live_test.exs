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

defmodule SentrypeerWeb.ContactLiveTest do
  use SentrypeerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Sentrypeer.ContactFormFixtures

  @create_attrs %{
    company_name: "some company_name",
    email: "some email",
    first_name: "some first_name",
    last_name: "some last_name",
    message: "some message"
  }
  @update_attrs %{
    company_name: "some updated company_name",
    email: "some updated email",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    message: "some updated message"
  }
  @invalid_attrs %{company_name: nil, email: nil, first_name: nil, last_name: nil, message: nil}

  defp create_contact(_) do
    contact = contact_fixture()
    %{contact: contact}
  end

  describe "Index" do
    setup [:create_contact]

    test "lists all contacts", %{conn: conn, contact: contact} do
      {:ok, _index_live, html} = live(conn, ~p"/contacts")

      assert html =~ "Listing Contacts"
      assert html =~ contact.company_name
    end

    test "saves new contact", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/contact")

      assert index_live |> element("a", "New Contact") |> render_click() =~
               "New Contact"

      assert_patch(index_live, ~p"/contact/new")

      assert index_live
             |> form("#contact-form", contact: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#contact-form", contact: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/contact")

      html = render(index_live)
      assert html =~ "Contact created successfully"
      assert html =~ "some company_name"
    end
  end
end
