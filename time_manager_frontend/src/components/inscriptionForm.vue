<template>
  <div
    class="max-w-md p-6 mx-auto mt-10 rounded shadow-lg glassmorphism-bg-white"
  >
    <h2 class="mb-6 text-2xl font-semibold text-center text-white">Sign Up</h2>
    <form @submit.prevent="handleSubmit">
      <div class="mb-4">
        <label for="username" class="block mb-1 text-sm font-medium text-white"
          >Username</label
        >
        <input
          v-model="form.username"
          type="text"
          id="username"
          class="w-full px-3 py-2 text-white bg-gray-800 border border-gray-300 rounded focus:outline-none focus:border-primaryYellow"
          required
          placeholder="Username"
        />
      </div>

      <div class="mb-4">
        <label for="email" class="block mb-1 text-sm font-medium text-white"
          >Email</label
        >
        <input
          v-model="form.email"
          type="email"
          id="email"
          class="w-full px-3 py-2 text-white bg-gray-800 border border-gray-300 rounded focus:outline-none focus:border-primaryYellow"
          required
          placeholder="Email"
        />
      </div>

      <div class="mb-4">
        <label for="password" class="block mb-1 text-sm font-medium text-white"
          >Password</label
        >
        <input
          v-model="form.password"
          type="password"
          id="password"
          class="w-full px-3 py-2 text-white bg-gray-800 border border-gray-300 rounded focus:outline-none focus:border-primaryYellow"
          required
          placeholder="Password"
        />
      </div>

      <div class="mb-6">
        <label
          for="confirmPassword"
          class="block mb-1 text-sm font-medium text-white"
          >Confirm Password</label
        >
        <input
          v-model="form.confirmPassword"
          type="password"
          id="confirmPassword"
          class="w-full px-3 py-2 text-white bg-gray-800 border border-gray-300 rounded focus:outline-none focus:border-primaryYellow"
          required
          placeholder="Confirm your password"
        />
      </div>

      <p class="h-8 mt-4 text-center text-red-500">{{ error }}</p>
      <button
        type="submit"
        class="w-full px-4 py-2 text-white transition rounded bg-primaryYellow hover:bg-primaryYellow400"
      >
        Sign Up
      </button>
    </form>

    <!-- <p v-if="success" class="mt-4 text-center text-green-500">{{ success }}</p> -->

    <!-- Lien vers la page de connexion -->
    <p class="mt-4 text-center text-white">
      Already have an account?
      <a href="/login" class="text-primaryYellow hover:text-primaryYellow400"
        >Log in</a
      >
    </p>
  </div>
</template>

<script>
import { ref } from "vue";

export default {
  setup() {
    const form = ref({
      username: "",
      email: "",
      password: "",
      confirmPassword: "",
    });

    const error = ref("");
    const success = ref("");

    const handleSubmit = () => {
      if (form.value.password !== form.value.confirmPassword) {
        error.value = "Passwords do not match";
        success.value = "";
        return;
      }

      // Simulation d'une API call pour enregistrer l'utilisateur
      console.log("Form submitted:", form.value);

      // Réinitialisation du formulaire et message de succès
      error.value = "";
      success.value = "Registration successful!";
      form.value.username = "";
      form.value.email = "";
      form.value.password = "";
      form.value.confirmPassword = "";
    };

    return {
      form,
      error,
      success,
      handleSubmit,
    };
  },
};
</script>

<style scoped>
.glassmorphism-bg-white {
  position: relative;
  background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px; /* Arrondi des angles */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
  overflow: hidden; /* Pour s'assurer que le pseudo-élément reste dans les limites du conteneur */
}

input:focus {
  outline: none;
  border-color: #fdcb12; /* Couleur jaune sur le focus */
  box-shadow: 0 0 5px rgba(253, 203, 18, 0.5); /* Ombre douce sur le focus */
}

a {
  transition: color 0.3s ease;
}
</style>
