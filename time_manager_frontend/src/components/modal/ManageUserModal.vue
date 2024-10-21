<template>
    <div class="modal-backdrop">
      <div class="modal-content p-4 bg-white rounded-lg shadow">
        <h2 class="text-xl font-semibold mb-4">Gérer les utilisateurs</h2>
  
        <!-- Liste des utilisateurs ici -->
        <ul>
          <li v-for="user in users" :key="user.id">
            {{ user.name }}
            <button @click="removeUser(user.id)" class="text-red-500 ml-2 hover:underline">Supprimer</button>
          </li>
        </ul>
  
        <div class="flex justify-end mt-4">
          <button @click="$emit('close')" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Fermer</button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    props: {
      organisationId: {
        type: Number,
        required: true
      }
    },
    data() {
      return {
        users: []
      };
    },
    mounted() {
      this.fetchUsers();
    },
    methods: {
      async fetchUsers() {
        try {
          const response = await axios.get(`http://localhost:4000/api/organisations/${this.organisationId}/users`);
          this.users = response.data.data;
        } catch (error) {
          console.error("Erreur lors de la récupération des utilisateurs:", error);
        }
      },
      async removeUser(userId) {
        try {
          await axios.delete(`http://localhost:4000/api/users/${userId}`);
          this.users = this.users.filter(user => user.id !== userId);
        } catch (error) {
          console.error("Erreur lors de la suppression de l'utilisateur:", error);
        }
      }
    }
  };
  </script>
  
  <style scoped>
  .modal-backdrop {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: rgba(0, 0, 0, 0.5);
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .modal-content {
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    width: 400px;
  }
  </style>
  