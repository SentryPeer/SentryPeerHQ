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

defmodule Sentrypeer.BillingSubscriptions do
  @moduledoc """
  The BillingSubscriptions context.
  """

  import Ecto.Query, warn: false
  alias Sentrypeer.Repo

  alias Sentrypeer.Accounts
  alias Sentrypeer.BillingSubscriptions.BillingSubscription

  require Logger

  @doc """
  Returns the list of billing_subscriptions.

  ## Examples

      iex> list_billing_subscriptions()
      [%BillingSubscription{}, ...]

  """
  def list_billing_subscriptions do
    Repo.all(BillingSubscription)
  end

  @doc """
  Gets a single billing_subscription.

  Raises `Ecto.NoResultsError` if the Billing subscription does not exist.

  ## Examples

      iex> get_billing_subscription!(123)
      %BillingSubscription{}

      iex> get_billing_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_billing_subscription!(id), do: Repo.get!(BillingSubscription, id)

  @doc """
  Gets a single billing_subscription by auth_id.

  Raises `Ecto.NoResultsError` if the Billing subscription does not exist.

  ## Examples

      iex> get_billing_subscription!(123)
      %BillingSubscription{}

      iex> get_billing_subscription!(456)
      ** (Ecto.NoResultsError)

  """
  def get_billing_subscription_by_auth_id(auth_id),
    do: Repo.get_by(BillingSubscription, auth_id: auth_id)

  @doc """
  Creates a billing_subscription.

  ## Examples

      iex> create_billing_subscription(%{field: value})
      {:ok, %BillingSubscription{}}

      iex> create_billing_subscription(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_billing_subscription(attrs \\ %{}) do
    %BillingSubscription{}
    |> BillingSubscription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a billing_subscription.

  ## Examples

      iex> update_billing_subscription(billing_subscription, %{field: new_value})
      {:ok, %BillingSubscription{}}

      iex> update_billing_subscription(billing_subscription, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_billing_subscription(%BillingSubscription{} = billing_subscription, attrs) do
    billing_subscription
    |> BillingSubscription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a billing_subscription.

  ## Examples

      iex> delete_billing_subscription(billing_subscription)
      {:ok, %BillingSubscription{}}

      iex> delete_billing_subscription(billing_subscription)
      {:error, %Ecto.Changeset{}}

  """
  def delete_billing_subscription(%BillingSubscription{} = billing_subscription) do
    Repo.delete(billing_subscription)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking billing_subscription changes.

  ## Examples

      iex> change_billing_subscription(billing_subscription)
      %Ecto.Changeset{data: %BillingSubscription{}}

  """
  def change_billing_subscription(%BillingSubscription{} = billing_subscription, attrs \\ %{}) do
    BillingSubscription.changeset(billing_subscription, attrs)
  end

  def get_subscription_from_stripe(cust_id) do
    Logger.debug("Customer ID: #{inspect(cust_id)}")

    stripe_id = get_stripe_id(cust_id)
    Logger.debug("Stripe ID: #{inspect(stripe_id)}")

    case Stripe.Subscription.list(%{customer: stripe_id}) do
      {:ok, subscription} ->
        Logger.debug("Subscription: #{inspect(subscription)}")
        subscription

      {:error, error} ->
        Logger.error("Subscription Error: #{inspect(error)}")
        error
    end
  end

  @doc """
  Gets a single subscription by Stripe Id.

  Raises `Ecto.NoResultsError` if the Subscription does not exist.

  ## Examples

      iex> get_subscription_by_stripe_id!(123)
      %Subscription{}

      iex> get_subscription_by_stripe_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_subscription_by_stripe_id!(stripe_id),
    do: Repo.get_by!(BillingSubscription, stripe_id: stripe_id)

  def get_billing_email(cust_id) do
    stripe_id = get_stripe_id(cust_id)

    case Stripe.Customer.retrieve(stripe_id) do
      {:ok, customer} ->
        Logger.debug("Customer: #{inspect(customer)}")
        customer.email

      {:error, error} ->
        error
    end
  end

  def get_invoices(cust_id) do
    stripe_id = get_stripe_id(cust_id)

    case Stripe.Invoice.list(%{customer: stripe_id}) do
      {:ok, invoices} ->
        Logger.debug("Invoices: #{inspect(invoices)}")
        invoices

      {:error, error} ->
        error
    end
  end

  def get_upcoming_invoice(cust_id) do
    stripe_id = get_stripe_id(cust_id)

    case Stripe.Invoice.upcoming(%{customer: stripe_id}) do
      {:ok, invoice} ->
        Logger.debug("Upcoming Invoice: #{inspect(invoice)}")
        invoice

      {:error, error} ->
        error
    end
  end

  def get_payment_methods(cust_id) do
    stripe_id = get_stripe_id(cust_id)

    case Stripe.PaymentMethod.list(%{customer: stripe_id}) do
      {:ok, payment_methods} ->
        Logger.debug("Customer Payment Methods: #{inspect(payment_methods)}")
        payment_methods

      {:error, error} ->
        error
    end
  end

  defp get_stripe_id(auth_id) do
    Accounts.get_user_stripe_id(auth_id).billing_subscription.stripe_id
  end

  @doc """
  Gets a single active subscription for a billing customer.

  Returns `nil` if an active Subscription does not exist.

  ## Examples

      iex> get_active_subscription_for_customer(123)
      %Subscription{}

      iex> get_active_subscription_for_customer(456)
      nil

  """
  def get_active_subscription_for_user(user) do
    from(s in BillingSubscription,
      join: u in assoc(s, :user),
      where: u.id == ^user.id,
      where: is_nil(s.cancel_at) or s.cancel_at > ^NaiveDateTime.utc_now(),
      where: s.current_period_end_at > ^NaiveDateTime.utc_now(),
      where: s.status == "active",
      limit: 1
    )
    |> Repo.one()
  end
end
