const colors = require("tailwindcss/colors"); // <-- ADD THIS LINE
const plugin = require("tailwindcss/plugin");

module.exports = {
  content: [
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex",
    "./js/**/*.js",
    "../../../deps/petal_components/**/*.*ex",
  ],
  darkMode: "class",
  theme: {
    extend: {
      fontFamily: {
        tomaSans: ['TomaSans']
      },
      colors: {
        success: colors.green,
        danger: colors.red,
        warning: colors.yellow,
        info: colors.sky,
        gray: colors.gray,
        background: "#112420",
        primary: {
          "50": "#abd887",
          "100": "#a1ce7d",
          "200": "#97c473",
          "300": "#8dba69",
          "400": "#83b05f",
          "500": "#79a655",
          "600": "#6f9c4b",
          "700": "#659241",
          "800": "#5b8837",
          "900": "#517e2d"
        },
        secondary: {
          "50": "#d4ff76",
          "100": "#caf76c",
          "200": "#c0ed62",
          "300": "#b6e358",
          "400": "#acd94e",
          "500": "#a2cf44",
          "600": "#98c53a",
          "700": "#8ebb30",
          "800": "#84b126",
          "900": "#7aa71c"
        },
        tertiary: {
          '50': '#f9f7f3',
          '100': '#ece8dd',
          '200': '#e0d9c8',
          '300': '#ccbfa5',
          '400': '#b7a280',
          '500': '#a88d67',
          '600': '#9a7b5c',
          '700': '#81644d',
          '800': '#695243',
          '900': '#564538',
          '950': '#2d231d',
        }
      },
    },
  },

  plugins: [
    require("@tailwindcss/forms"),
    plugin(({ addVariant }) =>
      addVariant("phx-no-feedback", [".phx-no-feedback&", ".phx-no-feedback &"])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-click-loading", [
        ".phx-click-loading&",
        ".phx-click-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-submit-loading", [
        ".phx-submit-loading&",
        ".phx-submit-loading &",
      ])
    ),
    plugin(({ addVariant }) =>
      addVariant("phx-change-loading", [
        ".phx-change-loading&",
        ".phx-change-loading &",
      ])
    ),
  ],
};
