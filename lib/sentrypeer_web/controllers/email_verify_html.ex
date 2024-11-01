# SPDX-License-Identifier: AGPL-3.0
# Copyright (c) 2023 - 2024 Gavin Henry <ghenry@sentrypeer.org>
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

defmodule SentrypeerWeb.EmailVerifyHTML do
  use SentrypeerWeb, :html

  @moduledoc """
  This module is used to generate the HTML for the email confirmation page.
  """

  embed_templates "email_verify_html/*"
end
