<template>
  <div class="organisation-page flex min-h-screen bg-custom-background">
    <Sidebar />
    <div class="content flex-1 p-6">
      <div class="header mb-6">
        <h1 class="text-3xl font-bold text-yellow-400">Organisations</h1>
      </div>

      <!-- Bouton pour créer une nouvelle organisation, maintenant en dessous du titre -->
      <div class="create-button-container mb-6">
        <button @click="showCreateModal = true" class="btn btn-create-organisation">
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
import Sidebar from '../components/Sidebar.vue';
import OrganisationList from '../components/OrganisationList.vue';
import UserModal from '../components/OrganisationUserList.vue'; // Import de la modale UserModal
import CreateOrganisationModal from '../components/CreateOrganisationModal.vue'; // Import de la modale

import axios from 'axios';

export default {
  components: {
    Sidebar,
    OrganisationList,
    UserModal,
    CreateOrganisationModal
  },
  data() {
    return {
      organisations: [],
      showUserModal: false, // Variable pour contrôler l'affichage de la modale des utilisateurs
      selectedOrganisationId: null, // ID de l'organisation sélectionnée pour voir les utilisateurs
      showCreateModal: false, // Variable pour contrôler l'affichage de la modale de création d'organisation

    }
  },
  methods: {
    // Récupération des organisations
    async fetchOrganisations() {
      try {
        const response = await axios.get('http://localhost:4000/api/organisations');
        this.organisations = response.data.data; // Récupère les données des organisations
      } catch (error) {
        console.error("Erreur lors de la récupération des organisations:", error);
      }
    },

    async handleDeleteOrganisation(organisationId) {
      try {
        await axios.delete(`http://localhost:4000/api/organisations/${organisationId}`);
        this.fetchOrganisations(); // Recharge la liste après la suppression
      } catch (error) {
        console.error("Erreur lors de la suppression de l'organisation:", error);
      }
    },

    // Gestion de l'affichage d'un groupe
    handleViewGroup(groupId) {
      console.log("Afficher le groupe :", groupId);
    },

    // Gestion de l'affichage des utilisateurs d'une organisation
    handleViewUsers(organisationId) {
      console.log("Voir les utilisateurs de l'organisatioooon :", organisationId);
      this.selectedOrganisationId = organisationId;
      this.showUserModal = true; // Affiche la modale pour afficher les utilisateurs
    },

    handleCloseCreateModal() {
      this.showCreateModal = false;
    },

    // Fermeture de la modale des utilisateurs
    handleCloseUserModal() {
      this.showUserModal = false;
    },
  },

  mounted() {
    this.fetchOrganisations(); // Charger les organisations au montage du composant
  }
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
