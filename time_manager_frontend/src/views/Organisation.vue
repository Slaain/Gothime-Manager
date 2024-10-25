<template>
  <div class="flex min-h-screen organisation-page bg-custom-background">
    <Sidebar />
    <div class="flex-1 p-6 content">
      <h1 class="mb-6 text-3xl font-bold text-yellow-400">Organisations</h1>
      <OrganisationList
        :organisations="organisations"
        @modify-organisation="handleModifyOrganisation"
        @view-group="handleViewGroup"
        @view-users="handleViewUsers"
      />

      <!-- Détails du groupe sélectionné -->
      <div v-if="selectedGroup" class="p-4 mt-6 bg-white rounded shadow-md">
        <h3 class="mb-4 text-2xl font-bold">Group: {{ selectedGroup.name }}</h3>
        <p class="mb-4">
          Start: {{ selectedGroup.start_date }} | End:
          {{ selectedGroup.end_date }}
        </p>

        <!-- Liste des utilisateurs -->
        <h4 class="mb-2 text-lg font-bold">Users in this Group</h4>
        <ul>
          <li
            v-for="user in selectedGroupUsers"
            :key="user.id"
            class="flex justify-between mb-2"
          >
            <span>{{ user.username }} ({{ user.email }})</span>
            <button
              @click="removeUserFromGroup(user.id)"
              class="text-red-600 hover:underline"
            >
              Remove
            </button>
          </li>
        </ul>

        <!-- Bouton pour ajouter un utilisateur -->
        <button
          @click="openUserModal"
          class="px-4 py-2 mt-4 text-white bg-blue-500 rounded hover:bg-blue-600"
        >
          Add User
        </button>
      </div>

      <!-- Modale pour afficher les utilisateurs -->
      <UserModal
        v-if="showUserModal"
        :organisation-id="selectedOrganisationId"
        @close-modal="handleCloseUserModal"
      />
    </div>
  </div>
</template>

<script>
import Sidebar from "../components/Sidebar.vue";
import OrganisationList from "../components/OrganisationList.vue";
import UserModal from "../components/OrganisationUserList.vue"; // Import de la modale UserModal
import axios from "axios";

export default {
  components: {
    Sidebar,
    OrganisationList,
    UserModal,
  },
  data() {
    return {
      organisations: [],
      selectedOrganisationId: null,
      selectedGroup: null, // Stocker le groupe sélectionné
      selectedGroupUsers: [], // Stocker les utilisateurs du groupe sélectionné
      showUserModal: false, // Variable pour contrôler l'affichage de la modale des utilisateurs
    };
  },
  methods: {
    // Récupération des organisations
    async fetchOrganisations() {
      try {
        const response = await axios.get(
          "http://localhost:4000/api/organisations",
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.organisations = response.data.data; // Récupère les données des organisations
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des organisations:",
          error
        );
      }
    },

    // Gestion de l'affichage d'un groupe
    async handleViewGroup(groupId) {
      try {
        const response = await axios.get(
          `http://localhost:4000/api/groups/${groupId}`
        );
        this.selectedGroup = response.data.group;
        this.selectedGroupUsers = this.selectedGroup.users || [];
      } catch (error) {
        console.error("Erreur lors de la récupération du groupe :", error);
      }
    },

    // Gestion de l'affichage des utilisateurs d'une organisation
    handleViewUsers(organisationId) {
      console.log(
        "Voir les utilisateurs de l'organisatioooon :",
        organisationId
      );
      this.selectedOrganisationId = organisationId;
      this.showUserModal = true; // Affiche la modale pour afficher les utilisateurs
      // Ajouter un utilisateur à un groupe
    },
    async addUserToGroup(userId) {
      try {
        await axios.post(
          `http://localhost:4000/api/groups/${this.selectedGroup.id}/users`,
          { user_id: userId }
        );
        this.handleViewGroup(this.selectedGroup.id); // Rafraîchir les utilisateurs du groupe
        this.closeUserModal();
      } catch (error) {
        console.error("Erreur lors de l'ajout de l'utilisateur :", error);
      }
    },

    // Supprimer un utilisateur d'un groupe
    async removeUserFromGroup(userId) {
      try {
        await axios.delete(
          `http://localhost:4000/api/groups/${this.selectedGroup.id}/users/${userId}`
        );
        this.handleViewGroup(this.selectedGroup.id); // Rafraîchir les utilisateurs du groupe
      } catch (error) {
        console.error(
          "Erreur lors de la suppression de l'utilisateur :",
          error
        );
      }
    },

    handleCloseUserModal() {
      this.showUserModal = false;
    },
  },

  mounted() {
    this.fetchOrganisations(); // Charger les organisations au montage du composant
  },
};
</script>

<style scoped>
/* Style du fond similaire à ton tableau de bord */
.organisation-page {
  display: flex;
  min-height: 100vh;
  background: #333333;
  background-image: url("../assets/images/bat.png");
  background-repeat: repeat;
  background-size: 100px 100px;
  background-position: 0 0;
}

.organisation-page::after {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url("../assets/images/noise.png");
  background-repeat: repeat;
  opacity: 0.1;
  pointer-events: none;
  z-index: 1;
}

.content {
  display: flex;
  flex-direction: column;
  width: 100%;
  padding: 20px;
  background: rgba(0, 0, 0, 0.8);
  z-index: 2;
}

h1 {
  color: #fdcb12;
}

/* Liste des organisations avec un effet Glassmorphism */
.organisation-list {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 20px;
}

.organisation-card {
  position: relative;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  padding: 20px;
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  color: white;
  overflow: hidden;
  transition: transform 0.3s ease-in-out;
  z-index: 2;
}

.organisation-card:hover {
  transform: translateY(-10px);
}

/* Ajout d'un effet de bordure lumineuse autour des cartes */
.organisation-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  border-radius: 10px;
  background: linear-gradient(
    to bottom right,
    rgba(255, 255, 255, 0.2),
    rgba(255, 255, 255, 0.1),
    #fdcb12
  );
  opacity: 0.4;
  z-index: 1;
  pointer-events: none;
}

.organisation-card h2 {
  font-size: 1.5rem;
  color: #fdcb12;
  margin-bottom: 10px;
}

/* Boutons */
.organisation-card .btn {
  padding: 0.5em 1em;
  background-color: #fdcb12;
  border-radius: 5px;
  transition: background-color 0.3s;
  color: black;
}

.organisation-card .btn:hover {
  background-color: #f5b900;
}

/* Liste des groupes avec scrollbar */
.groups-container {
  max-height: 150px;
  overflow-y: auto;
  margin-bottom: 10px;
}

.groups-container ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.groups-container li {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.groups-container li button {
  background-color: #6c757d;
  color: white;
  padding: 5px 10px;
  border-radius: 5px;
}

.groups-container li button:hover {
  background-color: #5a6268;
}
</style>
