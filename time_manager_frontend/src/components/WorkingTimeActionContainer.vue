<template>
  <div class="w-[40%] bg-green-400 flex flex-col justify-center items-center">
    <div class="border-b border-neutral-400">
      <button @click="createWorkingTime" class="w-32 px-2 py-2 m-2 bg-indigo-400 rounded-lg">Créer</button>
      <button @click="updateWorkingTime" class="w-32 px-2 py-2 m-2 bg-indigo-400 rounded-lg">Modifier</button>
    </div>

    <div>
      <div class="relative items-start w-full m-2 group">
        <!-- Dropdown button -->
        <p class="mb-2 text-gray-700">User</p>
        <button @click="toggleDropdown" class="inline-flex justify-center w-full px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-blue-500">
          <span class="mr-2">Open Dropdown</span>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 ml-2 -mr-1" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M6.293 9.293a1 1 0 011.414 0L10 11.586l2.293-2.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
        <!-- Dropdown menu -->
        <div v-show="isOpen" class="absolute right-0 p-1 mt-2 space-y-1 bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5">
          <!-- Search input -->
          <input v-model="searchTerm" class="block w-full px-4 py-2 text-gray-800 border border-gray-300 rounded-md focus:outline-none" type="text" placeholder="Search items" autocomplete="off">
          <!-- Dropdown content -->
          <a v-for="(item, index) in filteredItems" :key="index" href="#" class="block px-4 py-2 text-gray-700 rounded-md cursor-pointer hover:bg-gray-100 active:bg-blue-100">{{ item }}</a>
        </div>
      </div>
      <!-- Time input fields -->
      <div class="flex flex-col items-start justify-center w-full m-2">
        <p>Start time</p>
        <input type="datetime-local" v-model="date" class="w-32 px-2 py-2 m-2 rounded-lg">
      </div>
      <div class="flex flex-col items-start justify-center w-full m-2">
        <p>End time</p>
        <input type="datetime-local" v-model="date" class="w-32 px-2 py-2 m-2 rounded-lg">
      </div>
    </div>
  </div>  
</template>

<script>
export default {
  data() {
    return {
      isOpen: false, // Gère l'état du menu déroulant
      searchTerm: '', // Gère la recherche dans le menu déroulant
      items: ['Uppercase', 'Lowercase', 'Camel Case', 'Kebab Case'], // Contenu du menu déroulant
      date: '', // Variable pour les champs de temps
    };
  },
  computed: {
    // Filtre les éléments en fonction de la recherche
    filteredItems() {
      if (!this.searchTerm) {
        return this.items;
      }
      return this.items.filter(item => item.toLowerCase().includes(this.searchTerm.toLowerCase()));
    },
  },
  methods: {
    toggleDropdown() {
      this.isOpen = !this.isOpen; // Bascule l'affichage du menu déroulant
    },
    createWorkingTime() {
      console.log("Créer du temps de travail");
    },
    updateWorkingTime() {
      console.log("Modifier du temps de travail");
    },
  },
};
</script>
    
<style scoped>
.item {
  margin-top: 2rem;
  display: flex;
  position: relative;
}

.details {
  flex: 1;
  margin-left: 1rem;
}

i {
  display: flex;
  place-items: center;
  place-content: center;
  width: 32px;
  height: 32px;

  color: var(--color-text);
}

h3 {
  font-size: 1.2rem;
  font-weight: 500;
  margin-bottom: 0.4rem;
  color: var(--color-heading);
}

@media (min-width: 1024px) {
  .item {
    margin-top: 0;
    padding: 0.4rem 0 1rem calc(var(--section-gap) / 2);
  }

  i {
    top: calc(50% - 25px);
    left: -26px;
    position: absolute;
    border: 1px solid var(--color-border);
    background: var(--color-background);
    border-radius: 8px;
    width: 50px;
    height: 50px;
  }

  .item:before {
    content: ' ';
    border-left: 1px solid var(--color-border);
    position: absolute;
    left: 0;
    bottom: calc(50% + 25px);
    height: calc(50% - 25px);
  }

  .item:after {
    content: ' ';
    border-left: 1px solid var(--color-border);
    position: absolute;
    left: 0;
    top: calc(50% + 25px);
    height: calc(50% - 25px);
  }

  .item:first-of-type:before {
    display: none;
  }

  .item:last-of-type:after {
    display: none;
  }
}
</style>
