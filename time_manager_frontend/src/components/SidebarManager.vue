<template>
    <aside class="text-white bg-gray-900 sidebar">
      <div class="flex items-center justify-center py-6 logo">
        <img src="/public/logo.ico" alt="Vue Logo" class="w-12 h-12" />
      </div>
      <nav class="flex flex-col space-y-4 text-center nav">
        <router-link to="/" class="p-2 bg-yellow-500 rounded-md hover:bg-yellow-700">
         Accueil
        </router-link>   
      </nav>
     
    </aside>
 
  </template>
  
  <script>
  import CreateOrganisationModal from "../components/CreateOrganisationModal.vue";

  export default {
    name: 'SidebarManager'
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
  