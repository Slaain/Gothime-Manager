<template>
  <aside class="text-white bg-gray-900 sidebar">
    <div class="flex items-center justify-center py-6 logo">
      <img src="/public/logo.ico" alt="Vue Logo" class="w-12 h-12" />
    </div>
    <nav class="flex flex-col space-y-4 text-center nav">
      <router-link
        to="/admin"
        class="p-2 bg-gray-700 rounded-md hover:bg-gray-800"
        :class="{ 'bg-yellow-500 hover:bg-yellow-700': active === 'Dashboard' }"
      >
        Dashboard
      </router-link>
      <router-link
        to="/charts"
        class="p-2 bg-gray-700 rounded-md hover:bg-gray-800"
        :class="{ 'bg-yellow-500 hover:bg-yellow-700': active === 'Charts' }"
      >
        Charts
      </router-link>

      <!-- Bouton pour les Organisations -->
      <router-link
        to="/organisations"
        class="p-2 bg-gray-700 rounded-md hover:bg-gray-800"
        :class="{
          'bg-yellow-500 hover:bg-yellow-700': active === 'Organisations',
        }"
      >
        Organisations
      </router-link>
    </nav>
  </aside>
</template>
  
  <script>
export default {
  name: "Sidebar",
  // recup props from parent
  props: {
    active: String,
  },

  data() {
    return {};
  },

  mounted() {
    console.log(this.active);
  },
  methods: {},

  computed: {},

  watch: {},
};
</script>
  
  <style scoped>
/* Ajoute ici les styles de la sidebar si nécessaire */
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
  