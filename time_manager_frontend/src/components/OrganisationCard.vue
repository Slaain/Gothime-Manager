<template>
  <div>
    <!-- La carte de l'organisation -->
    <div class="organisation-card glassmorphism-bg-white p-6 shadow-md rounded-xl">
      <div class="header flex justify-between items-center mb-4">
        <h2 class="text-xl font-semibold text-white">{{ organisation.name }}</h2>
        <button @click="modifyOrganisation" class="btn btn-primary">Modifier</button>
      </div>

      <!-- Ajout du bouton "Add Group" au milieu de la carte -->
      <div class="mb-4 flex justify-center">
        <button @click="openCreateGroupModal" class="btn btn-primary">
          Add Group
        </button>
      </div>

      <!-- Liste des groupes -->
      <div class="groups-container overflow-y-auto mb-4">
        <h3 class="font-medium text-white">List Groups:</h3>
        <ul>
          <li v-for="group in groups" :key="group.id" class="flex justify-between items-center mb-2 text-white">
            {{ group.groupname }}
            <button @click="viewGroup(group)" class="btn btn-secondary ml-4">Voir</button>
          </li>
        </ul>
      </div>

      <button @click="viewUsers" class="btn btn-secondary mt-2">Voir Users</button>
    </div>

    <!-- Détails du groupe sélectionné et gestion des utilisateurs -->
    <div v-if="showGroupModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70">
      <div class="modal-content glassmorphism-bg-white relative p-10 rounded-lg shadow-lg w-full max-w-3xl pt-9">
        <button @click="closeGroupModal" class="close-button absolute top-2 right-2 bg-yellow-400 text-black font-bold px-3 py-1 rounded">X</button>

        <h3 class="text-2xl font-bold mb-4 text-white">Group: {{ selectedGroup.groupname }}</h3>
        <p class="mb-4 text-white">Start: {{ selectedGroup.start_date }} | End: {{ selectedGroup.end_date }}</p>

        <!-- Working Times associés -->
        <h4 class="text-lg font-bold mb-2 text-white">Working Times</h4>
        <ul>
          <li v-for="time in selectedGroupWorkingTimes" :key="time.id" class="flex justify-between mb-2">
            <span class="text-white">Start: {{ time.start }} - End: {{ time.end }}</span>
          </li>
        </ul>

        <!-- Liste des utilisateurs -->
        <h4 class="text-lg font-bold mb-2 text-white">Users in this Group</h4>
        <ul>
          <li v-for="user in selectedGroupUsers" :key="user.id" class="flex justify-between mb-2">
            <span class="text-white">{{ user.username }} ({{ user.email }})</span>
            <button @click="removeUserFromGroup(user.id)" class="text-red-600 hover:underline">Remove</button>
          </li>
        </ul>

        <!-- Bouton pour ajouter un utilisateur -->
        <button @click="openUserModal" class="bg-blue-500 text-white px-4 py-2 mt-4 rounded hover:bg-blue-600">Add User</button>
      </div>
    </div>

    <!-- Modale pour créer un groupe avec le composant CreaGroupComponent en dehors de la carte -->
    <div v-if="showCreateGroupModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70">
      <div class="modal-content glassmorphism-bg-white relative p-10 rounded-lg shadow-lg w-full max-w-3xl pt-9">
        <button @click="closeCreateGroupModal" class="close-button absolute top-2 right-2 bg-yellow-400 text-black font-bold px-3 py-1 rounded">X</button>
        <!-- Appel du composant CreaGroupComponent -->
        <CreaGroupComponent @close="closeCreateGroupModal" />
      </div>
    </div>

    <!-- Modale d'ajout d'utilisateur -->
    <div v-if="showUserModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
      <div class="modal-content glassmorphism-bg-white w-1/2 px-8 py-4 rounded-lg shadow-md">
        <h3 class="text-lg font-semibold text-yellow-400 mb-4">Add User to Group</h3>

        <!-- Select pour afficher tous les utilisateurs disponibles -->
        <select v-model="selectedUser" class="w-full p-2 border rounded mb-4 text-black">
          <option v-for="user in allUsers" :key="user.id" :value="user.id">
            {{ user.username }} ({{ user.email }})
          </option>
        </select>

        <div class="flex justify-end gap-4 mt-4">
          <button @click="addUserToGroup" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">
            Add
          </button>
          <button @click="closeUserModal" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">
            Cancel
          </button>
        </div>
      </div>
    </div>
  </div>
</template>


<script>
import axios from "axios";
import CreaGroupComponent from '../components/CreaGroupComponent.vue';

export default {
  props: {
    organisation: {
      type: Object,
      required: true,
    },
  },
  components: {
    CreaGroupComponent,
  },
  data() {
    return {
      groups: [],
      selectedGroup: null,
      selectedGroupUsers: [],
      selectedGroupWorkingTimes: [],
      allUsers: [],
      showCreateGroupModal: false,
      showGroupModal: false,
      showUserModal: false,
      selectedUser: null,
    };
  },
  mounted() {
    this.fetchGroups();
    this.fetchAllUsers(); // Charger tous les utilisateurs pour l'ajout dans le groupe
  },
  methods: {
    modifyOrganisation() {
      this.$emit("modify-organisation", this.organisation.id);
    },
    async fetchGroups() {
      try {
        const response = await axios.get(
            `http://localhost:4000/api/organisations/${this.organisation.id}`
        );
        this.groups = response.data.data.groups;
      } catch (error) {
        console.error("Erreur lors de la récupération des groupes:", error);
      }
    },
    async fetchAllUsers() {
      try {
        const response = await axios.get(
            'http://localhost:4000/api/users?limit=100&offset=0'
        );
        this.allUsers = response.data.users || [];
      } catch (error) {
        console.error("Erreur lors de la récupération des utilisateurs :", error);
      }
    },
    async viewGroup(group) {
      try {
        const response = await axios.get(
            `http://localhost:4000/api/groups/${group.id}`
        );

        // Mettre à jour selectedGroup avec les données de l'API
        this.selectedGroup = {
          ...group,
          groupname: response.data.data.name,
          start_date: response.data.data.start_date,
          end_date: response.data.data.end_date,
        };

        this.selectedGroupUsers = response.data.data.users || [];
        this.selectedGroupWorkingTimes = response.data.data.workingtimes || [];
        this.showGroupModal = true;
      } catch (error) {
        console.error("Erreur lors de la récupération des détails du groupe :", error);
      }
    },
    closeGroupModal() {
      this.showGroupModal = false;
      this.selectedGroup = null;
      this.selectedGroupUsers = [];
      this.selectedGroupWorkingTimes = [];
    },
    openCreateGroupModal() {
      this.showCreateGroupModal = true;
    },
    closeCreateGroupModal() {
      this.showCreateGroupModal = false;
    },
    openUserModal() {
      this.showUserModal = true;
    },
    closeUserModal() {
      this.showUserModal = false;
      this.selectedUser = null;
    },
    async addUserToGroup() {
      if (!this.selectedUser) {
        console.error("Aucun utilisateur sélectionné");
        return;
      }
      try {
        await axios.post(
            `http://localhost:4000/api/groups/${this.selectedGroup.id}/users/${this.selectedUser}`,
            {},
            { headers: { "Content-Type": "application/json" } }
        );
        this.viewGroup(this.selectedGroup);
        this.closeUserModal();
      } catch (error) {
        console.error("Erreur lors de l'ajout de l'utilisateur :", error);
      }
    },
    async removeUserFromGroup(userId) {
      try {
        await axios.delete(
            `http://localhost:4000/api/groups/${this.selectedGroup.id}/users/${userId}`
        );
        this.selectedGroupUsers = this.selectedGroupUsers.filter(
            (user) => user.id !== userId
        );
      } catch (error) {
        console.error("Erreur lors de la suppression de l'utilisateur :", error);
      }
    },
  },
};
</script>


<style scoped>
/* Taille fixe de la carte */
.organisation-card {
  width: 300px;  /* Largeur fixe */
  height: 400px; /* Hauteur fixe */
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

/* Glassmorphism pour correspondre au design global */
.glassmorphism-bg-white {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  position: relative;
  color: white;
}

.glassmorphism-bg-white::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 2px;
  border-radius: 10px;
  background: linear-gradient(
      to bottom right,
      #ffffff,
      rgba(255, 255, 255, 0.2),
      #fdcb12
  );
  opacity: 0.3;
  pointer-events: none;
}

.header h2 {
  color: #fdcb12;
}

/* Liste des groupes avec une scrollbar stylisée */
.groups-container {
  overflow-y: auto;
  max-height: 175px; /* Hauteur maximale de la liste des groupes */
  flex-grow: 1;
  margin-bottom: 10px;
}

.groups-container::-webkit-scrollbar {
  width: 6px;
}

.groups-container::-webkit-scrollbar-thumb {
  background-color: #000; /* Couleur noire pour la scrollbar */
  border-radius: 10px; /* Bordure arrondie pour la scrollbar */
}

.groups-container::-webkit-scrollbar-track {
  background: transparent; /* Couleur transparente pour l'arrière-plan de la scrollbar */
}

/* Styles des boutons */
.btn {
  padding: 0.5em 1em;
  border-radius: 5px;
  transition: background-color 0.3s;
}

.btn-primary {
  background-color: #fdcb12;
  color: black;
}

.btn-primary:hover {
  background-color: #f5b900;
}

.btn-secondary {
  background-color: #6c757d;
  color: white;
}

.btn-secondary:hover {
  background-color: #5a6268;
}

/* Styles pour la modale */
.modal-content {
  background-color: #282828; /* Fond plus clair pour plus de contraste */
  padding: 30px; /* Plus de padding pour un espace plus aéré */
  border-radius: 15px; /* Bordure plus arrondie */
  width: 100%; /* Taille large */
  max-width: 768px; /* Limite maximale de largeur */
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.5); /* Renforcer l'ombre */
  position: relative;
}

.close-button {
  background-color: #fbbf24; /* Couleur jaune */
  color: black;
  padding: 5px 15px;
  border-radius: 5px;
  font-weight: bold;
}m

 .close-button:hover {
   background-color: #f59e0b; /* Couleur jaune plus foncée */
 }
</style>
