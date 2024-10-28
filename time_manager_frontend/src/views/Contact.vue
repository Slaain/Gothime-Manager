<template>
  <div class="flex flex-col items-center background">
    <Header />
    <Notification ref="notification" />
    <div class="w-full max-w-lg p-8 mt-24 space-y-6 glassmorphism">
      <h2 class="text-3xl font-bold text-center">Contact Us</h2>
      <form @submit.prevent="submitForm" class="space-y-4">
        <div>
          <label for="name" class="block font-semibold">Name</label>
          <input
            type="text"
            id="name"
            v-model="form.name"
            placeholder="Your Name"
            class="w-full px-4 py-2 mt-1 text-black border border-black rounded-md input-field focus:outline-none focus:ring-2 focus:ring-black"
            required
          />
        </div>

        <div>
          <label for="email" class="block font-semibold">Email</label>
          <input
            type="email"
            id="email"
            v-model="form.email"
            placeholder="Your Email"
            class="w-full px-4 py-2 mt-1 text-black border border-black rounded-md input-field focus:outline-none focus:ring-2 focus:ring-black"
            required
          />
        </div>

        <div>
          <label for="message" class="block font-semibold">Message</label>
          <textarea
            id="message"
            v-model="form.message"
            placeholder="Your Message"
            rows="4"
            class="w-full px-4 py-2 mt-1 text-black border border-black rounded-md input-field focus:outline-none focus:ring-2 focus:ring-black"
            required
          ></textarea>
        </div>

        <div class="flex justify-center">
          <button
            type="submit"
            class="px-6 py-3 font-semibold text-black bg-yellow-400 rounded-md hover:bg-yellow-300"
          >
            Send Message
          </button>
        </div>
      </form>
    </div>
  </div>
</template>
  
  <script>
import Notification from "./Notification.vue";
import Header from "../components/LandingPage/Header.vue";
import HeroBanner from "../components/LandingPage/HeroBanner.vue";

export default {
  components: {
    Notification,
    Header,
    HeroBanner,
  },
  data() {
    return {
      form: {
        name: "",
        email: "",
        message: "",
      },
    };
  },
  methods: {
    submitForm() {
      console.log("Formulaire soumis:", this.form);
      this.$refs.notification.show("Message sent !"); // Affiche la notification
      this.form = { name: "", email: "", message: "" }; // Réinitialiser le formulaire
    },
  },
};
</script>
  
  
  <style scoped>
.background {
  background-image: url("./../assets/images/digital-art-with-city-landscape-architecture.png");
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  height: 100vh;
}

.glassmorphism {
  position: relative;
  background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px; /* Arrondi des angles */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
  color: white;
  overflow: hidden; /* Pour assurer que le pseudo-élément reste dans les limites du conteneur */
}

.glassmorphism h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85); /* Couleur blanche avec transparence */
}
</style>
  