module.exports = {
  content: [
    './src/**/*.{html,js,ts,jsx,tsx}',
  ],
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
  darkMode: 'media',
  plugins: [],
}
