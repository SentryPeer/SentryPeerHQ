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

defmodule SentrypeerWeb.PageController do
  use SentrypeerWeb, :controller

  # Top Nav
  def partners(conn, _params) do
    render(conn, :partners,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Partners"
    )
  end

  def about(conn, _params) do
    render(conn, :about,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "About"
    )
  end

  def jobs(conn, _params) do
    render(conn, :jobs,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Jobs"
    )
  end

  # Support
  def documentation(conn, _params) do
    render(conn, :documentation,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Documentation"
    )
  end

  def guides(conn, _params) do
    render(conn, :guides,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Guides"
    )
  end

  def changelog(conn, _params) do
    render(conn, :changelog,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Changelog"
    )
  end

  # Sectors
  def advanced_users(conn, _params) do
    render(conn, :advanced_users,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Advanced Users"
    )
  end

  def itsps(conn, _params) do
    render(conn, :itsps,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Internet Telephony Service Providers"
    )
  end

  def cybersecurity(conn, _params) do
    render(conn, :cybersecurity,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Cybersecurity"
    )
  end

  def telecom_resellers(conn, _params) do
    render(conn, :telecom_resellers,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Telecom Resellers"
    )
  end

  def privacy_policy(conn, _params) do
    render(conn, :privacy_policy,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Privacy Policy"
    )
  end

  def terms_and_conditions(conn, _params) do
    render(conn, :terms_and_conditions,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Terms and Conditions"
    )
  end

  def acceptable_use_policy(conn, _params) do
    render(conn, :acceptable_use_policy,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Acceptable Use Policy"
    )
  end

  def cookie_policy(conn, _params) do
    render(conn, :cookie_policy,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Cookie Policy"
    )
  end
end
