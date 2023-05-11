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

defmodule Sentrypeer.ContactFormTest do
  use Sentrypeer.DataCase

  alias Sentrypeer.ContactForm

  describe "contacts" do
    alias Sentrypeer.ContactForm.Contact

    import Sentrypeer.ContactFormFixtures

    @invalid_attrs %{company_name: nil, email: nil, first_name: nil, last_name: nil, message: nil}

    test "list_contacts/0 returns all contacts" do
      contact = contact_fixture()
      assert ContactForm.list_contacts() == [contact]
    end

    test "get_contact!/1 returns the contact with given id" do
      contact = contact_fixture()
      assert ContactForm.get_contact!(contact.id) == contact
    end

    test "create_contact/1 with valid data creates a contact" do
      valid_attrs = %{
        company_name: "some company_name",
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        message: "some message"
      }

      assert {:ok, %Contact{} = contact} = ContactForm.create_contact(valid_attrs)
      assert contact.company_name == "some company_name"
      assert contact.email == "some email"
      assert contact.first_name == "some first_name"
      assert contact.last_name == "some last_name"
      assert contact.message == "some message"
    end

    test "create_contact/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ContactForm.create_contact(@invalid_attrs)
    end

    test "update_contact/2 with valid data updates the contact" do
      contact = contact_fixture()

      update_attrs = %{
        company_name: "some updated company_name",
        email: "some updated email",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        message: "some updated message"
      }

      assert {:ok, %Contact{} = contact} = ContactForm.update_contact(contact, update_attrs)
      assert contact.company_name == "some updated company_name"
      assert contact.email == "some updated email"
      assert contact.first_name == "some updated first_name"
      assert contact.last_name == "some updated last_name"
      assert contact.message == "some updated message"
    end

    test "update_contact/2 with invalid data returns error changeset" do
      contact = contact_fixture()
      assert {:error, %Ecto.Changeset{}} = ContactForm.update_contact(contact, @invalid_attrs)
      assert contact == ContactForm.get_contact!(contact.id)
    end

    test "delete_contact/1 deletes the contact" do
      contact = contact_fixture()
      assert {:ok, %Contact{}} = ContactForm.delete_contact(contact)
      assert_raise Ecto.NoResultsError, fn -> ContactForm.get_contact!(contact.id) end
    end

    test "change_contact/1 returns a contact changeset" do
      contact = contact_fixture()
      assert %Ecto.Changeset{} = ContactForm.change_contact(contact)
    end
  end
end
