defmodule Sentrypeer.ActivityLogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sentrypeer.ActivityLogs` context.
  """

  @doc """
  Generate a activity_log.
  """
  def activity_log_fixture(attrs \\ %{}) do
    {:ok, activity_log} =
      attrs
      |> Enum.into(%{
        data: %{},
        event: "some event",
        ip_address: "some ip_address",
        user_agent: "some user_agent"
      })
      |> Sentrypeer.ActivityLogs.create_activity_log()

    activity_log
  end
end
