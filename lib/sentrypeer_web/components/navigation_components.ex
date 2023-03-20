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

defmodule SentrypeerWeb.NavigationComponents do
  use SentrypeerWeb, :html

  import SentrypeerWeb.CoreComponents

  def breadcrumbs(assigns) do
    ~H"""
    <!-- Breadcrumbs -->
    <nav class="flex border-b border-gray-200 bg-white" aria-label="Breadcrumb">
      <ol role="list" class="mx-auto flex w-full max-w-screen-xl space-x-4 px-4 sm:px-6 lg:px-12">
        <li class="flex">
          <div class="flex items-center">
            <.link
              navigate={~p"/dashboard"}
              title="SentryPeer Dashboard"
              class={"#{if @active_tab == :dashboard,
                do: "ml-4 text-sm font-medium hover:text-gray-700", else: "ml-4 text-sm text-gray-500 hover:text-gray-700"}"}
            >
              Dashboard <span class="sr-only">Dashboard</span>
            </.link>
          </div>
        </li>

        <%= if @active_tab == :dashboard do %>
          <li class="flex">
            <div class="flex items-center">
              <svg
                class="h-full w-6 flex-shrink-0 text-gray-200"
                viewBox="0 0 24 44"
                preserveAspectRatio="none"
                fill="currentColor"
                aria-hidden="true"
              >
                <path d="M.293 0l22 22-22 22h1.414l22-22-22-22H.293z" />
              </svg>
            </div>
          </li>
        <% end %>

        <%= if (@active_tab == :nodes || @active_tab == :node_overview ) do %>
          <li class="flex">
            <div class="flex items-center">
              <svg
                class="h-full w-6 flex-shrink-0 text-gray-200"
                viewBox="0 0 24 44"
                preserveAspectRatio="none"
                fill="currentColor"
                aria-hidden="true"
              >
                <path d="M.293 0l22 22-22 22h1.414l22-22-22-22H.293z" />
              </svg>
              <.link
                navigate={~p"/nodes"}
                title="SentryPeer Nodes"
                class={"#{if @active_tab == :nodes,
                do: "ml-4 text-sm font-medium hover:text-gray-700", else: "ml-4 text-sm text-gray-500 hover:text-gray-700"}"}
              >
                Nodes
              </.link>
            </div>
          </li>
        <% end %>

        <%= if @active_tab == :node_overview do %>
          <li class="flex">
            <div class="flex items-center">
              <svg
                class="h-full w-6 flex-shrink-0 text-gray-200"
                viewBox="0 0 24 44"
                preserveAspectRatio="none"
                fill="currentColor"
                aria-hidden="true"
              >
                <path d="M.293 0l22 22-22 22h1.414l22-22-22-22H.293z" />
              </svg>
              <.link
                navigate={~p"/nodes/#{@node["client_id"]}"}
                title="SentryPeer Node"
                class="hidden md:block truncate ml-4 text-sm font-medium hover:text-gray-700"
              >
                <%= @node["client_id"] %>
              </.link>
            </div>
          </li>
        <% end %>
      </ol>
    </nav>
    """
  end

  def in_app_menu(assigns) do
    ~H"""
    <!-- In App Menu Action Buttons -->
    <nav class="space-y-1">
      <!-- Current: "bg-gray-50 text-indigo-700 hover:text-indigo-700 hover:bg-white", Default: "text-gray-900 hover:text-gray-900 hover:bg-gray-50" -->
      <a
        href="#"
        class="text-gray-900 hover:text-gray-900 hover:bg-gray-50 hover:bg-white group rounded-md px-3 py-2 flex items-center text-sm font-medium"
        aria-current="page"
      >
        <!-- Current: "text-indigo-500 group-hover:text-indigo-500", Default: "text-gray-400 group-hover:text-gray-500" -->
        <Heroicons.chart_pie
          outline
          class="text-gray-400 group-hover:text-gray-500 flex-shrink-0 -ml-1 mr-3 h-6 w-6"
        />
        <span class="truncate">Analytics</span>
      </a>

      <a
        href="#"
        class="text-gray-900 hover:text-gray-900 hover:bg-gray-50 group rounded-md px-3 py-2 flex items-center text-sm font-medium"
      >
        <Heroicons.sparkles
          outline
          class="text-gray-400 group-hover:text-gray-500 flex-shrink-0 -ml-1 mr-3 h-6 w-6"
        />
        <span class="truncate">Insights</span>
      </a>

      <.link
        navigate={~p"/nodes"}
        class={"#{if (@active_tab == :nodes || @active_tab == :node_overview ),
                do: "bg-gray-50 text-indigo-700 hover:text-indigo-700 hover:bg-white group rounded-md px-3 py-2 flex items-center text-sm font-medium", else: "text-gray-900 hover:text-gray-900 hover:bg-gray-50 group rounded-md px-3 py-2 flex items-center text-sm font-medium"}"}
        title="SentryPeer Nodes"
      >
        <svg
          class={"#{if (@active_tab == :nodes || @active_tab == :node_overview ),
                do: "text-indigo-500 group-hover:text-indigo-500 flex-shrink-0 -ml-1 mr-3 h-6 w-6", else: "text-gray-400 group-hover:text-gray-500 flex-shrink-0 -ml-1 mr-3 h-6 w-6"}"}
          xmlns="http://www.w3.org/2000/svg"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M21 7.5l-9-5.25L3 7.5m18 0l-9 5.25m9-5.25v9l-9 5.25M3 7.5l9 5.25M3 7.5v9l9 5.25m0-9v9"
          />
        </svg>
        <span class="truncate">Nodes</span>
      </.link>

      <a
        href="#"
        class="text-gray-900 hover:text-gray-900 hover:bg-gray-50 group rounded-md px-3 py-2 flex items-center text-sm font-medium"
      >
        <svg
          class="text-gray-400 group-hover:text-gray-500 flex-shrink-0 -ml-1 mr-3 h-6 w-6"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M2.25 8.25h19.5M2.25 9h19.5m-16.5 5.25h6m-6 2.25h3m-3.75 3h15a2.25 2.25 0 002.25-2.25V6.75A2.25 2.25 0 0019.5 4.5h-15a2.25 2.25 0 00-2.25 2.25v10.5A2.25 2.25 0 004.5 19.5z"
          />
        </svg>
        <span class="truncate">Plan &#38; Billing</span>
      </a>

      <a
        href="#"
        class="text-gray-900 hover:text-gray-900 hover:bg-gray-50 group rounded-md px-3 py-2 flex items-center text-sm font-medium"
      >
        <svg
          class="text-gray-400 group-hover:text-gray-500 flex-shrink-0 -ml-1 mr-3 h-6 w-6"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M18 18.72a9.094 9.094 0 003.741-.479 3 3 0 00-4.682-2.72m.94 3.198l.001.031c0 .225-.012.447-.037.666A11.944 11.944 0 0112 21c-2.17 0-4.207-.576-5.963-1.584A6.062 6.062 0 016 18.719m12 0a5.971 5.971 0 00-.941-3.197m0 0A5.995 5.995 0 0012 12.75a5.995 5.995 0 00-5.058 2.772m0 0a3 3 0 00-4.681 2.72 8.986 8.986 0 003.74.477m.94-3.197a5.971 5.971 0 00-.94 3.197M15 6.75a3 3 0 11-6 0 3 3 0 016 0zm6 3a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0zm-13.5 0a2.25 2.25 0 11-4.5 0 2.25 2.25 0 014.5 0z"
          />
        </svg>
        <span class="truncate">Team</span>
      </a>

      <a
        href="#"
        class="text-gray-900 hover:text-gray-900 hover:bg-gray-50 group rounded-md px-3 py-2 flex items-center text-sm font-medium"
      >
        <svg
          class="text-gray-400 group-hover:text-gray-500 flex-shrink-0 -ml-1 mr-3 h-6 w-6"
          fill="none"
          viewBox="0 0 24 24"
          stroke-width="1.5"
          stroke="currentColor"
          aria-hidden="true"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M13.5 16.875h3.375m0 0h3.375m-3.375 0V13.5m0 3.375v3.375M6 10.5h2.25a2.25 2.25 0 002.25-2.25V6a2.25 2.25 0 00-2.25-2.25H6A2.25 2.25 0 003.75 6v2.25A2.25 2.25 0 006 10.5zm0 9.75h2.25A2.25 2.25 0 0010.5 18v-2.25a2.25 2.25 0 00-2.25-2.25H6a2.25 2.25 0 00-2.25 2.25V18A2.25 2.25 0 006 20.25zm9.75-9.75H18a2.25 2.25 0 002.25-2.25V6A2.25 2.25 0 0018 3.75h-2.25A2.25 2.25 0 0013.5 6v2.25a2.25 2.25 0 002.25 2.25z"
          />
        </svg>
        <span class="truncate">Integrations</span>
      </a>

      <a
        href="https://status.sentrypeer.com/"
        target="_blank"
        title="Visit the SentryPeer Status Page"
        class="text-gray-900 hover:text-gray-900 hover:bg-gray-50 group rounded-md px-3 py-2 flex items-center text-sm font-medium"
      >
        <Heroicons.megaphone class="text-gray-400 group-hover:text-gray-500 flex-shrink-0 -ml-1 mr-3 h-6 w-6" />
        <span class="truncate">Status</span>
        <Heroicons.arrow_top_right_on_square class="ml-2 h-4 w-4 text-gray-400 group-hover:text-gray-500" />
      </a>
    </nav>
    """
  end

  def nav_top_menu(assigns) do
    ~H"""
    <!-- Top Navbar -->
    <nav class="flex-shrink-0 bg-gradient-to-r from-brand to-indigo-600">
      <div class="mx-auto max-w-7xl px-2 sm:px-4 lg:px-8">
        <div class="relative flex h-16 items-center justify-between">
          <!-- Logo section -->
          <div class="flex items-center px-2 lg:px-0 xl:w-64">
            <div class="flex-shrink-0">
              <svg viewBox="0 0 40.302814 53.481709" class="h-12" aria-hidden="true">
                <g id="layer1" transform="translate(-53.112717,-43.907589)">
                  <g
                    id="g12"
                    transform="matrix(0.35277777,0,0,-0.35277777,73.26413,43.907589)"
                    style="fill:#ffffff;fill-opacity:1"
                  >
                    <path
                      d="M 0,0 H -17.647 L 0,-70.805 Z"
                      style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
                      id="path14"
                    />
                  </g>
                  <g
                    id="g16"
                    transform="matrix(0.35277777,0,0,-0.35277777,65.564008,47.738649)"
                    style="fill:#ffffff;fill-opacity:1"
                  >
                    <path
                      d="m 0,0 21.827,-79.059 v -40.398 l -11.946,53.864 -26.6,33.448 v -39.963 l 26.472,-21.285 3.25,-47.349 -48.298,38.661 v 86.009 z"
                      style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
                      id="path18"
                    />
                  </g>
                  <g
                    id="g20"
                    transform="matrix(0.35277777,0,0,-0.35277777,73.26413,43.907589)"
                    style="fill:#ffffff;fill-opacity:1"
                  >
                    <path
                      d="M 0,0 H 17.647 L 0,-70.805 Z"
                      style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
                      id="path22"
                    />
                  </g>
                  <g
                    id="g24"
                    transform="matrix(0.35277777,0,0,-0.35277777,80.96424,47.738649)"
                    style="fill:#ffffff;fill-opacity:1"
                  >
                    <path
                      d="m 0,0 -21.827,-79.059 v -40.398 l 11.946,53.864 26.6,33.448 v -39.963 l -26.472,-21.285 -3.25,-47.349 48.298,38.661 v 86.009 z"
                      style="fill:#ffffff;fill-opacity:1;fill-rule:nonzero;stroke:none"
                      id="path26"
                    />
                  </g>
                </g>
              </svg>
            </div>
          </div>
          <!-- Search section -->
          <div class="flex flex-1 justify-center lg:justify-end">
            <div class="w-full px-2 lg:px-6">
              <label for="search" class="sr-only">Search nodes</label>
              <div class="relative text-indigo-200 focus-within:text-gray-400">
                <div class="pointer-events-none absolute inset-y-0 left-0 flex items-center pl-3">
                  <!-- Heroicon name: mini/magnifying-glass -->
                  <svg
                    class="h-5 w-5"
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 20 20"
                    fill="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      fill-rule="evenodd"
                      d="M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z"
                      clip-rule="evenodd"
                    />
                  </svg>
                </div>
                <input
                  id="search"
                  name="search"
                  class="block w-full rounded-md border border-transparent bg-indigo-400 bg-opacity-25 py-2 pl-10 pr-3 leading-5 text-indigo-100 placeholder-indigo-200 focus:bg-white focus:text-gray-900 focus:placeholder-gray-400 focus:outline-none focus:ring-0 sm:text-sm"
                  placeholder="Search nodes"
                  type="search"
                />
              </div>
            </div>
          </div>
          <div class="flex lg:hidden">
            <!-- Mobile menu button -->
            <button
              type="button"
              class="inline-flex items-center justify-center rounded-md bg-indigo-600 p-2 text-indigo-400 hover:bg-indigo-600 hover:text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-indigo-600"
              aria-controls="mobile-menu"
              aria-expanded="false"
              phx-click={
                toggle_dropdown_menu("#mobile-menu")
                |> JS.toggle(to: "#mobile-menu-open")
                |> JS.toggle(to: "#mobile-menu-close")
              }
              phx-click-away={
                JS.hide(to: "#mobile-menu")
                |> JS.hide(to: "#mobile-menu-close")
                |> JS.show(to: "#mobile-menu-open")
              }
            >
              <span class="sr-only">Open main menu</span>
              <!--
                          Icon when menu is closed.

                          Heroicon name: outline/bars-3-center-left

                          Menu open: "hidden", Menu closed: "block"
                        -->
              <svg
                class="block h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                aria-hidden="true"
                id="mobile-menu-open"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M3.75 6.75h16.5M3.75 12H12m-8.25 5.25h16.5"
                />
              </svg>
              <!--
                          Icon when menu is open.

                          Heroicon name: outline/x-mark

                          Menu open: "block", Menu closed: "hidden"
                        -->
              <svg
                class="hidden h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                aria-hidden="true"
                id="mobile-menu-close"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <!-- Links section -->
          <div class="hidden lg:block lg:w-80">
            <div class="flex items-center justify-end">
              <div class="flex">
                <a
                  href="#"
                  title="SentryPeer Documentation"
                  class="rounded-md px-3 py-2 text-sm font-medium text-indigo-200 hover:text-white"
                >
                  Documentation
                </a>
                <a
                  href="#"
                  title="SentryPeer Support"
                  class="rounded-md px-3 py-2 text-sm font-medium text-indigo-200 hover:text-white"
                >
                  Support
                </a>
              </div>
              <!-- Profile dropdown -->
              <div class="relative ml-4 flex-shrink-0">
                <div>
                  <button
                    type="button"
                    class="flex rounded-full bg-indigo-700 text-sm text-white focus:outline-none focus:ring-2 focus:ring-white focus:ring-offset-2 focus:ring-offset-indigo-700"
                    id="user-menu-button"
                    aria-expanded="false"
                    aria-haspopup="true"
                    phx-click={toggle_dropdown_menu("#user-menu")}
                    phx-click-away={JS.hide(to: "#user-menu")}
                  >
                    <span class="sr-only">Open user menu</span>
                    <img
                      class="h-8 w-8 rounded-full"
                      src={@current_user.avatar}
                      alt={ @current_user.name <> "'s avatar" }
                      title={ @current_user.name <> "'s avatar" }
                    />
                  </button>
                </div>
                <!--
                                  Dropdown menu, show/hide based on menu state.

                                  Entering: "transition ease-out duration-100"
                                    From: "transform opacity-0 scale-95"
                                    To: "transform opacity-100 scale-100"
                                  Leaving: "transition ease-in duration-75"
                                    From: "transform opacity-100 scale-100"
                                    To: "transform opacity-0 scale-95"
                                -->
                <div
                  class="absolute hidden right-0 z-10 mt-2 w-48 origin-top-right rounded-md bg-white py-1 shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
                  role="menu"
                  aria-orientation="vertical"
                  aria-labelledby="user-menu-button"
                  id="user-menu"
                  tabindex="-1"
                >
                  <!-- Active: "bg-gray-100", Not Active: "" -->
                  <a
                    href="#"
                    title="View your profile"
                    class="block px-4 py-2 text-sm text-gray-700"
                    role="menuitem"
                    tabindex="-1"
                    id="user-menu-item-0"
                  >
                    View Profile
                  </a>
                  <a
                    href="#"
                    title="Change your settings"
                    class="block px-4 py-2 text-sm text-gray-700"
                    role="menuitem"
                    tabindex="-1"
                    id="user-menu-item-1"
                  >
                    Settings
                  </a>
                  <a
                    href="#"
                    title="Logout from SentryPeer"
                    class="block px-4 py-2 text-sm text-gray-700"
                    role="menuitem"
                    tabindex="-1"
                    id="user-menu-item-2"
                    phx-click={show_modal("confirm_logout")}
                  >
                    Logout
                  </a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <!-- Logout confirmation modal -->
      <.confirm_modal
        id="confirm_logout"
        on_confirm={JS.navigate(~p"/logout")}
        on_cancel={JS.hide(to: "#confirm_logout")}
      >
        <:title>Logout</:title>
        Are you sure you?
        <:confirm>Logout</:confirm>
        <:cancel>Cancel</:cancel>
      </.confirm_modal>
      <!-- Mobile menu, show/hide based on menu state. -->
      <div class="hidden" id="mobile-menu">
        <div class="space-y-1 px-2 pt-2 pb-3">
          <a
            href="#"
            class="text-white bg-indigo-800 block px-3 py-2 rounded-md text-base font-medium"
            aria-current="page"
          >
            Documentation
          </a>
          <a
            href="#"
            class="text-indigo-200 hover:text-indigo-100 hover:bg-indigo-600 block px-3 py-2 rounded-md text-base font-medium"
          >
            Support
          </a>
        </div>
        <div class="border-t border-indigo-800 pt-4 pb-3">
          <div class="space-y-1 px-2">
            <a
              href="#"
              class="block rounded-md px-3 py-2 text-base font-medium text-indigo-200 hover:bg-indigo-600 hover:text-indigo-100"
            >
              Your Profile
            </a>
            <a
              href="#"
              class="mt-1 block rounded-md px-3 py-2 text-base font-medium text-indigo-200 hover:bg-indigo-600 hover:text-indigo-100"
            >
              Settings
            </a>
            <.link
              href="#"
              phx-click={show_modal("confirm_logout")}
              class="mt-1 block rounded-md px-3 py-2 text-base font-medium text-indigo-200 hover:bg-indigo-600
                    hover:text-indigo-100"
            >
              Logout
            </.link>
          </div>
        </div>
      </div>
    </nav>
    """
  end
end
