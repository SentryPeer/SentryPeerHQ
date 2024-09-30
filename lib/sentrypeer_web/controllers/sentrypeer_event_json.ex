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

defmodule SentrypeerWeb.SentrypeerEventJSON do
  alias Sentrypeer.SentrypeerEvents.SentrypeerEvent

  @moduledoc """
  Renders a list of sentrypeerevents.
  """
  def index(%{events: sentrypeerevents}) do
    %{data: for(sentrypeer_event <- sentrypeerevents, do: data(sentrypeer_event))}
  end

  @doc """
  Renders a single sentrypeer_event.
  """
  def show(%{event: sentrypeer_event}) do
    %{data: data(sentrypeer_event)}
  end

  defp data(%SentrypeerEvent{} = sentrypeer_event) do
    %{
      app_name: sentrypeer_event.app_name,
      app_version: sentrypeer_event.app_version,
      event_timestamp: sentrypeer_event.event_timestamp,
      event_uuid: sentrypeer_event.event_uuid,
      created_by_node_id: sentrypeer_event.created_by_node_id,
      collected_method: sentrypeer_event.collected_method,
      transport_type: sentrypeer_event.transport_type,
      source_ip: sentrypeer_event.source_ip,
      destination_ip: sentrypeer_event.destination_ip,
      called_number: sentrypeer_event.called_number,
      sip_method: sentrypeer_event.sip_method,
      sip_user_agent: sentrypeer_event.sip_user_agent,
      sip_message: sentrypeer_event.sip_message
    }
  end
end
