/** @type {import('tailwindcss').Config} */

module.exports = {
  darkMode: "class",
  content: [
    "./public/*.html",
    "./app/helpers/**/*.rb",
    "./app/frontend/**/*",
    "./app/views/**/*",
  ],
  corePlugins: {
    aspectRatio: false,
  },
  plugins: [require("daisyui")],
  theme: {
    screens: {
      xxs: "320px",
      xs: "425px",
      sm: "640px",
      md: "768px",
      lg: "1024px",
      xl: "1280px",
      xxl: "1536px",
    },
  },
  daisyui: {
    themes: ["light", "dark"],
  },
};
