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

defmodule SentrypeerWeb.ContactLive.FormComponent do
  use SentrypeerWeb, :live_component

  alias Sentrypeer.ContactForm
  alias Sentrypeer.Emails.EmailContactForm
  alias Sentrypeer.Mailer

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Please use below to send us a message</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="contact-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:first_name]} type="text" phx-debounce="blur" label="First name" />
        <.input field={@form[:last_name]} type="text" phx-debounce="blur" label="Last name" />
        <.input field={@form[:company_name]} type="text" phx-debounce="blur" label="Company name" />
        <.input field={@form[:email]} type="email" phx-debounce="blur" label="Email" />
        <.input field={@form[:message]} type="textarea" label="Message" />
        <:actions>
          <.button phx-disable-with="Sending...">Send Message</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{contact: contact} = assigns, socket) do
    changeset = ContactForm.change_contact(contact)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"contact" => contact_params}, socket) do
    changeset =
      socket.assigns.contact
      |> ContactForm.change_contact(contact_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"contact" => contact_params}, socket) do
    save_contact(socket, socket.assigns.action, contact_params)
  end

  defp save_contact(socket, :new, contact_params) do
    case ContactForm.create_contact(contact_params) do
      {:ok, contact} ->
        notify_parent({:saved, contact})

        # Send the contact to the sales team
        EmailContactForm.notify_sales(contact)
        |> Mailer.deliver()

        {:noreply,
         socket
         |> put_flash(:info, "Message received. Thank you.")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
