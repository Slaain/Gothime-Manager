<template>
  <div>
    <!-- La carte de l'organisation -->
    <div
      class="p-6 shadow-md organisation-card glassmorphism-bg-white rounded-xl"
    >
      <div class="flex items-center justify-between mb-4 header">
        <h2 class="text-xl font-semibold text-white">
          {{ organisation.name }}
        </h2>
        <button @click="modifyOrganisation" class="btn btn-primary">
          Modifier
        </button>
      </div>

      <!-- Ajout du bouton "Add Group" au milieu de la carte -->
      <div class="flex justify-center mb-4">
        <button @click="openCreateGroupModal" class="btn btn-primary">
          Add Group
        </button>
      </div>

      <!-- Liste des groupes -->
      <div class="mb-4 overflow-y-auto groups-container">
        <h3 class="font-medium text-white">List Groups:</h3>
        <ul>
          <li
            v-for="group in groups"
            :key="group.id"
            class="flex items-center justify-between mb-2 text-white"
          >
            {{ group.groupname }}
            <button @click="viewGroup(group)" class="ml-4 btn btn-secondary">
              Voir
            </button>
          </li>
        </ul>
      </div>

      <button @click="viewUsers" class="mt-2 btn btn-secondary">
        Voir Users
      </button>
    </div>

    <!-- Détails du groupe sélectionné et gestion des utilisateurs -->
    <div
      v-if="showGroupModal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70"
    >
      <div
        class="relative w-full max-w-3xl p-10 rounded-lg shadow-lg modal-content glassmorphism-bg-white pt-9"
      >
        <button
          @click="closeGroupModal"
          class="absolute px-3 py-1 font-bold text-black bg-yellow-400 rounded close-button top-2 right-2"
        >
          X
        </button>

        <h3 class="mb-4 text-2xl font-bold text-white">
          Group: {{ selectedGroup.groupname }}
        </h3>
        <p class="mb-4 text-white">
          Start: {{ formatDate(selectedGroup.start_date) }} | End:
          {{ formatDate(selectedGroup.end_date) }}
        </p>

        <!-- Working Times associés -->
        <h4 class="mb-2 text-lg font-bold text-white">Working Times</h4>
        <ul>
          <li
            v-for="time in selectedGroupWorkingTimes"
            :key="time.id"
            class="flex justify-between mb-2"
          >
            <span class="text-white"
              >Start: {{ formatDate(time.start) }} - End:
              {{ formatDate(time.end) }}</span
            >
          </li>
        </ul>

        <!-- Liste des utilisateurs -->
        <h4 class="mb-2 text-lg font-bold text-white">Users in this Group</h4>
        <ul>
          <li
            v-for="user in selectedGroupUsers"
            :key="user.id"
            class="flex justify-between mb-2"
          >
            <span class="text-white"
              >{{ user.username }} ({{ user.email }})</span
            >
            <button
              @click="removeUserFromGroup(user.id)"
              class="text-red-600 hover:underline"
            >
              Remove
            </button>
          </li>
        </ul>

        <!-- Boutons pour ajouter un utilisateur ou supprimer le groupe -->
        <div class="flex justify-between mt-4">
          <button
            @click="openUserModal"
            class="px-4 py-2 text-white bg-blue-500 rounded hover:bg-blue-600"
          >
            Add User
          </button>
          <button
            @click="deleteGroup"
            class="px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600"
          >
            Delete Group
          </button>
        </div>
      </div>
    </div>

    <!-- Modale pour créer un groupe avec le composant CreaGroupComponent en dehors de la carte -->
    <div
      v-if="showCreateGroupModal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70"
    >
      <div
        class="relative w-full max-w-3xl p-10 rounded-lg shadow-lg modal-content glassmorphism-bg-white pt-9"
      >
        <button
          @click="closeCreateGroupModal"
          class="absolute px-3 py-1 font-bold text-black bg-yellow-400 rounded close-button top-2 right-2"
        >
          X
        </button>
        <!-- Appel du composant CreaGroupComponent -->
        <CreaGroupComponent
          @group-created="handleGroupCreated"
          @close="closeCreateGroupModal"
        />
      </div>
    </div>

    <!-- Modale d'ajout d'utilisateur -->
    <div
      v-if="showUserModal"
      class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
    >
      <div
        class="w-1/2 px-8 py-4 rounded-lg shadow-md modal-content glassmorphism-bg-white"
      >
        <h3 class="mb-4 text-lg font-semibold text-yellow-400">
          Add User to Group
        </h3>

        <!-- Select pour afficher tous les utilisateurs disponibles -->
        <select
          v-model="selectedUser"
          class="w-full p-2 mb-4 text-black border rounded"
        >
          <option v-for="user in allUsers" :key="user.id" :value="user.id">
            {{ user.username }} ({{ user.email }})
          </option>
        </select>

        <div class="flex justify-end gap-4 mt-4">
          <button
            @click="addUserToGroup"
            class="px-4 py-2 text-white bg-green-500 rounded hover:bg-green-600"
          >
            Add
          </button>
          <button
            @click="closeUserModal"
            class="px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import CreaGroupComponent from "../components/CreaGroupComponent.vue";

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
        console.log("Groups:", response.data.data.groups);

        this.groups = response.data.data.groups;
      } catch (error) {
        console.error("Erreur lors de la récupération des groupes:", error);
      }
    },
    formatDate(date) {
      const options = {
        year: "numeric",
        month: "2-digit",
        day: "2-digit",
        hour: "2-digit",
        minute: "2-digit",
      };
      return new Date(date)
        .toLocaleDateString("fr-FR", options)
        .replace(",", "");
    },
    async fetchAllUsers() {
      try {
        const response = await axios.get(
          "http://localhost:4000/api/users?limit=100&offset=0"
        );
        this.allUsers = response.data.users || [];
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs :",
          error
        );
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
        console.error(
          "Erreur lors de la récupération des détails du groupe :",
          error
        );
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
    handleGroupCreated() {
      // Relancer la requête pour obtenir la liste mise à jour des groupes après ajout
      this.fetchGroups();
      this.closeCreateGroupModal();
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
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
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
          `http://localhost:4000/api/groups/${this.selectedGroup.id}/users/${userId}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.selectedGroupUsers = this.selectedGroupUsers.filter(
          (user) => user.id !== userId
        );
      } catch (error) {
        console.error(
          "Erreur lors de la suppression de l'utilisateur :",
          error
        );
      }
    },
    async deleteGroup() {
      if (!this.selectedGroup) {
        console.error("Aucun groupe sélectionné");
        return;
      }
      try {
        await axios.delete(
          `http://localhost:4000/api/groups/${this.selectedGroup.id}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.closeGroupModal();
        this.fetchGroups(); // Mettre à jour la liste des groupes après suppression
      } catch (error) {
        console.error("Erreur lors de la suppression du groupe :", error);
      }
    },
  },
};
</script>


<style scoped>
/* Taille fixe de la carte */
.organisation-card {
  width: 300px; /* Largeur fixe */
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
}
m .close-button:hover {
  background-color: #f59e0b; /* Couleur jaune plus foncée */
}
</style>
