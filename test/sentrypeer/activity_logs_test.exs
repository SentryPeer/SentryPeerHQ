defmodule Sentrypeer.ActivityLogsTest do
  use Sentrypeer.DataCase

  alias Sentrypeer.ActivityLogs

  describe "activity_logs" do
    alias Sentrypeer.ActivityLogs.ActivityLog

    import Sentrypeer.ActivityLogsFixtures

    @invalid_attrs %{data: nil, event: nil, ip_address: nil, user_agent: nil}

    test "list_activity_logs/0 returns all activity_logs" do
      activity_log = activity_log_fixture()
      assert ActivityLogs.list_activity_logs() == [activity_log]
    end

    test "get_activity_log!/1 returns the activity_log with given id" do
      activity_log = activity_log_fixture()
      assert ActivityLogs.get_activity_log!(activity_log.id) == activity_log
    end

    test "create_activity_log/1 with valid data creates a activity_log" do
      valid_attrs = %{
        data: %{},
        event: "some event",
        ip_address: "some ip_address",
        user_agent: "some user_agent"
      }

      assert {:ok, %ActivityLog{} = activity_log} = ActivityLogs.create_activity_log(valid_attrs)
      assert activity_log.data == %{}
      assert activity_log.event == "some event"
      assert activity_log.ip_address == "some ip_address"
      assert activity_log.user_agent == "some user_agent"
    end

    test "create_activity_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ActivityLogs.create_activity_log(@invalid_attrs)
    end

    test "update_activity_log/2 with valid data updates the activity_log" do
      activity_log = activity_log_fixture()

      update_attrs = %{
        data: %{},
        event: "some updated event",
        ip_address: "some updated ip_address",
        user_agent: "some updated user_agent"
      }

      assert {:ok, %ActivityLog{} = activity_log} =
               ActivityLogs.update_activity_log(activity_log, update_attrs)

      assert activity_log.data == %{}
      assert activity_log.event == "some updated event"
      assert activity_log.ip_address == "some updated ip_address"
      assert activity_log.user_agent == "some updated user_agent"
    end

    test "update_activity_log/2 with invalid data returns error changeset" do
      activity_log = activity_log_fixture()

      assert {:error, %Ecto.Changeset{}} =
               ActivityLogs.update_activity_log(activity_log, @invalid_attrs)

      assert activity_log == ActivityLogs.get_activity_log!(activity_log.id)
    end

    test "delete_activity_log/1 deletes the activity_log" do
      activity_log = activity_log_fixture()
      assert {:ok, %ActivityLog{}} = ActivityLogs.delete_activity_log(activity_log)
      assert_raise Ecto.NoResultsError, fn -> ActivityLogs.get_activity_log!(activity_log.id) end
    end

    test "change_activity_log/1 returns a activity_log changeset" do
      activity_log = activity_log_fixture()
      assert %Ecto.Changeset{} = ActivityLogs.change_activity_log(activity_log)
    end
  end
end
