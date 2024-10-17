import './index.css'
import { createApp } from 'vue';
import App from './App.vue';
import router from './router'; // Assurez-vous que ce chemin est correct
import Toast from "vue-toastification";
import "vue-toastification/dist/index.css";


createApp(App)
  .use(router) // Utilisation du routeur dans l'application Vue
  .use(Toast)
  .mount('#app');


