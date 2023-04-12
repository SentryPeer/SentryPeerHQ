defmodule Sentrypeer.ContactFormFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sentrypeer.ContactForm` context.
  """

  @doc """
  Generate a contact.
  """
  def contact_fixture(attrs \\ %{}) do
    {:ok, contact} =
      attrs
      |> Enum.into(%{
        company_name: "some company_name",
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        message: "some message"
      })
      |> Sentrypeer.ContactForm.create_contact()

    contact
  end
end
