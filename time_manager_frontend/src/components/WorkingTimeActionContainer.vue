<template>
  <div class="w-[40%] bg-green-400 flex flex-col justify-center items-center">
    <div class="border-b border-neutral-400">
      <!-- Bouton pour activer le mode création -->
      <button @click="setFormMode('create')" class="w-32 px-2 py-2 m-2 bg-indigo-400 rounded-lg">Créer</button>
      <!-- Bouton pour activer le mode modification -->
      <button @click="setFormMode('update')" class="w-32 px-2 py-2 m-2 bg-indigo-400 rounded-lg">Modifier</button>
    </div>

    <div>
      <!-- Afficher le formulaire de création si formMode est 'create' -->
      <div v-if="formMode === 'create'" class="flex flex-col items-start justify-center w-full m-2">
        <h2 class="mb-4 text-lg font-bold">Créer un nouveau temps de travail</h2>
        <!-- Dropdown et input pour la création -->
        <p>User</p>
        <button @click="toggleDropdown" class="w-full px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm">
          <span class="mr-2">Open Dropdown</span>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 ml-2 -mr-1" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M6.293 9.293a1 1 0 011.414 0L10 11.586l2.293-2.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
        <!-- Dropdown menu -->
        <div v-show="isOpen" class="absolute right-0 p-1 mt-2 space-y-1 bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5">
          <input v-model="searchTerm" class="block w-full px-4 py-2 text-gray-800 border border-gray-300 rounded-md focus:outline-none" type="text" placeholder="Search items" autocomplete="off">
          <a v-for="(item, index) in filteredItems" :key="index" href="#" class="block px-4 py-2 text-gray-700 rounded-md cursor-pointer hover:bg-gray-100 active:bg-blue-100">{{ item }}</a>
        </div>

        <p>Start time</p>
        <input type="datetime-local" v-model="startTime" class="w-32 px-2 py-2 m-2 rounded-lg">
        <p>End time</p>
        <input type="datetime-local" v-model="endTime" class="w-32 px-2 py-2 m-2 rounded-lg">
        <button @click="addWorkingTime" class="w-full px-4 py-2 mt-4 text-white bg-blue-500 rounded-md">Enregistrer</button>
      </div>

      <!-- Afficher le formulaire de modification si formMode est 'update' -->
      <div v-if="formMode === 'update'" class="flex flex-col items-start justify-center w-full m-2">
        <h2 class="mb-4 text-lg font-bold">Modifier le temps de travail</h2>
        <!-- Dropdown et input pour la modification -->
        <p>User</p>
        <button @click="toggleDropdown" class="w-full px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md shadow-sm">
          <span class="mr-2">Open Dropdown</span>
          <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5 ml-2 -mr-1" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
            <path fill-rule="evenodd" d="M6.293 9.293a1 1 0 011.414 0L10 11.586l2.293-2.293a1 1 0 111.414 1.414l-3 3a1 1 0 01-1.414 0l-3-3a1 1 0 010-1.414z" clip-rule="evenodd" />
          </svg>
        </button>
        <!-- Dropdown menu -->
        <div v-show="isOpen" class="absolute right-0 p-1 mt-2 space-y-1 bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5">
          <input v-model="searchTerm" class="block w-full px-4 py-2 text-gray-800 border border-gray-300 rounded-md focus:outline-none" type="text" placeholder="Search items" autocomplete="off">
          <a v-for="(item, index) in filteredItems" :key="index" href="#" class="block px-4 py-2 text-gray-700 rounded-md cursor-pointer hover:bg-gray-100 active:bg-blue-100">{{ item }}</a>
        </div>

        <p>Start time</p>
        <input type="datetime-local" v-model="startTime" class="w-32 px-2 py-2 m-2 rounded-lg">
        <p>End time</p>
        <input type="datetime-local" v-model="endTime" class="w-32 px-2 py-2 m-2 rounded-lg">
        <button @click="submitForm" class="w-full px-4 py-2 mt-4 text-white bg-blue-500 rounded-md">Modifier</button>
      </div>
    </div>
  </div>  
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      userId: 1, // Il faudra recuperer l'id de l'utilisateur selectionné
      userData: {}, // Contient les données de l'utilisateur
      isOpen: false, // Gère l'état du menu déroulant
      searchTerm: '', // Gère la recherche dans le menu déroulant
      items: ['Uppercase', 'Lowercase', 'Camel Case', 'Kebab Case'], // Contenu du menu déroulant
      startTime: '', // Variable pour l'heure de début
      endTime: '', // Variable pour l'heure de fin
      formMode: '', // Variable qui détermine si on est en mode 'create' ou 'update'
    };
  },
  mounted() {
    // Appel GET pour récupérer les données à l'initialisation du composant
    // this.fetchUserData();
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
    // fetchUserData() {
    //   axios.get()
    // },
    addWorkingTime() {
      // Ajouter ici la logique pour ajouter un temps de travail
      console.log("start time: ", this.startTime);
      console.log("end time: ", this.endTime);
      
      
     
      axios.post("http://localhost:4000/api/workingtime/1", {
    working_time: {
      start: this.startTime,
      end: this.endTime,
    }
  }, {
    headers: {
      'Content-Type': 'application/json',  // Assurez-vous que c'est compatible avec ce que votre serveur attend
    }
  })
  .then(response => {
    console.log("Réponse :", response.data);
  })
  .catch(error => {
    console.error("Erreur lors de la requête :", error);
  });
    },
    toggleDropdown() {
      this.isOpen = !this.isOpen; // Bascule l'affichage du menu déroulant
    },
    setFormMode(mode) {
      this.formMode = mode; // Définit si on est en mode 'create' ou 'update'
    },
    submitForm() {
      if (this.formMode === 'create') {
        console.log("Création d'un nouveau temps de travail");
        // Ajouter ici la logique de création (envoi au backend, mise à jour des données, etc.)
      } else if (this.formMode === 'update') {
        console.log("Modification du temps de travail");
        // Ajouter ici la logique de modification (envoi au backend, mise à jour des données, etc.)
      }
      // Réinitialiser les champs après soumission
      this.startTime = '';
      this.endTime = '';
      this.formMode = '';
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
