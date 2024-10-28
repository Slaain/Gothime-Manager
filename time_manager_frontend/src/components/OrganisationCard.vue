<template>
  <div>
    <!-- La carte de l'organisation -->
    <div
      class="p-6 shadow-md organisation-card glassmorphism-bg-white rounded-xl"
    >
      <div class="flex items-center justify-between mb-4 header" @click.stop>
        <!-- Affichage du nom de l'organisation ou champ d'édition -->
        <h2 v-if="!isEditing" class="text-xl font-semibold text-white">
          {{ organisation.name }}
        </h2>
        <div v-if="isEditing" class="flex items-center">
          <input
            v-model="organisationName"
            @keyup.enter="saveOrganisationName"
            @blur="toggleEdit"
            class="text-xl font-semibold input-field"
            type="text"
          />
          <!-- Bouton de coche pour sauvegarder -->
          <button @click="saveOrganisationName" class="ml-2 btn-save">
            <i class="fas fa-check"></i>
          </button>
        </div>
        <!-- Regrouper les boutons d'édition et de suppression ensemble à droite -->
        <div class="flex action-buttons">
          <button @click="toggleEdit" class="btn-edit" v-if="!isEditing">
            <i class="fas fa-pencil-alt"></i>
            <!-- Icône de stylo -->
          </button>
          <button
            @click="deleteOrganisation"
            class="btn-delete"
            v-if="!isEditing"
          >
            <i class="fas fa-trash"></i>
          </button>
        </div>
      </div>

      <!-- Bouton "Add Group" au centre -->
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
              Show
            </button>
          </li>
        </ul>
      </div>

      <button @click="viewUsers" class="mt-2 btn btn-secondary">
        Show Users
      </button>
    </div>

    <!-- Modale pour détails du groupe et gestion des utilisateurs -->
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

    <!-- Modale pour créer un groupe avec CreaGroupComponent -->
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
        <select
          v-model="selectedUser"
          class="w-full p-2 mb-4 text-white border rounded"
        >
          <option
            class="text-black"
            v-for="user in allUsers"
            :key="user.id"
            :value="user.id"
          >
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
import { useToast } from "vue-toastification";

export default {
  props: {
    organisation: {
      type: Object,
      required: true,
    },
  },
  setup() {
    const toast = useToast(); // Utiliser le toast via setup
    return { toast };
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
      isEditing: false,
      organisationName: this.organisation.name, // Initialise avec le nom actuel de l'organisation
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
    async saveOrganisationName() {
      try {
        await axios.put(
          `http://localhost:4000/api/organisations/${this.organisation.id}`,
          {
            organisation: { name: this.organisationName },
          },
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );

        // Affiche un toast de succès après la mise à jour
        this.toast.success("Organisation's name updated successfully!");

        this.$emit("organisation-updated");

        this.isEditing = false; // Revenir à l'affichage normal après la sauvegarde
      } catch (error) {
        // Affiche un toast d'erreur en cas de problème
        this.toast.error("Error updating the organisation's name.");
        console.error(
          "Erreur lors de la mise à jour du nom de l'organisation:",
          error
        );
      }
    },
    toggleEdit() {
      if (!this.isEditing) {
        this.isEditing = true; // Activer le mode édition
      }
    },
    cancelEdit() {
      if (this.isEditing) {
        this.isEditing = false; // Désactiver le mode édition
        this.organisationName = this.organisation.name; // Réinitialiser le nom si non sauvegardé
      }
    },
    deleteOrganisation() {
      if (confirm("Are you sure you want to delete this organisation?")) {
        this.$emit("delete-organisation", this.organisation.id);
      }
    },
    viewUsers() {
      this.$emit("view-users", this.organisation.id);
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
        this.selectedGroup = { ...group, ...response.data.data };
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
      if (!this.selectedGroup) return;
      try {
        await axios.delete(
          `http://localhost:4000/api/groups/${this.selectedGroup.id}`,
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.closeGroupModal();
        this.fetchGroups();
      } catch (error) {
        console.error("Erreur lors de la suppression du groupe :", error);
      }
    },
  },
};
</script>

<style scoped>
.organisation-card {
  width: 300px;
  height: 400px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}
.glassmorphism-bg-white {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  color: white;
}
.groups-container {
  overflow-y: auto;
  max-height: 175px;
}
.btn {
  padding: 0.5em 1em;
  border-radius: 5px;
}
.btn-primary {
  background-color: #fdcb12;
  color: black;
}
.btn-secondary {
  background-color: #6c757d;
  color: white;
}
.organisation-card {
  width: 320px; /* Agrandir un peu la carte */
  height: 400px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

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

.header h2 {
  color: #fdcb12;
}

/* Bouton d'édition avec icône */
.btn-edit {
  background: none;
  border: none;
  cursor: pointer;
  color: #fdcb12;
  margin-left: 10px; /* Espace entre le nom et l'icône */
}

.btn-edit:hover {
  color: #f5b900;
}

.btn-delete {
  background: none;
  border: none;
  cursor: pointer;
  color: #fd2d12;
  margin-left: 10px;
}

/* Bouton de coche pour sauvegarder */
.btn-save {
  background: none;
  border: none;
  cursor: pointer;
  color: #00ff00;
}

.btn-save:hover {
  color: #00cc00;
}

/* Champ d'édition plus petit et adapté à la carte */
.input-field {
  background-color: rgba(255, 255, 255, 0.1);
  border: 1px solid #fdcb12;
  color: #fdcb12;
  padding: 0.2em;
  border-radius: 4px;
  outline: none;
  width: 180px; /* Agrandir légèrement */
}

/* Liste des groupes avec une scrollbar stylisée */
.groups-container {
  overflow-y: auto;
  max-height: 175px;
  flex-grow: 1;
  margin-bottom: 10px;
}

.groups-container::-webkit-scrollbar {
  width: 6px;
}

.groups-container::-webkit-scrollbar-thumb {
  background-color: #000;
  border-radius: 10px;
}

.groups-container::-webkit-scrollbar-track {
  background: transparent;
}

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
</style>
