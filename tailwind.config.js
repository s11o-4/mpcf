/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{vue,js,js,ts}"],
  theme: {
    extend: {
      colors: {
        primary: '#6096BA',
        primary_white: "#E7ECEF",
        primary_black: "#020420",
        secondary: {
          100: '#E2E2D5',
          200: '#888883',
        },
      }
    },
  },
  plugins: [],
}
