<template>
  <div class="max-w-md mx-auto mt-10 p-6 glassmorphism-bg-white rounded shadow-lg">
    <h2 class="text-2xl font-semibold text-white text-center mb-6">Sign Up</h2>
    <form @submit.prevent="handleSubmit">
      <div class="mb-4">
        <label for="username" class="block text-sm font-medium text-white mb-1">Username</label>
        <input
            v-model="form.username"
            type="text"
            id="username"
            class="w-full px-3 py-2 border border-gray-300 rounded bg-gray-800 text-white focus:outline-none focus:border-yellow-500"
            required
            placeholder="Username"
        />
      </div>

      <div class="mb-4">
        <label for="email" class="block text-sm font-medium text-white mb-1">Email</label>
        <input
            v-model="form.email"
            type="email"
            id="email"
            class="w-full px-3 py-2 border border-gray-300 rounded bg-gray-800 text-white focus:outline-none focus:border-yellow-500"
            required
            placeholder="Email"
        />
      </div>

      <div class="mb-4">
        <label for="password" class="block text-sm font-medium text-white mb-1">Password</label>
        <input
            v-model="form.password"
            type="password"
            id="password"
            class="w-full px-3 py-2 border border-gray-300 rounded bg-gray-800 text-white focus:outline-none focus:border-yellow-500"
            required
            placeholder="Password"
        />
      </div>

      <div class="mb-6">
        <label for="confirmPassword" class="block text-sm font-medium text-white mb-1">Confirm Password</label>
        <input
            v-model="form.confirmPassword"
            type="password"
            id="confirmPassword"
            class="w-full px-3 py-2 border border-gray-300 rounded bg-gray-800 text-white focus:outline-none focus:border-yellow-500"
            required
            placeholder="Confirm your password"
        />
      </div>

      <button
          type="submit"
          class="w-full bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600 transition"
      >
        Sign Up
      </button>
    </form>

    <p v-if="error" class="mt-4 text-red-500 text-center">{{ error }}</p>
    <p v-if="success" class="mt-4 text-green-500 text-center">{{ success }}</p>

    <!-- Lien vers la page de connexion -->
    <p class="mt-4 text-white text-center">
      Already have an account?
      <a href="/login" class="text-yellow-500 hover:text-yellow-600">Log in</a>
    </p>
  </div>
</template>

<script>
import { ref } from 'vue';

export default {
  setup() {
    const form = ref({
      username: '',
      email: '',
      password: '',
      confirmPassword: '',
    });

    const error = ref('');
    const success = ref('');

    const handleSubmit = () => {
      if (form.value.password !== form.value.confirmPassword) {
        error.value = 'Passwords do not match';
        success.value = '';
        return;
      }

      // Simulation d'une API call pour enregistrer l'utilisateur
      console.log('Form submitted:', form.value);

      // Réinitialisation du formulaire et message de succès
      error.value = '';
      success.value = 'Registration successful!';
      form.value.username = '';
      form.value.email = '';
      form.value.password = '';
      form.value.confirmPassword = '';
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
