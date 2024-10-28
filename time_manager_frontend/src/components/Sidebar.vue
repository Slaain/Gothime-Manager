<template>
  <aside class="text-white bg-gray-900 sidebar">
    <div class="flex items-center justify-center py-6 logo">
      <img src="/public/logo.ico" alt="Vue Logo" class="w-12 h-12" />
    </div>
    <nav class="flex flex-col space-y-4 text-center nav">
      <!-- Afficher que si on est admin -->

      <router-link
        v-if="isUserAdmin"
        to="/admin"
        class="p-2 bg-gray-700 rounded-md hover:bg-gray-800"
        :class="{
          'bg-yellow-500 hover:bg-yellow-700': active === 'Dashboard',
        }"
      >
        Dashboard
      </router-link>
      <router-link
        v-if="isUserAdmin"
        to="/charts"
        class="p-2 bg-gray-700 rounded-md hover:bg-gray-800"
        :class="{ 'bg-yellow-500 hover:bg-yellow-700': active === 'Charts' }"
      >
        Charts
      </router-link>

      <!-- Bouton pour les Organisations -->
      <router-link
        v-if="isUserAdmin"
        to="/organisations"
        class="p-2 bg-gray-700 rounded-md hover:bg-gray-800"
        :class="{
          'bg-yellow-500 hover:bg-yellow-700': active === 'Organisations',
        }"
      >
        Organisations
      </router-link>

      <router-link
        v-if="isUserManager"
        to="/manager/2"
        class="p-2 bg-gray-700 rounded-md hover:bg-gray-800"
        :class="{
          'bg-yellow-500 hover:bg-yellow-700': active === 'Manager',
        }"
      >
        Manager
      </router-link>
    </nav>
  </aside>
</template>

<script>
import { isUserAdmin, isUserManager } from "../auth";

export default {
  name: "Sidebar",
  props: {
    active: String,
  },
  data() {
    return {
      isUserAdmin: false,
      isUserManager: false,
    };
  },
  async mounted() {
    try {
      // Récupérer les statuts admin et manager de manière asynchrone
      this.isUserAdmin = await isUserAdmin(localStorage.getItem("authToken"));
      this.isUserManager = await isUserManager(
        localStorage.getItem("authToken")
      );
      console.log("isUserAdmin:", this.isUserAdmin);
      console.log("isUserManager:", this.isUserManager);
    } catch (error) {
      console.error(
        "Erreur lors de la récupération des statuts utilisateur:",
        error
      );
    }
  },
};
</script>

<style scoped>
.sidebar {
  width: 200px;
  background-color: #212327;
  padding: 20px;
}
.nav {
  display: flex;
  flex-direction: column;
}
</style>
