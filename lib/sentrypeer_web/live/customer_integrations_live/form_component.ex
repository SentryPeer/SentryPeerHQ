defmodule SentrypeerWeb.CustomerIntegrationsLive.FormComponent do
  use SentrypeerWeb, :live_component

  alias Sentrypeer.Accounts
  alias Sentrypeer.Integrations

  require Logger

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          <%= @subtitle %>
        </:subtitle>
      </.header>
      <div class="mt-10 sm:mt-0 grid grid-cols-1 gap-x-6 gap-y-8 sm:grid-cols-4">
        <%= if @test_message_sent do %>
          <div class="mt-5 sm:col-span-4">
            <div class="rounded-md bg-green-50 dark:bg-slate-400 p-4">
              <div class="flex">
                <div class="flex-shrink-0">
                  <Heroicons.check_circle class="h-5 w-5 text-green-400 dark:text-slate-800" />
                </div>
                <div class="ml-3">
                  <p class="text-sm leading-5 font-medium text-green-800 dark:text-slate-800">
                    Test message sent successfully.
                  </p>
                </div>
              </div>
            </div>
          </div>
        <% end %>
        <%= if @integration_type == "email" && @integration.enabled do %>
          <.button class="sm:col-span-1 sm:col-start-4" phx-click="test" value="email">Test</.button>
        <% end %>

        <%= if @integration_type == "slack" && @integration.enabled do %>
          <.link
            href="https://api.slack.com/messaging/webhooks"
            target="_blank"
            rel="noopener noreferrer"
            title="External link to the official Slack documentation for Webhooks"
            class="mt-4 text-sm sm:col-span-3 sm:col-start-1 text-indigo-600 hover:text-brand"
          >
            https://api.slack.com/messaging/webhooks
            <Heroicons.arrow_top_right_on_square class="inline-block w-4 h-4" />
          </.link>
          <.button class="sm:col-span-1 sm:col-start-4" phx-click="test" value="slack">Test</.button>
        <% end %>

        <%= if @integration_type == "webhook" && @integration.enabled do %>
          <.link
            href="https://docs.sentrypeer.com/webhooks"
            target="_blank"
            rel="noopener noreferrer"
            title="External link to the official SentryPeer documentation for Webhooks"
            class="mt-4 text-sm sm:col-span-3 sm:col-start-1 text-indigo-600 hover:text-brand"
          >
            https://docs.sentrypeer.com/webhooks
            <Heroicons.arrow_top_right_on_square class="inline-block w-4 h-4" />
          </.link>
          <.button class="sm:col-span-1 sm:col-start-4" phx-click="test" value="webhook">
            Test
          </.button>
        <% end %>
      </div>

      <.simple_form
        for={@form}
        id="integration-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <div class="float-right">
          <.input field={@form[:enabled]} type="checkbox" phx-debounce="blur" label="Enabled" />
        </div>
        <.input field={@form[:subject]} type="text" phx-debounce="blur" label="Subject" />
        <.input field={@form[:message]} type="textarea" phx-debounce="blur" label="Message" />
        <%= if @integration_type == "email" do %>
          <.input field={@form[:url]} type="email" phx-debounce="blur" label="Email" />
        <% else %>
          <.input field={@form[:url]} type="url" phx-debounce="blur" label="WebHook Url" />
        <% end %>
        <:actions>
          <.button phx-disable-with="Saving...">Save Integration</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{integration: integration} = assigns, socket) do
    changeset = Integrations.change_integration(integration)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"integration" => integration_params}, socket) do
    changeset =
      socket.assigns.integration
      |> Integrations.change_integration(integration_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"integration" => integration_params}, socket) do
    save_integration(socket, socket.assigns.action, integration_params)
  end

  defp save_integration(socket, :email_edit, integration_params) do
    update_integration(socket, integration_params)
  end

  defp save_integration(socket, :slack_edit, integration_params) do
    update_integration(socket, integration_params)
  end

  defp save_integration(socket, :webhook_edit, integration_params) do
    update_integration(socket, integration_params)
  end

  defp save_integration(socket, :email_new, integration_params) do
    integration_params
    |> Map.put("name", "Email")
    |> Map.put("description", "Email integration")
    |> Map.put("type", "email")
    |> Map.put(
      "auth_id",
      Accounts.get_user_by_auth_id(socket.assigns.current_user.id).id
    )
    |> save_integration(socket)
  end

  defp save_integration(socket, :slack_new, integration_params) do
    integration_params
    |> Map.put("name", "Slack")
    |> Map.put("description", "Slack integration")
    |> Map.put("type", "slack")
    |> Map.put(
      "auth_id",
      Accounts.get_user_by_auth_id(socket.assigns.current_user.id).id
    )
    |> save_integration(socket)
  end

  defp save_integration(socket, :webhook_new, integration_params) do
    integration_params
    |> Map.put("name", "Webhook")
    |> Map.put("description", "Webhook integration")
    |> Map.put("type", "webhook")
    |> Map.put(
      "auth_id",
      Accounts.get_user_by_auth_id(socket.assigns.current_user.id).id
    )
    |> save_integration(socket)
  end

  defp save_integration(integration_params, socket) do
    Logger.debug("Integration params: #{inspect(integration_params)}")

    case Integrations.create_integration(integration_params) do
      {:ok, integration} ->
        notify_parent({:saved, integration})

        {:noreply,
         socket
         |> put_flash(:info, "Integration created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp update_integration(socket, integration_params) do
    Logger.debug("Integration params: #{inspect(integration_params)}")

    case Integrations.update_integration(socket.assigns.integration, integration_params) do
      {:ok, integration} ->
        notify_parent({:saved, integration})

        {:noreply,
         socket
         |> put_flash(:info, "Integration updated successfully")
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
