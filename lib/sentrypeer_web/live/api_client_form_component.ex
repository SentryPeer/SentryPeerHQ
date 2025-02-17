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

defmodule SentrypeerWeb.Live.APIClientFormComponent do
  use SentrypeerWeb, :live_component

  alias Sentrypeer.CustomerClients
  alias Sentrypeer.Emails.EmailError
  alias Sentrypeer.Mailer

  @moduledoc """
  This component is used to render the form for creating and editing
  API and Node clients.
  """

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Give your {@client_desc} some memorable details</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="client-form"
        autocomplete="off"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:client_name]} type="text" label="Name" />
        <.input field={@form[:client_description]} type="textarea" label="Description" />
        <:actions>
          <.button phx-disable-with="Saving...">Save {@client_desc}</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{client: client} = assigns, socket) do
    changeset = CustomerClients.change_client(client)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"client" => client_params}, socket) do
    changeset =
      socket.assigns.client
      |> CustomerClients.change_client(client_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"client" => client_params}, socket) do
    Logger.debug("Live action is: #{inspect(socket.assigns.action)}")
    save_client(socket, socket.assigns.action, client_params)
  end

  defp save_client(socket, :edit, client_params) do
    case CustomerClients.update_client(
           socket.assigns.current_user.id,
           socket.assigns.client.client_id,
           client_params
         ) do
      {:ok, client} ->
        notify_parent({:saved, client})

        {:noreply,
         socket
         |> put_flash(:info, "Client updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_client(socket, :new, client_params) do
    Logger.debug("Client type is: #{inspect(socket.assigns.client_type)}")

    if CustomerClients.allowed_more_api_clients?(socket.assigns.current_user.id) do
      case CustomerClients.create_client(
             socket.assigns.current_user.id,
             socket.assigns.client_type,
             client_params
           ) do
        {:ok, client} ->
          notify_parent({:saved, client})

          {:noreply,
           socket
           |> put_flash(:info, "Client created successfully")
           |> push_patch(to: socket.assigns.patch)}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, assign_form(socket, changeset)}

        {:error, error} ->
          Logger.error("Failed to create client: #{inspect(error)}")

          EmailError.notify_admins(__MODULE__, inspect(error), socket.assigns.current_user.id)
          |> Mailer.deliver()

          {:noreply,
           socket
           |> put_flash(:error, "Failed to create client")
           |> push_patch(to: socket.assigns.patch)}
      end
    else
      {:noreply,
       socket
       |> put_flash(
         :error,
         "You have reached the maximum number of API clients in your plan. Please upgrade to create more."
       )
       |> push_patch(to: socket.assigns.patch)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    Logger.debug("Assigning form with changeset: #{inspect(changeset)}")
    assign(socket, form: to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
