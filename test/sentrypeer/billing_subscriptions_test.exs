# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2026 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule Sentrypeer.BillingSubscriptionsTest do
  use Sentrypeer.DataCase

  alias Sentrypeer.BillingSubscriptions

  describe "billing_subscriptions" do
    alias Sentrypeer.BillingSubscriptions.BillingSubscription

    import Sentrypeer.BillingSubscriptionsFixtures

    @invalid_attrs %{
      cancel_at: nil,
      cancelled_at: nil,
      current_period_end_at: nil,
      current_period_start: nil,
      status: nil,
      stripe_id: nil
    }

    test "list_billing_subscriptions/0 returns all billing_subscriptions" do
      billing_subscription = billing_subscription_fixture()
      assert BillingSubscriptions.list_billing_subscriptions() == [billing_subscription]
    end

    test "get_billing_subscription!/1 returns the billing_subscription with given id" do
      billing_subscription = billing_subscription_fixture()

      assert BillingSubscriptions.get_billing_subscription!(billing_subscription.id) ==
               billing_subscription
    end

    test "create_billing_subscription/1 with valid data creates a billing_subscription" do
      valid_attrs = %{
        cancel_at: ~N[2023-05-08 17:31:00],
        cancelled_at: ~N[2023-05-08 17:31:00],
        current_period_end_at: ~N[2023-05-08 17:31:00],
        current_period_start: ~N[2023-05-08 17:31:00],
        status: "some status",
        stripe_id: "some stripe_id"
      }

      assert {:ok, %BillingSubscription{} = billing_subscription} =
               BillingSubscriptions.create_billing_subscription(valid_attrs)

      assert billing_subscription.cancel_at == ~N[2023-05-08 17:31:00]
      assert billing_subscription.cancelled_at == ~N[2023-05-08 17:31:00]
      assert billing_subscription.current_period_end_at == ~N[2023-05-08 17:31:00]
      assert billing_subscription.current_period_start == ~N[2023-05-08 17:31:00]
      assert billing_subscription.status == "some status"
      assert billing_subscription.stripe_id == "some stripe_id"
    end

    test "create_billing_subscription/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               BillingSubscriptions.create_billing_subscription(@invalid_attrs)
    end

    test "update_billing_subscription/2 with valid data updates the billing_subscription" do
      billing_subscription = billing_subscription_fixture()

      update_attrs = %{
        cancel_at: ~N[2023-05-09 17:31:00],
        cancelled_at: ~N[2023-05-09 17:31:00],
        current_period_end_at: ~N[2023-05-09 17:31:00],
        current_period_start: ~N[2023-05-09 17:31:00],
        status: "some updated status",
        stripe_id: "some updated stripe_id"
      }

      assert {:ok, %BillingSubscription{} = billing_subscription} =
               BillingSubscriptions.update_billing_subscription(
                 billing_subscription,
                 update_attrs
               )

      assert billing_subscription.cancel_at == ~N[2023-05-09 17:31:00]
      assert billing_subscription.cancelled_at == ~N[2023-05-09 17:31:00]
      assert billing_subscription.current_period_end_at == ~N[2023-05-09 17:31:00]
      assert billing_subscription.current_period_start == ~N[2023-05-09 17:31:00]
      assert billing_subscription.status == "some updated status"
      assert billing_subscription.stripe_id == "some updated stripe_id"
    end

    test "update_billing_subscription/2 with invalid data returns error changeset" do
      billing_subscription = billing_subscription_fixture()

      assert {:error, %Ecto.Changeset{}} =
               BillingSubscriptions.update_billing_subscription(
                 billing_subscription,
                 @invalid_attrs
               )

      assert billing_subscription ==
               BillingSubscriptions.get_billing_subscription!(billing_subscription.id)
    end

    test "delete_billing_subscription/1 deletes the billing_subscription" do
      billing_subscription = billing_subscription_fixture()

      assert {:ok, %BillingSubscription{}} =
               BillingSubscriptions.delete_billing_subscription(billing_subscription)

      assert_raise Ecto.NoResultsError, fn ->
        BillingSubscriptions.get_billing_subscription!(billing_subscription.id)
      end
    end

    test "change_billing_subscription/1 returns a billing_subscription changeset" do
      billing_subscription = billing_subscription_fixture()

      assert %Ecto.Changeset{} =
               BillingSubscriptions.change_billing_subscription(billing_subscription)
    end
  end
end
