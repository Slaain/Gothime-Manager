<script setup>
import Dropdown from './Dropdown.vue';
</script>

<template>
  <div class="w-[40%] bg-green-400 flex flex-col justify-center items-center">
    <div class="border-b">
      
      <button @click="setFormMode('create')" :class="['focus:outline-none text-white bg-purple-700 focus:bg-purple-700 hover:bg-purple-800 focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2 dark:bg-purple-600 dark:hover:bg-purple-700 dark:focus:ring-purple-900', formMode == 'create' ? 'bg-purple-900' : '']">
        Créer
      </button>
      <button @click="setFormMode('update')" class="focus:outline-none text-white bg-purple-700 focus:bg-purple-700 hover:bg-purple-800  focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2 dark:bg-purple-600 dark:hover:bg-purple-700 dark:focus:ring-purple-900">Modifier</button>
    </div>

    <div class="">
      <!-- Afficher le formulaire de création si formMode est 'create' -->
      <div v-if="formMode === 'create'" class="flex flex-col items-start justify-center w-64 m-2 ">
        <h2 class="mb-4 text-lg font-bold">Créer un nouveau temps de travail</h2>
        <!-- Dropdown et input pour la création -->
        <p class="mb-2">User</p>
        <p>{{ selectedUserId }}</p>
        <Dropdown  :onUserSelected="handleUserSelected"/>
        <!-- Dropdown menu -->
        <div v-show="isOpen" class="absolute right-0 p-1 mt-2 space-y-1 bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5">
          <input v-model="searchTerm" class="block w-full px-4 py-2 text-gray-800 border border-gray-300 rounded-md focus:outline-none" type="text" placeholder="Search items" autocomplete="off">
          <a v-for="(item, index) in filteredItems" :key="index" href="#" class="block px-4 py-2 text-gray-700 rounded-md cursor-pointer hover:bg-gray-100 active:bg-blue-100">{{ item }}</a>
        </div>
        <div class="w-full">
        <p>Start time</p>
        <input type="datetime-local" v-model="startTime" class="w-full px-2 py-2 rounded-lg ">
        </div>
        <div class="w-full">
        <p>End time</p>
        <input type="datetime-local" v-model="endTime" class="w-full px-2 py-2 rounded-lg">
        </div>
        <button @click="addWorkingTime" class="w-full px-4 py-2 mt-4 text-white bg-blue-500 rounded-md">Enregistrer</button>
      </div>

      <!-- Afficher le formulaire de modification si formMode est 'update' -->
      <div v-if="formMode === 'update'" class="flex flex-col items-start justify-center w-64 m-2">
        <h2 class="mb-4 text-lg font-bold">Modifier le temps de travail</h2>
        <!-- Dropdown et input pour la modification -->
        <div>

        
        <p class="mb-2">User</p>
        <Dropdown />
        </div>

        <div class="w-full">
        <p>Start time</p>
        <input type="datetime-local" v-model="startTime" class="w-full px-2 py-2 rounded-lg" value={{data.start}}>
        </div>

        <div class="w-full">
        <p>End time</p>
        <input type="datetime-local" v-model="endTime" class="w-full px-2 py-2 rounded-lg" value={{data.end}}>
        </div>
        <button @click="updateWorkingTime" class="w-full px-4 py-2 mt-4 text-white bg-blue-500 rounded-md">Modifier</button>
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
    this.getWorkingTime();
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
    updateWorkingTime() {
      // Ajouter ici la logique pour modifier un temps de travail
      axios.put("http://localhost:4000/api/workingtime/2", {
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
     getWorkingTime() {
    axios.get("http://localhost:4000/api/workingtime/1/2")
    .then(response => {
      // Assigner les données reçues à startTime et endTime
      const workingTimeData = response.data; 

    console.log('Données récupérées :', workingTimeData.data);


      const formatDate = (dateString) => {
  const date = new Date(dateString);
  return date.toISOString().slice(0, 16); // Format 'YYYY-MM-DDTHH:MM'
};


    this.startTime = formatDate(workingTimeData.data.start);
this.endTime = formatDate(workingTimeData.data.end);
    })
    .catch(error => {
      console.error("Erreur lors de la requête :", error);
    });
  },
   handleUserSelected(userId) {
      this.selectedUserId = userId; // Met à jour l'ID lorsque l'utilisateur est sélectionné
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
