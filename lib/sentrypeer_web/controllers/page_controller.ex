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

defmodule SentrypeerWeb.PageController do
  use SentrypeerWeb, :controller

  # Top Nav
  def partners(conn, _params) do
    render(conn, :partners,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Partners",
      meta_description: "Why not join our Partner Programme?"
    )
  end

  def about(conn, _params) do
    render(conn, :about,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "About",
      meta_description:
        "Learn how SentryPeer® does Fraud Detection and Fraud Prevention for VoIP."
    )
  end

  def jobs(conn, _params) do
    render(conn, :jobs,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Jobs",
      meta_description: "We are hiring! Join our team."
    )
  end

  # Support
  def changelog(conn, _params) do
    render(conn, :changelog,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Changelog",
      meta_description: "See what's new in SentryPeer®."
    )
  end

  # Sectors
  def advanced_users(conn, _params) do
    render(conn, :advanced_users,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Advanced Users",
      meta_description: "Are you an Advanced User of VoIP? SentryPeer® can help you."
    )
  end

  def itsps(conn, _params) do
    render(conn, :itsps,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Internet Telephony Service Providers",
      meta_description:
        "Are you an ITSP? Learn how SentryPeer® can help you detect and prevent VoIP fraud."
    )
  end

  def cybersecurity(conn, _params) do
    render(conn, :cybersecurity,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Cybersecurity",
      meta_description:
        "Are you in Cybersecurity? Learn the trends SentryPeer® is seeing in VoIP fraud."
    )
  end

  def telecom_resellers(conn, _params) do
    render(conn, :telecom_resellers,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Telecom Resellers",
      meta_description:
        "Are you a Telecom Reseller? Learn how SentryPeer® can help you detect and prevent VoIP fraud."
    )
  end

  def privacy_policy(conn, _params) do
    render(conn, :privacy_policy,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Privacy Policy",
      meta_description: "SentryPeer® Privacy Policy"
    )
  end

  def terms_and_conditions(conn, _params) do
    render(conn, :terms_and_conditions,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Terms and Conditions",
      meta_description: "SentryPeer® Terms and Conditions"
    )
  end

  def acceptable_use_policy(conn, _params) do
    render(conn, :acceptable_use_policy,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Acceptable Use Policy",
      meta_description: "SentryPeer® Acceptable Use Policy"
    )
  end

  def cookie_policy(conn, _params) do
    render(conn, :cookie_policy,
      current_user: get_session(conn, :current_user),
      layout: false,
      show_newsletter_subscription: false,
      page_title: "Cookie Policy",
      meta_description: "SentryPeer® Cookie Policy"
    )
  end
end
