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

defmodule SentrypeerWeb.ContactLive.Index do
  use SentrypeerWeb, :live_view

  alias Sentrypeer.ContactForm.Contact
  alias Sentrypeer.Newsletter
  import SentrypeerWeb.HomePageComponents

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     assign(socket,
       current_user: session["current_user"],
       page_title: "Contact SentryPeer",
       show_newsletter_subscription: true,
       live_action: :index
     )}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Contact SentryPeer Sales")
    |> assign(:contact, %Contact{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:contact, nil)
  end

  @impl true
  def handle_info({SentrypeerWeb.ContactLive.FormComponent, {:saved, _contact}}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("subscribe", %{"email" => email_address}, socket) do
    subscribe(socket, socket.assigns.live_action, email_address)
  end

  defp subscribe(socket, :index, email_address) do
    Newsletter.subscribe(email_address)

    {:noreply,
     socket
     |> put_flash(:info, "Subscribe request received. Thank you!")}
  end
end
