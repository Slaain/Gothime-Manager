<script setup>
import Dropdown from './Dropdown.vue';
</script>

<template>
  <div class="w-[40%] shadow-md rounded-lg flex flex-col justify-center items-center">
    <div class="border-b">
      <!-- Bouton pour afficher le temps de travail d'un utilisateur -->
      <button @click="setFormMode('show')" 
              :class="['focus:outl<ine-none m-2 border border-purple-800 bg-white focus:text-white focus:bg-purple-800 hover:bg-purple-800 hover:text-white focus:ring-purple-300 font-medium rounded-lg text-sm px-5 py-2.5 mb-2', 
              formMode === 'show' ? 'bg-purple-800 text-white' : '']">
        Afficher
      </button>
    </div>

      <!-- Afficher le workingTime -->
      <div v-if="formMode === 'show'" class="flex flex-col items-start justify-center w-full px-4 py-4">
        <h2 class="mb-4 text-lg font-bold">Afficher le temps de travail</h2>
        <!-- Champ texte pour entrer l'ID de l'utilisateur -->
      <p class="mb-2">ID de l'utilisateur</p>
      <input v-model="userId" type="text" class="w-full p-2 border rounded-md" placeholder="Entrer l'ID de l'utilisateur">
      <!-- Bouton pour déclencher la récupération du workingTime -->
        <button @click="showWorkingTime" class="w-full px-4 py-2 mt-4 text-white bg-purple-700 rounded-md hover:bg-purple-800">
          Afficher
        </button>
        <!-- Affichage des temps de travail -->

          <div v-if="workingTime">
            <table class="min-w-full bg-white">
            <thead class="border-b">
            <tr>
              <th class="text-left px-4 py-2 text-gray-600">Session</th>
              <th class="text-left px-4 py-2 text-gray-600">Start</th>
              <th class="text-left px-4 py-2 text-gray-600">End</th>
              <th class="text-left px-4 py-2 text-gray-600">Duration (hrs)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(wt, index) in workingTimes" :key="wt.id" class="border-b">
              <td class="px-4 py-2">{{ `Session ${index + 1}` }}</td>
              <td class="px-4 py-2">{{ formatDateTime(wt.start) }}</td>
              <td class="px-4 py-2">{{ formatDateTime(wt.end) }}</td>
              <td class="px-4 py-2">{{ calculateDuration(wt.start, wt.end) }}</td>
            </tr>
            </tbody>
          </table>
          </div>


      </div>
    </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      userId: "", // Stocke l'ID de l'utilisateur saisi
      workingTime: null, // Stocke les données récupérées du backend
      formMode: '', // Gère le mode du formulaire
    };
  },
  methods: {
    setFormMode(mode) {
      this.formMode = mode;
    },
    // Méthode pour afficher le workingTime d'un utilisateur
 
    showWorkingTime() {
  if (!this.userId) {
    alert("Veuillez entrer l'ID de l'utilisateur");
    return;
  }
  
  // Appel à l'API pour récupérer le workingTime de l'utilisateur
  axios.get(`http://localhost:4000/api/workingtimes/1/1`)
    .then(response => {
      if (response.data && response.data.length > 0) {
        // Si les données existent, prenez le premier workingTime
        this.workingTime = response.data[0];
      } else {
        alert("Aucun workingTime trouvé pour cet utilisateur");
        this.workingTime = null;
      }
    })
    .catch(error => {
      console.error("Erreur lors de la récupération des données :", error);
    });
}

  }
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
