<template>
  
  <div class="flex min-h-screen organisation-page bg-custom-background">
    <Sidebar />
    <div class="flex-1 p-6 content">
      <div class="mb-6 header">
        <h1 class="text-3xl font-bold text-yellow-400">Organisations</h1>
        <div
            class="relative flex items-center space-x-4 text-white user-info"
          >
        <span>ADMIN</span>
            <img
              src="../assets/avatar.jpg"
              alt="User Avatar"
              class="w-10 h-10 rounded-full cursor-pointer"
              @click="toggleDropdown"
            />

            <!-- Dropdown Menu -->
            <div
              v-if="isDropdownOpen"
              ref="dropdown"
              class="absolute right-0 z-20 w-48 mt-2 bg-white rounded-md shadow-lg top-10"
            >
              <ul class="py-1 text-gray-700">
                <li>
                  <button
                    @click="logout"
                    class="block w-full px-4 py-2 text-sm text-left hover:bg-gray-100 hover:text-gray-900"
                  >
                    Se déconnecter
                  </button>
                </li>
              </ul>
            </div>
        </div>
      </div>

      <!-- Bouton pour créer une nouvelle organisation, maintenant en dessous du titre -->
      <div class="mb-6 create-button-container">
        <button
          @click="showCreateModal = true"
          class="btn btn-create-organisation"
        >
          Create Organisation
        </button>
      </div>
      <OrganisationList
        :organisations="organisations"
        @organisation-updated="fetchOrganisations"
        @view-group="handleViewGroup"
        @view-users="handleViewUsers"
        @delete-organisation="handleDeleteOrganisation"
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
    <!-- Modale pour afficher les utilisateurs -->
    <UserModal
      v-if="showUserModal"
      :organisation-id="selectedOrganisationId"
      @close-modal="handleCloseUserModal"
    />

    <!-- Modale pour créer une nouvelle organisation -->
    <CreateOrganisationModal
      v-if="showCreateModal"
      @close-modal="handleCloseCreateModal"
      @organisation-created="fetchOrganisations"
    />
  </div>
</template>

<script>
import Sidebar from "../components/Sidebar.vue";
import OrganisationList from "../components/OrganisationList.vue";
import UserModal from "../components/OrganisationUserList.vue"; // Import de la modale UserModal
import axios from "axios";
import CreateOrganisationModal from "../components/CreateOrganisationModal.vue"; // Import de la modale

export default {
  components: {
    Sidebar,
    OrganisationList,
    UserModal,
    CreateOrganisationModal,
  },
  data() {
    return {
      organisations: [],
      selectedGroup: null, // Stocker le groupe sélectionné
      selectedGroupUsers: [], // Stocker les utilisateurs du groupe sélectionné
      showUserModal: false, // Variable pour contrôler l'affichage de la modale des utilisateurs
      selectedOrganisationId: null, // ID de l'organisation sélectionnée pour voir les utilisateurs
      showCreateModal: false,
      isDropdownOpen: false, // Variable pour contrôler l'affichage de la modale de création d'organisation
    };
  },
  methods: {
    toggleDropdown() {
      console.log("Toggle dropdown");
      this.isDropdownOpen = !this.isDropdownOpen;
    },
    logout() {
      // Logique de déconnexion
      localStorage.removeItem("authToken"); // Supprime le token de l'utilisateur
      this.$router.push("/login"); // Redirige vers la page de connexion
    },
    async handleDeleteOrganisation(organisationId) {
      try {
        await axios.delete(
          `http://localhost:4000/api/organisations/${organisationId}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.fetchOrganisations(); // Recharge la liste après la suppression
      } catch (error) {
        console.error(
          "Erreur lors de la suppression de l'organisation:",
          error
        );
      }
    },
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

    handleCloseCreateModal() {
      this.showCreateModal = false;
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
          { user_id: userId },
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
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
          `http://localhost:4000/api/groups/${this.selectedGroup.id}/users/${userId}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
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
.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.btn-create-organisation {
  background-color: #fdcb12;
  color: black;
  padding: 10px 15px;
  border-radius: 5px;
  transition: background-color 0.3s;
}

.btn-create-organisation:hover {
  background-color: #f5b900;
}
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
