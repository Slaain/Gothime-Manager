// tailwind.config.js
module.exports = {
  purge: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        primaryYellow200 : "#edb205",
        primaryYellow: '#fdcb12', // Replace with your desired primary color
        primaryYellow400: '#edb205',
      },
      backgroundImage: {
        'gotham-wallpaper': "url('./assets/wallpaperGotham.png')",
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
}