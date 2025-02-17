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

defmodule Sentrypeer.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Sentrypeer.Repo

  alias Sentrypeer.Accounts.User
  alias Sentrypeer.Auth.Auth0ManagementAPI
  alias Sentrypeer.Auth.Auth0User
  alias Sentrypeer.BillingHelpers
  alias Sentrypeer.BillingSubscriptions

  require Logger

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user by auth_id.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_auth_id(123)
      %User{}

      iex> get_user_by_auth_id(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_by_auth_id(auth_id), do: Repo.get_by(User, auth_id: auth_id)

  @doc """
  Gets a single user by auth_id with their integrations.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_auth_id_with_integrations(123)
      %User{}

      iex> get_user_by_auth_id_with_integrations(456)
      ** (Ecto.NoResultsError)

  """

  def get_user_by_auth_id_with_integrations(auth_id) do
    Repo.get_by(User, auth_id: auth_id)
    |> Repo.preload(:integrations)
  end

  @doc """
  Gets a users stripe_id.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_stripe_id(123)
      %User{}

      iex> get_user_stripe_id(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_stripe_id(auth_id) do
    Repo.get_by(User, auth_id: auth_id)
    |> Repo.preload(:billing_subscription)
  end

  @doc """
  Gets a single user by Stripe Id.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user_by_stripe_id!(123)
      %User{}

      iex> get_user_by_stripe_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_by_stripe_id!(stripe_id) do
    Repo.get_by!(BillingSubscriptions.BillingSubscription, stripe_id: stripe_id)
    |> Repo.preload(:user)
  end

  @doc """
  Creates a user with a default subscription on the Tester Plan.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()

    case create_user_subscription(attrs) do
      {:ok, subscription} ->
        {:ok, subscription}

      {:error, changeset} ->
        Logger.error("create_user: #{inspect(changeset)}")
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Finds or creates a user. Doesn't find one is enabled = false.

  ## Examples

      iex> find_or_create_user(user)
      %User{}

  """
  def find_or_create_user(attrs \\ %{}) do
    Logger.debug("find_or_create_user: #{inspect(attrs)}")

    case find_enabled_user(attrs.auth_id) do
      nil ->
        case create_user(attrs) do
          {:ok, user} ->
            user

          {:error, changeset} ->
            Logger.error("find_or_create_user: #{inspect(changeset)}")
            nil

          _ ->
            nil
        end

      user ->
        user
    end
  end

  defp find_enabled_user(auth_id) do
    Repo.get_by(User, auth_id: auth_id, enabled: true)
  end

  defp create_user_subscription(attrs) do
    Logger.debug("create_user_subscription: #{inspect(attrs)}")

    # Check if the user exists on Stripe first
    case Stripe.Customer.list(%{email: attrs.email}) do
      {:ok, %{data: [customer | _]}} ->
        Logger.debug("create_user_subscription: #{inspect(customer)}")
        # If the user exists, create a subscription
        create_billing_subscription(attrs, customer.id)

      {:ok, %{data: []}} ->
        Logger.debug("create_user_subscription: #{inspect(attrs)}")
        # If the user doesn't exist, create a customer first then a subscription
        create_stripe_customer(attrs)

      {:error, changeset} ->
        Logger.error("create_user_subscription: #{inspect(changeset)}")
        {:error, changeset}
    end
  end

  defp create_stripe_customer(attrs) do
    Logger.debug("create_stripe_customer: #{inspect(attrs)}")

    case Auth0ManagementAPI.get_user(attrs.auth_id) do
      {:ok, user} ->
        case Stripe.Customer.create(%{
               email: attrs.email,
               tax: %{ip_address: user["last_ip"]}
             }) do
          {:ok, customer} ->
            Logger.debug("create_user_subscription: #{inspect(customer)}")
            create_billing_subscription(attrs, customer.id)

          {:error, changeset} ->
            Logger.error("create_user_subscription: #{inspect(changeset)}")
            {:error, changeset}
        end

      {:error, error} ->
        Logger.error("Can't retrieve user from Auth0: #{inspect(error)}")
        {:error, error}
    end
  end

  defp check_for_existing_billing_subscription(attrs) do
    Logger.debug("check_for_existing_billing_subscription: #{inspect(attrs)}")

    case get_user_by_auth_id(attrs.auth_id) do
      nil ->
        Logger.debug("check_for_existing_billing_subscription: no user found")
        {:ok, nil}

      user ->
        Logger.debug("check_for_existing_billing_subscription: #{inspect(user)}")

        case BillingSubscriptions.get_billing_subscription_by_auth_id(user.id) do
          nil ->
            Logger.debug("check_for_existing_billing_subscription: no subscription found")
            {:ok, attrs}

          subscription ->
            Logger.debug("check_for_existing_billing_subscription: #{inspect(subscription)}")
            {:error, subscription}
        end
    end
  end

  defp create_billing_subscription(attrs, customer_id) do
    case check_for_existing_billing_subscription(attrs) do
      {:ok, _} ->
        Logger.debug("create_billing_subscription: no existing subscription found")

        case create_stripe_and_local_subscription(attrs, customer_id) do
          {:ok, subscription} ->
            Logger.debug("create_billing_subscription: #{inspect(subscription)}")
            {:ok, subscription}

          {:error, changeset} ->
            Logger.error("create_billing_subscription: #{inspect(changeset)}")
            {:error, changeset}
        end

      {:error, subscription} ->
        Logger.debug("create_billing_subscription: existing subscription found")
        {:error, subscription}
    end
  end

  defp create_stripe_and_local_subscription(attrs, customer_id) do
    Logger.debug("create_stripe_and_local_subscription: #{inspect(attrs)}")

    case Stripe.Subscription.create(%{
           customer: customer_id,
           items: [
             %{
               price: System.get_env("STRIPE_TESTER_PLAN_ID"),
               quantity: 1
             }
           ],
           billing_cycle_anchor: BillingHelpers.first_of_next_month_unix(),
           automatic_tax: %{enabled: true}
         }) do
      {:ok, subscription} ->
        Logger.debug("create_billing_subscription: #{inspect(subscription)}")

        our_sub = %{
          cancel_at: subscription.cancel_at,
          cancelled_at: subscription.canceled_at,
          current_period_end_at: DateTime.from_unix!(subscription.current_period_end),
          current_period_start: DateTime.from_unix!(subscription.current_period_start),
          status: subscription.status,
          stripe_id: subscription.customer,
          auth_id: get_user_by_auth_id(attrs.auth_id).id
        }

        case BillingSubscriptions.create_billing_subscription(our_sub) do
          {:ok, subscription} ->
            Logger.debug("create_billing_subscription: #{inspect(our_sub)}")

            # Enable the tester plan for the user
            user_for_flags = %Auth0User{id: attrs.auth_id}
            FunWithFlags.enable(:tester_plan, for_actor: user_for_flags)

            # Send a welcome email

            {:ok, subscription}

          {:error, changeset} ->
            Logger.error("create_billing_subscription: #{inspect(changeset)}")
            {:error, changeset}
        end

      {:error, changeset} ->
        Logger.error("create_billing_subscription: #{inspect(changeset)}")
        {:error, changeset}
    end
  end
end
