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

defmodule SentrypeerWeb.HomePageComponents do
  use SentrypeerWeb, :html

  # Need to turn these into proper components like in the below module
  import SentrypeerWeb.CoreComponents

  def home_page_header(assigns) do
    ~H"""
    <header>
      <div class="relative bg-white dark:bg-slate-800">
        <div class="mx-auto flex max-w-7xl items-center justify-between p-6 md:justify-start md:space-x-10 lg:px-8">
          <div class="flex justify-start lg:w-0 lg:flex-1">
            <.link href={~p"/"} title="SentryPeer Home">
              <span class="sr-only">SentryPeer</span>
              <svg viewBox="0 0 40.302814 53.481709" class="h-12" aria-hidden="true">
                <g id="layer1" transform="translate(-53.112717,-43.907589)">
                  <g
                    id="g12"
                    transform="matrix(0.35277777,0,0,-0.35277777,73.26413,43.907589)"
                    style="fill:#ffffff;fill-opacity:1"
                  >
                    <path
                      d="M 0,0 H -17.647 L 0,-70.805 Z"
                      style="fill:#6d50a0;fill-opacity:1;fill-rule:nonzero;stroke:none"
                      id="path14"
                    />
                  </g>
                  <g
                    id="g16"
                    transform="matrix(0.35277777,0,0,-0.35277777,65.564008,47.738649)"
                    style="fill:#6d50a0;fill-opacity:1"
                  >
                    <path
                      d="m 0,0 21.827,-79.059 v -40.398 l -11.946,53.864 -26.6,33.448 v -39.963 l 26.472,-21.285 3.25,-47.349 -48.298,38.661 v 86.009 z"
                      style="fill:#6d50a0;fill-opacity:1;fill-rule:nonzero;stroke:none"
                      id="path18"
                    />
                  </g>
                  <g
                    id="g20"
                    transform="matrix(0.35277777,0,0,-0.35277777,73.26413,43.907589)"
                    style="fill:#6d50a0;fill-opacity:1"
                  >
                    <path
                      d="M 0,0 H 17.647 L 0,-70.805 Z"
                      style="fill:#6d50a0;fill-opacity:1;fill-rule:nonzero;stroke:none"
                      id="path22"
                    />
                  </g>
                  <g
                    id="g24"
                    transform="matrix(0.35277777,0,0,-0.35277777,80.96424,47.738649)"
                    style="fill:#6d50a0;fill-opacity:1"
                  >
                    <path
                      d="m 0,0 -21.827,-79.059 v -40.398 l 11.946,53.864 26.6,33.448 v -39.963 l -26.472,-21.285 -3.25,-47.349 48.298,38.661 v 86.009 z"
                      style="fill:#6d50a0;fill-opacity:1;fill-rule:nonzero;stroke:none"
                      id="path26"
                    />
                  </g>
                </g>
              </svg>
            </.link>
          </div>
          <div class="-my-2 -mr-2 md:hidden">
            <button
              type="button"
              class="inline-flex items-center justify-center rounded-md bg-white p-2 text-gray-400 hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset focus:ring-indigo-500"
              phx-click={toggle_dropdown_menu("#mobile-menu")}
              phx-click-away={JS.hide(to: "#mobile-menu")}
              aria-expanded="false"
            >
              <span class="sr-only">Open menu</span>
              <!-- Heroicon name: outline/bars-3 -->
              <svg
                class="h-6 w-6"
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 24 24"
                stroke-width="1.5"
                stroke="currentColor"
                aria-hidden="true"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
                />
              </svg>
            </button>
          </div>
          <nav class="hidden space-x-10 md:flex">
            <.link
              navigate={~p"/pricing"}
              class="text-base font-medium dark:text-slate-400 dark:hover:text-slate-200 text-gray-500 hover:text-gray-900"
              title="SentryPeer Pricing Plans for users and companies of all sizes"
            >
              Pricing
            </.link>
            <.link
              navigate={~p"/partners"}
              class="text-base font-medium dark:text-slate-400 dark:hover:text-slate-200 text-gray-500 hover:text-gray-900"
              title="Become a SentryPeer Partner"
            >
              Partners
            </.link>
            <.link
              navigate={~p"/about"}
              class="text-base font-medium dark:text-slate-400 dark:hover:text-slate-200 text-gray-500 hover:text-gray-900"
              title="Learn about the company behind SentryPeer"
            >
              Company
            </.link>
          </nav>
          <div class="hidden items-center justify-end md:flex md:flex-1 lg:w-0">
            <%= if @current_user do %>
              <.link
                navigate={~p"/dashboard"}
                title="Go to the SentryPeer Dashboard"
                class="ml-8 inline-flex items-center justify-center whitespace-nowrap rounded-md border border-transparent bg-gradient-to-r from-brand to-indigo-600 bg-origin-border px-4 py-2 text-base font-medium text-white shadow-sm hover:from-brand hover:to-indigo-700"
              >
                Dashboard
              </.link>
            <% else %>
              <.link
                navigate={~p"/login"}
                title="Login to SentryPeer"
                class="whitespace-nowrap text-base font-medium dark:text-slate-400 dark:hover:text-slate-200 text-gray-500 hover:text-gray-900 mr-4"
              >
                Sign in
              </.link>
              <.link
                navigate={~p"/signup"}
                title="Sign up for SentryPeer"
                class="ml-8 inline-flex items-center justify-center whitespace-nowrap rounded-md border border-transparent bg-gradient-to-r from-brand to-indigo-600 bg-origin-border px-4 py-2 text-base font-medium text-white shadow-sm hover:from-brand hover:to-indigo-700"
              >
                Sign up
              </.link>
            <% end %>
          </div>
        </div>
        <!--
                Mobile menu, show/hide based on mobile menu state.

                Entering: "duration-200 ease-out"
                  From: "opacity-0 scale-95"
                  To: "opacity-100 scale-100"
                Leaving: "duration-100 ease-in"
                  From: "opacity-100 scale-100"
                  To: "opacity-0 scale-95"
              -->
        <div
          id="mobile-menu"
          class="absolute hidden inset-x-0 top-0 z-30 origin-top-right transform p-2 transition md:hidden"
        >
          <div class="divide-y-2 divide-gray-50 dark:divide-slate-800 rounded-lg bg-white dark:bg-slate-400 shadow-lg ring-1 ring-black ring-opacity-5">
            <div class="px-5 pt-5 pb-6">
              <div class="flex items-center justify-between">
                <div>
                  <span class="sr-only">SentryPeer</span>
                  <svg viewBox="0 0 40.302814 53.481709" class="h-12" aria-hidden="true">
                    <g id="layer2" transform="translate(-53.112717,-43.907589)">
                      <g
                        id="g13"
                        transform="matrix(0.35277777,0,0,-0.35277777,73.26413,43.907589)"
                        style="fill:#ffffff;fill-opacity:1"
                      >
                        <path
                          d="M 0,0 H -17.647 L 0,-70.805 Z"
                          style="fill:#6d50a0;fill-opacity:1;fill-rule:nonzero;stroke:none"
                          id="path15"
                        />
                      </g>
                      <g
                        id="g17"
                        transform="matrix(0.35277777,0,0,-0.35277777,65.564008,47.738649)"
                        style="fill:#6d50a0;fill-opacity:1"
                      >
                        <path
                          d="m 0,0 21.827,-79.059 v -40.398 l -11.946,53.864 -26.6,33.448 v -39.963 l 26.472,-21.285 3.25,-47.349 -48.298,38.661 v 86.009 z"
                          style="fill:#6d50a0;fill-opacity:1;fill-rule:nonzero;stroke:none"
                          id="path19"
                        />
                      </g>
                      <g
                        id="g21"
                        transform="matrix(0.35277777,0,0,-0.35277777,73.26413,43.907589)"
                        style="fill:#6d50a0;fill-opacity:1"
                      >
                        <path
                          d="M 0,0 H 17.647 L 0,-70.805 Z"
                          style="fill:#6d50a0;fill-opacity:1;fill-rule:nonzero;stroke:none"
                          id="path23"
                        />
                      </g>
                      <g
                        id="g25"
                        transform="matrix(0.35277777,0,0,-0.35277777,80.96424,47.738649)"
                        style="fill:#6d50a0;fill-opacity:1"
                      >
                        <path
                          d="m 0,0 -21.827,-79.059 v -40.398 l 11.946,53.864 26.6,33.448 v -39.963 l -26.472,-21.285 -3.25,-47.349 48.298,38.661 v 86.009 z"
                          style="fill:#6d50a0;fill-opacity:1;fill-rule:nonzero;stroke:none"
                          id="path27"
                        />
                      </g>
                    </g>
                  </svg>
                </div>
                <div class="-mr-2">
                  <button
                    type="button"
                    phx-click={toggle_dropdown_menu("#mobile-menu")}
                    phx-click-away={JS.hide(to: "#mobile-menu")}
                    class="inline-flex items-center justify-center rounded-md bg-white p-2 text-gray-400
                                    hover:bg-gray-100 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-inset
                                    focus:ring-indigo-500"
                  >
                    <span class="sr-only">Close menu</span>
                    <!-- Heroicon name: outline/x-mark -->
                    <svg
                      class="h-6 w-6"
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke-width="1.5"
                      stroke="currentColor"
                      aria-hidden="true"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>
              </div>
            </div>
            <div class="py-6 px-5">
              <div class="grid grid-cols-1 gap-4">
                <.link
                  navigate={~p"/pricing"}
                  class="text-base font-medium text-gray-900 hover:text-gray-700"
                  title="SentryPeer Pricing Plans for users and companies of all sizes"
                >
                  Pricing
                </.link>
                <.link
                  navigate={~p"/partners"}
                  class="text-base font-medium text-gray-900 hover:text-gray-700"
                  title="Become a SentryPeer Partner"
                >
                  Partners
                </.link>
                <.link
                  navigate={~p"/about"}
                  class="text-base font-medium text-gray-900 hover:text-gray-700"
                  title="Learn about the company behind SentryPeer"
                >
                  Company
                </.link>
              </div>
              <%= if @current_user do %>
                <div class="mt-6">
                  <.link
                    navigate={~p"/dashboard"}
                    title="Go to the SentryPeer Dashboard"
                    class="inline-flex items-center justify-center whitespace-nowrap rounded-md border border-transparent bg-gradient-to-r from-brand to-indigo-600 bg-origin-border px-4 py-2 text-base font-medium text-white shadow-sm hover:from-brand hover:to-indigo-700"
                  >
                    Dashboard
                  </.link>
                </div>
              <% else %>
                <div class="mt-6">
                  <.link
                    navigate={~p"/login"}
                    title="Login to SentryPeer"
                    class="inline-flex items-center justify-center whitespace-nowrap rounded-md border border-transparent bg-gradient-to-r from-brand to-indigo-600 bg-origin-border px-4 py-2 text-base font-medium text-white shadow-sm hover:from-brand hover:to-indigo-700"
                  >
                    Sign in
                  </.link>
                </div>
                <div class="mt-6">
                  <.link
                    navigate={~p"/signup"}
                    title="Sign up for SentryPeer"
                    class="inline-flex items-center justify-center whitespace-nowrap rounded-md border border-transparent bg-gradient-to-r from-brand to-indigo-600 bg-origin-border px-4 py-2 text-base font-medium text-white shadow-sm hover:from-brand hover:to-indigo-700"
                  >
                    Sign up
                  </.link>
                </div>
              <% end %>
            </div>
          </div>
        </div>
      </div>
    </header>
    """
  end

  def footer(assigns) do
    ~H"""
    <!-- Back to top button -->
    <button
      type="button"
      title="Back to top of page"
      class="float-right inline-block p-3 bg-brand text-white font-medium text-xs leading-tight uppercase rounded-full shadow-md hover:bg-indigo-600 hover:shadow-lg focus:bg-indigo-700 focus:shadow-lg focus:outline-none focus:ring-0 active:bg-indigo-800 active:shadow-lg transition duration-150 ease-in-out bottom-5 right-5"
      id="btn-back-to-top"
    >
      <svg
        aria-hidden="true"
        focusable="false"
        class="w-4 h-4"
        role="img"
        xmlns="http://www.w3.org/2000/svg"
        viewBox="0 0 448 512"
      >
        <path
          fill="currentColor"
          d="M34.9 289.5l-22.2-22.2c-9.4-9.4-9.4-24.6 0-33.9L207 39c9.4-9.4 24.6-9.4 33.9 0l194.3 194.3c9.4 9.4 9.4 24.6 0 33.9L413 289.4c-9.5 9.5-25 9.3-34.3-.4L264 168.6V456c0 13.3-10.7 24-24 24h-32c-13.3 0-24-10.7-24-24V168.6L69.2 289.1c-9.3 9.8-24.8 10-34.3.4z"
        >
        </path>
      </svg>
    </button>
    <footer class="bg-gray-50 dark:bg-slate-600" aria-labelledby="footer-heading">
      <h2 id="footer-heading" class="sr-only">Footer</h2>
      <div class="mx-auto max-w-7xl px-6 pt-16 pb-8 lg:px-8 lg:pt-24">
        <div class="xl:grid xl:grid-cols-3 xl:gap-8">
          <div class="grid grid-cols-2 gap-8 xl:col-span-2">
            <div class="md:grid md:grid-cols-2 md:gap-8">
              <div>
                <h3 class="text-base font-medium text-gray-900 dark:text-white">Sectors</h3>
                <ul role="list" class="mt-4 space-y-4">
                  <li>
                    <.link
                      navigate={~p"/internet-telephony-service-provider"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Internet Telephony Service Providers LOVE SentryPeer"
                    >
                      ITSPs
                    </.link>
                  </li>

                  <li>
                    <.link
                      navigate={~p"/cybersecurity"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Work in the Cybersecurity industry? We gather lots of realtime data."
                    >
                      Cybersecurity
                    </.link>
                  </li>
                  <li>
                    <.link
                      navigate={~p"/advanced-users"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Love to watch VoIP things in real time? You'll love SentryPeer."
                    >
                      Advanced Users
                    </.link>
                  </li>
                  <li>
                    <.link
                      navigate={~p"/telecom-resellers"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Want to roll out SentryPeer to your customers?"
                    >
                      Telecom Resellers
                    </.link>
                  </li>
                </ul>
              </div>
              <div class="mt-12 md:mt-0">
                <h3 class="text-base font-medium text-gray-900 dark:text-white">Support</h3>
                <ul role="list" class="mt-4 space-y-4">
                  <li>
                    <.link
                      navigate={~p"/pricing"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="SentryPeer Pricing Plans for users and companies of all sizes"
                    >
                      Pricing
                    </.link>
                  </li>

                  <li>
                    <.link
                      navigate={~p"/documentation"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Read the SentryPeer documentation that covers all aspects of the platform and API"
                    >
                      Documentation
                    </.link>
                  </li>

                  <li>
                    <.link
                      navigate={~p"/guides"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Read the SentryPeer Getting Started Guide and other guides"
                    >
                      Guides
                    </.link>
                  </li>

                  <li>
                    <a
                      href="https://status.sentrypeer.com/"
                      title="SentryPeer Service Status Page"
                      target="_blank"
                      rel="noopener noreferrer"
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                    >
                      Service
                      Status
                    </a>
                  </li>
                </ul>
              </div>
            </div>
            <div class="md:grid md:grid-cols-2 md:gap-8">
              <div>
                <h3 class="text-base font-medium text-gray-900 dark:text-white">Company</h3>
                <ul role="list" class="mt-4 space-y-4">
                  <li>
                    <.link
                      navigate={~p"/about"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Learn about the company behind SentryPeer"
                    >
                      About
                    </.link>
                  </li>

                  <li>
                    <.link
                      navigate={~p"/contact"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="See the various ways to contact SentryPeer"
                    >
                      Contact
                    </.link>
                  </li>

                  <li>
                    <.link
                      navigate={~p"/jobs"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Fancy working at SentryPeer?"
                    >
                      Jobs
                    </.link>
                  </li>

                  <li>
                    <.link
                      navigate={~p"/partners"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Become a SentryPeer Partner"
                    >
                      Partners
                    </.link>
                  </li>
                </ul>
              </div>
              <div class="mt-12 md:mt-0">
                <h3 class="text-base font-medium text-gray-900 dark:text-white">Legal</h3>
                <ul role="list" class="mt-4 space-y-4">
                  <li>
                    <.link
                      navigate={~p"/privacy-policy"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Read the SentryPeer Privacy Policy"
                    >
                      Privacy Policy
                    </.link>
                  </li>

                  <li>
                    <.link
                      navigate={~p"/terms-and-conditions"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Understand the SentryPeer Terms and Conditions"
                    >
                      Terms & Conditions
                    </.link>
                  </li>

                  <li>
                    <.link
                      navigate={~p"/acceptable-use-policy"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Read about what you can and can not use SentryPeer for"
                    >
                      Acceptable Use Policy
                    </.link>
                  </li>
                  <li>
                    <.link
                      navigate={~p"/cookie-policy"}
                      class="text-base text-gray-500 dark:text-black hover:text-gray-900"
                      title="Read about SentryPeer's use of cookies"
                    >
                      Cookie Policy
                    </.link>
                  </li>
                </ul>
              </div>
            </div>
          </div>
          <%= if @show_newsletter_subscription do %>
            <div class="mt-12 xl:mt-0">
              <h3 class="text-base font-medium text-gray-900 dark:text-white">
                Subscribe to our newsletter
              </h3>
              <p class="mt-4 text-base text-gray-500 dark:text-black">
                The latest news, articles, and resources, sent to your inbox weekly.
              </p>
              <form class="mt-4 sm:flex sm:max-w-md" id="contact-form" phx-submit="subscribe">
                <label for="email-address" class="sr-only">Email address</label>
                <input
                  type="email"
                  name="email"
                  id="email-address"
                  autocomplete="email"
                  required
                  class="w-full min-w-0 appearance-none rounded-md border border-gray-300 bg-white py-2 px-4 text-base text-gray-900 placeholder-gray-500 shadow-sm focus:border-indigo-500 focus:placeholder-gray-400 focus:outline-none focus:ring-indigo-500"
                  placeholder="Enter your email"
                />
                <div class="mt-3 rounded-md sm:mt-0 sm:ml-3 sm:flex-shrink-0">
                  <button
                    phx-disable-with="Subscribing..."
                    phx-throttle="2000"
                    type="submit"
                    class="flex w-full items-center justify-center rounded-md border border-transparent bg-gradient-to-r from-brand to-indigo-600 bg-origin-border px-4 py-3 text-base font-medium text-white shadow-sm hover:from-brand hover:to-indigo-700"
                  >
                    Subscribe
                  </button>
                </div>
              </form>
            </div>
          <% end %>
        </div>
        <div class="mt-12 border-t border-gray-200 pt-8 md:flex md:items-center md:justify-between lg:mt-16">
          <div class="flex space-x-6 md:order-2">
            <a
              href="https://twitter.com/SentryPeer"
              title="SentryPeer on Twitter"
              target="_blank"
              rel="noopener noreferrer"
              class="text-gray-400 hover:text-gray-500"
            >
              <span class="sr-only">Twitter</span>
              <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path d="M8.29 20.251c7.547 0 11.675-6.253 11.675-11.675 0-.178 0-.355-.012-.53A8.348 8.348 0 0022 5.92a8.19 8.19 0 01-2.357.646 4.118 4.118 0 001.804-2.27 8.224 8.224 0 01-2.605.996 4.107 4.107 0 00-6.993 3.743 11.65 11.65 0 01-8.457-4.287 4.106 4.106 0 001.27 5.477A4.072 4.072 0 012.8 9.713v.052a4.105 4.105 0 003.292 4.022 4.095 4.095 0 01-1.853.07 4.108 4.108 0 003.834 2.85A8.233 8.233 0 012 18.407a11.616 11.616 0 006.29 1.84" />
              </svg>
            </a>

            <a
              href="https://github.com/SentryPeer"
              title="SentryPeer on GitHub"
              target="_blank"
              rel="noopener noreferrer"
              class="text-gray-400 hover:text-gray-500"
            >
              <span class="sr-only">GitHub</span>
              <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 24 24" aria-hidden="true">
                <path
                  fill-rule="evenodd"
                  d="M12 2C6.477 2 2 6.484 2 12.017c0 4.425 2.865 8.18 6.839 9.504.5.092.682-.217.682-.483 0-.237-.008-.868-.013-1.703-2.782.605-3.369-1.343-3.369-1.343-.454-1.158-1.11-1.466-1.11-1.466-.908-.62.069-.608.069-.608 1.003.07 1.531 1.032 1.531 1.032.892 1.53 2.341 1.088 2.91.832.092-.647.35-1.088.636-1.338-2.22-.253-4.555-1.113-4.555-4.951 0-1.093.39-1.988 1.029-2.688-.103-.253-.446-1.272.098-2.65 0 0 .84-.27 2.75 1.026A9.564 9.564 0 0112 6.844c.85.004 1.705.115 2.504.337 1.909-1.296 2.747-1.027 2.747-1.027.546 1.379.202 2.398.1 2.651.64.7 1.028 1.595 1.028 2.688 0 3.848-2.339 4.695-4.566 4.943.359.309.678.92.678 1.855 0 1.338-.012 2.419-.012 2.747 0 .268.18.58.688.482A10.019 10.019 0 0022 12.017C22 6.484 17.522 2 12 2z"
                  clip-rule="evenodd"
                />
              </svg>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-6 w-6"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  d="M27.255 80.719c0 7.33-5.978 13.317-13.309 13.317C6.616 94.036.63 88.049.63 80.719s5.987-13.317 13.317-13.317h13.309zm6.709 0c0-7.33 5.987-13.317 13.317-13.317s13.317 5.986 13.317 13.317v33.335c0 7.33-5.986 13.317-13.317 13.317-7.33 0-13.317-5.987-13.317-13.317zm0 0"
                  fill="#de1c59"
                /><path
                  d="M47.281 27.255c-7.33 0-13.317-5.978-13.317-13.309C33.964 6.616 39.951.63 47.281.63s13.317 5.987 13.317 13.317v13.309zm0 6.709c7.33 0 13.317 5.987 13.317 13.317s-5.986 13.317-13.317 13.317H13.946C6.616 60.598.63 54.612.63 47.281c0-7.33 5.987-13.317 13.317-13.317zm0 0"
                  fill="#35c5f0"
                /><path
                  d="M100.745 47.281c0-7.33 5.978-13.317 13.309-13.317 7.33 0 13.317 5.987 13.317 13.317s-5.987 13.317-13.317 13.317h-13.309zm-6.709 0c0 7.33-5.987 13.317-13.317 13.317s-13.317-5.986-13.317-13.317V13.946C67.402 6.616 73.388.63 80.719.63c7.33 0 13.317 5.987 13.317 13.317zm0 0"
                  fill="#2eb57d"
                /><path
                  d="M80.719 100.745c7.33 0 13.317 5.978 13.317 13.309 0 7.33-5.987 13.317-13.317 13.317s-13.317-5.987-13.317-13.317v-13.309zm0-6.709c-7.33 0-13.317-5.987-13.317-13.317s5.986-13.317 13.317-13.317h33.335c7.33 0 13.317 5.986 13.317 13.317 0 7.33-5.987 13.317-13.317 13.317zm0 0"
                  fill="#ebb02e"
                />
              </svg>
            </a>

            <a
              href="https://join.slack.com/t/sentrypeer/shared_invite/zt-zxsmfdo7-iE0odNT2XyKLP9pt0lgbcw"
              title="SentryPeer Slack Community"
              target="_blank"
              rel="noopener noreferrer"
              class="text-gray-400 hover:text-gray-500"
            >
              <span class="sr-only">Slack</span>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                class="h-6 w-6 mt-0.5"
                fill="currentColor"
                viewBox="0 0 156 156"
                aria-hidden="true"
              >
                <path
                  fill-rule="evenodd"
                  d="M27.255 80.719c0 7.33-5.978 13.317-13.309 13.317C6.616 94.036.63 88.049.63 80.719s5.987-13.317 13.317-13.317h13.309zm6.709 0c0-7.33 5.987-13.317 13.317-13.317s13.317 5.986 13.317 13.317v33.335c0 7.33-5.986 13.317-13.317 13.317-7.33 0-13.317-5.987-13.317-13.317zm0 0"
                /><path d="M47.281 27.255c-7.33 0-13.317-5.978-13.317-13.309C33.964 6.616 39.951.63 47.281.63s13.317 5.987 13.317 13.317v13.309zm0 6.709c7.33 0 13.317 5.987 13.317 13.317s-5.986 13.317-13.317 13.317H13.946C6.616 60.598.63 54.612.63 47.281c0-7.33 5.987-13.317 13.317-13.317zm0 0" /><path d="M100.745 47.281c0-7.33 5.978-13.317 13.309-13.317 7.33 0 13.317 5.987 13.317 13.317s-5.987 13.317-13.317 13.317h-13.309zm-6.709 0c0 7.33-5.987 13.317-13.317 13.317s-13.317-5.986-13.317-13.317V13.946C67.402 6.616 73.388.63 80.719.63c7.33 0 13.317 5.987 13.317 13.317zm0 0" /><path
                  d="M80.719 100.745c7.33 0 13.317 5.978 13.317 13.309 0 7.33-5.987 13.317-13.317 13.317s-13.317-5.987-13.317-13.317v-13.309zm0-6.709c-7.33 0-13.317-5.987-13.317-13.317s5.986-13.317 13.317-13.317h33.335c7.33 0 13.317 5.986 13.317 13.317 0 7.33-5.987 13.317-13.317 13.317zm0 0"
                  clip-rule="evenodd"
                />
              </svg>
            </a>
          </div>
          <p class="mt-8 text-sm text-gray-400 dark:text-black md:order-1 md:mt-0">
            ©
            <a
              href="https://antnetworks.com/"
              class="hover:text-brand"
              title="Ant Networks Limited"
              target="_blank"
              rel="noopener noreferrer"
            >
              Ant Networks Ltd.
            </a>
            <%= DateTime.utc_now().year %>. SentryPeer is a trading name of
            <a
              href="https://antnetworks.com/"
              class="hover:text-brand"
              title="Ant Networks Limited"
              target="_blank"
              rel="noopener noreferrer"
            >
              Ant Networks Ltd.
            </a>
            The
            <a
              href="https://trademarks.ipo.gov.uk/ipo-tmcase/page/Results/1/UK00003847726"
              class="hover:text-brand"
              title="The SentryPeer icon is a registered trademark"
              target="_blank"
              rel="noopener noreferrer"
            >
              SentryPeer Icon
            </a>
            and the
            <a
              href="https://trademarks.ipo.gov.uk/ipo-tmcase/page/Results/1/UK00003700947"
              class="hover:text-brand"
              title="SentryPeer is a registered trademark"
              target="_blank"
              rel="noopener noreferrer"
            >
              SentryPeer name
            </a>
            are registered trademarks of
            <a
              href="https://ghenry.co.uk/about/"
              class="hover:text-brand"
              title="About Gavin Henry"
              target="_blank"
              rel="noopener noreferrer"
            >
              Gavin Henry.
            </a>
            All rights reserved.
          </p>
        </div>
      </div>
    </footer>
    """
  end
end
