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
        stripe_id: "some stripe_id",
        auth_id: Ecto.UUID.generate()
      })
      |> Sentrypeer.BillingSubscriptions.create_billing_subscription()

    billing_subscription
  end
end
