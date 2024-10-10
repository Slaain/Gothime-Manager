<template>
    <div>
      <h1>Working Time</h1>
  
      <!-- Champ pour entrer l'ID de l'utilisateur -->
      <div class="user-select">
        <label for="userId">Enter User ID:</label>
        <input
          type="text"
          v-model="selectedUserId"
          @keyup.enter="fetchWorkingTimes"
          class="user-id-input"
          placeholder="Enter user ID"
        />
        <button @click="fetchWorkingTimes" class="fetch-button">Fetch Working Time</button>
      </div>
  
      <!-- Affichage des "working times" de l'utilisateur -->
      <div v-if="workingTimes.length">
        <div v-for="workingTime in workingTimes" :key="workingTime.id" class="working-time">
          <p><strong>Start:</strong> {{ workingTime.start }}</p>
          <p><strong>End:</strong> {{ workingTime.end || 'Still working' }}</p>
        </div>
      </div>
      
      <div v-else>
        <p>No working time data available.</p>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        selectedUserId: null,  // ID de l'utilisateur entré
        workingTimes: [],      // Données des working times de l'utilisateur
      };
    },
    methods: {
      // Récupérer les "working times" d'un utilisateur
      fetchWorkingTimes() {
        if (this.selectedUserId) {
          axios.get(`/api/workingtime/${this.selectedUserId}`)
            .then(response => {
              this.workingTimes = response.data;
            })
            .catch(error => {
              console.error('Error fetching working times:', error);
            });
        }
      }
    }
  };
  </script>
  
  <style scoped>
  /* Conteneur pour le champ de saisie de l'ID utilisateur */
  .user-select {
    margin-bottom: 20px;
  }
  
  /* Style pour le champ texte de l'ID utilisateur */
  .user-id-input {
    font-size: 18px;
    padding: 10px;
    width: 250px;
    border: 2px solid #ccc;
    border-radius: 5px;
    margin-right: 10px;
  }
  
  /* Style pour le bouton de recherche */
  .fetch-button {
    padding: 10px 20px;
    font-size: 16px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 5px;
    cursor: pointer;
  }
  
  .fetch-button:hover {
    background-color: #45a049;
  }
  
  /* Style simple pour les blocs de working-time */
  .working-time {
    margin-bottom: 20px;
    font-size: 16px;
  }
  </style>
  