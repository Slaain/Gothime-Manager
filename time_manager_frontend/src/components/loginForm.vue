<template>
  <div
    class="max-w-md p-6 mx-auto mt-10 rounded shadow-lg glassmorphism-bg-white"
  >
    <h2 class="mb-6 text-2xl font-semibold text-center text-white">Log In</h2>
    <form @submit.prevent="handleLogin">
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

      <div class="mb-6">
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

      <p class="h-8 mt-4 text-center text-red-500">{{ error }}</p>

      <button
        type="submit"
        class="w-full px-4 py-2 text-white transition rounded bg-primaryYellow hover:bg-primaryYellow400"
      >
        Log In
      </button>
    </form>

    <!-- <p v-if="success" class="mt-4 text-center text-green-500">{{ success }}</p> -->

    <!-- Lien vers la page d'inscription -->
    <p class="mt-4 text-center text-white">
      Don't have an account?
      <a href="/register" class="text-primaryYellow hover:text-primaryYellow400"
        >Sign up</a
      >
    </p>
  </div>
</template>

<script>
import { ref } from "vue";
import axios from "axios";
import { useRouter } from "vue-router"; // Importation du router
import Header from "../components/LandingPage/Header.vue";
import HeroBanner from "../components/LandingPage/HeroBanner.vue";

export default {
  components: {
    Header,
    HeroBanner
  },
  setup() {
    const form = ref({
      email: "",
      password: "",
    });

    const error = ref("");
    const success = ref("");
    const router = useRouter(); // Utiliser le hook pour accéder au routeur

    const handleLogin = async () => {
      try {
        console.log("aled");

        if (!form.value.email || !form.value.password) {
          error.value = "Please fill in all fields";
          return;
        }

        // Simulation d'une API call pour la connexion
        console.log("Login submitted:", {
          email: form.value.email,
          password: form.value.password,
        });

        const response = await axios.post(
          "http://localhost:4000/api/login",
          {
            email: form.value.email,
            password: form.value.password,
          },
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );

        console.log("response : ", response.data.token);

        if (response.status !== 200) {
          error.value = "Invalid credentials";
          return;
        }

        // Réinitialisation du formulaire et message de succès
        error.value = "";
        success.value = "Login successful!";
        form.value.email = "";
        form.value.password = "";
        localStorage.setItem("authToken", response.data.token);
        router.push("/admin");
      } catch (apiError) {
        // error.value = "Invalid credentials";
        console.log("catch : ", apiError.response.data);

        // Assurez-vous que `apiError` est correctement utilisé et non `error`
        if (apiError.response && apiError.response.data.error) {
          console.log(true);
          console.log(apiError.response.data.error);

          error.value = apiError.response.data.error;
          return;
        }

        console.error("err : ", apiError);
      }
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
