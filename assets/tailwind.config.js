// SPDX-License-Identifier: AGPL-3.0
// Copyright (c) 2023 Gavin Henry <ghenry@sentrypeer.org>
//
//   _____            _              _____
//  / ____|          | |            |  __ \
// | (___   ___ _ __ | |_ _ __ _   _| |__) |__  ___ _ __
//  \___ \ / _ \ '_ \| __| '__| | | |  ___/ _ \/ _ \ '__|
//  ____) |  __/ | | | |_| |  | |_| | |  |  __/  __/ |
// |_____/ \___|_| |_|\__|_|   \__, |_|   \___|\___|_|
//                              __/ |
//                             |___/
//
// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        brand: "#6d50a0",
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    plugin(({addVariant}) => addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])),
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"]))
  ]
}
