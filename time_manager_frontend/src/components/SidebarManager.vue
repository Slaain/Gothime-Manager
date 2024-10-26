<template>
    <aside class="text-white bg-gray-900 sidebar">
      <div class="flex items-center justify-center py-6 logo">
        <img src="./assets/avatar.png" alt="Vue Logo" class="w-12 h-12" />
      </div>
      <nav class="flex flex-col space-y-4 text-center nav">
        <router-link to="/" class="p-2 bg-yellow-500 rounded-md hover:bg-yellow-700">
         Accueil
        </router-link>
        <router-link to="/organisations" class="p-2 bg-yellow-600 rounded-md hover:bg-yellow-600">
          Create Organisation
        </router-link>
        
      </nav>
    </aside>
  </template>
  
  <script>
  export default {
    name: 'SidebarManager'
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
  