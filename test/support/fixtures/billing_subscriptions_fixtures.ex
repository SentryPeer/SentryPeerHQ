defmodule Sentrypeer.BillingSubscriptionsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Sentrypeer.BillingSubscriptions` context.
  """

  @doc """
  Generate a billing_subscription.
  """
  def billing_subscription_fixture(attrs \\ %{}) do
    {:ok, billing_subscription} =
      attrs
      |> Enum.into(%{
        cancel_at: ~N[2023-05-08 17:31:00],
        cancelled_at: ~N[2023-05-08 17:31:00],
        current_period_end_at: ~N[2023-05-08 17:31:00],
        current_period_start: ~N[2023-05-08 17:31:00],
        status: "some status",
        stripe_id: "some stripe_id"
      })
      |> Sentrypeer.BillingSubscriptions.create_billing_subscription()

    billing_subscription
  end
end
