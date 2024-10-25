/** @type {import('tailwindcss').Config} */
const tailwindConfig = {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  darkMode: false, // ou 'media' ou 'class'
  theme: {
    extend: {
      colors: {
        primaryYellow200: "#edb205",
        primaryYellow: '#fdcb12', // Remplacez par votre couleur principale souhaitée
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
};

export default tailwindConfig;
