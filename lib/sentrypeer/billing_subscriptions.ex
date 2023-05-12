defmodule Sentrypeer.BillingSubscriptions do
  @moduledoc """
  The BillingSubscriptions context.
  """

  import Ecto.Query, warn: false
  alias Sentrypeer.Repo

  alias Sentrypeer.BillingSubscriptions.BillingSubscription
  alias Sentrypeer.Accounts

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

  def get_subscription(cust_id) do
    stripe_id = get_stripe_id(cust_id)

    case Stripe.Subscription.list(%{customer: stripe_id}) do
      {:ok, subscription} ->
        Logger.debug("Subscription: #{inspect(subscription)}")
        subscription

      {:error, error} ->
        Logger.error("Subscription Error: #{inspect(error)}")
        error
    end
  end

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

  defp get_stripe_id(auth_id) do
    Accounts.get_user_stripe_id(auth_id).billing_subscription.stripe_id
  end
end
