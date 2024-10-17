<template>
  <div class="max-w-md mx-auto mt-10 p-6 glassmorphism-bg-white rounded shadow-lg">
    <h2 class="text-2xl font-semibold text-white text-center mb-6">Log In</h2>
    <form @submit.prevent="handleLogin">
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

      <div class="mb-6">
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

      <button
          type="submit"
          class="w-full bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600 transition"
      >
        Log In
      </button>
    </form>

    <p v-if="error" class="mt-4 text-red-500 text-center">{{ error }}</p>
    <p v-if="success" class="mt-4 text-green-500 text-center">{{ success }}</p>

    <!-- Lien vers la page d'inscription -->
    <p class="mt-4 text-white text-center">
      Don't have an account?
      <a href="/signup" class="text-yellow-500 hover:text-yellow-600">Sign up</a>
    </p>
  </div>
</template>

<script>
import { ref } from 'vue';

export default {
  setup() {
    const form = ref({
      email: '',
      password: '',
    });

    const error = ref('');
    const success = ref('');

    const handleLogin = () => {
      if (!form.value.email || !form.value.password) {
        error.value = 'Please fill in all fields';
        return;
      }

      // Simulation d'une API call pour la connexion
      console.log('Login submitted:', form.value);

      // Réinitialisation du formulaire et message de succès
      error.value = '';
      success.value = 'Login successful!';
      form.value.email = '';
      form.value.password = '';
    };

    return {
      form,
      error,
      success,
      handleLogin,
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
