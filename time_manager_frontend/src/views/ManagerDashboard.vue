<template>
  <div class="organisation-page flex min-h-screen bg-custom-background">
    <Sidebar />
    <div class="content flex-1 p-6">
      <h1 class="text-3xl font-bold mb-6 text-yellow-400">Organisation: {{ organisation?.name }}</h1>
      
      <!-- Vérifier si l'organisation existe avant de l'afficher -->
      <div v-if="organisation">
        <div class="organisation-card">
          <h2>{{ organisation.name }}</h2>
          <p>{{ organisation.description }}</p>
          
          <!-- Afficher des informations supplémentaires comme les groupes ou les utilisateurs -->
          <div class="groups-container overflow-y-auto mb-4">
            <h3 class="font-medium text-white">List Groups:</h3>
            <ul>
              <li v-for="group in groups" :key="group.id" class="flex justify-between items-center mb-2 text-white">
                {{ group.groupname }}
                <button @click="viewGroup(group)" class="btn btn-secondary ml-4">Voir</button>
              </li>
            </ul>
          </div>
          <button @click="viewUsers" class="btn btn-secondary mt-2">Voir Les employés</button>
          <!-- Ajouter des boutons pour afficher/modifier l'organisation -->
    <button @click="handleModifyOrganisation(organisation.id)" class="btn">Modifier</button>
        </div>
      </div>

      <!-- Message si l'organisation n'existe pas -->
      <div v-else>
        <p>Aucune organisation trouvée.</p>
      </div>
    </div>
    
    <UserModal
      v-if="showUserModal"
      :organisation-id="selectedOrganisationId"
      @close-modal="handleCloseUserModal"
    />
   
  </div>
</template>

<script>
import Sidebar from '../components/Sidebar.vue';
import UserModal from '../components/OrganisationUserList.vue'; // Import de la modale UserModal
import OrganisationList from '../components/OrganisationList.vue';
import axios from 'axios';

export default {
  components: {
    Sidebar,
    OrganisationList,
    UserModal,
  },
  props: {
    organisationId: {
      type: String,
      required: true,
    }
  },
  data() {
    return {
      organisation: null,
      showUserModal: false,
      groups: [],
    };
  },
  methods: {
    // Récupérer l'organisation spécifique en fonction de l'ID passé en paramètre
    async fetchOrganisation() {
      try {
        const response = await axios.get(`http://localhost:4000/api/organisations/${this.organisationId}`);
        this.organisation = response.data.data; // Mettre à jour avec les données de l'organisation
        this.groups = response.data.data.groups;

      } catch (error) {
        console.error("Erreur lors de la récupération de l'organisation:", error);
      }
    },
    async fetchUsers(organisationId) {
      try {
        const response = await axios.get(`http://localhost:4000/api/organisations/${organisationId}/users`);
        // Traiter les données des utilisateurs ici, par exemple, en les stockant dans une propriété de données
      } catch (error) {
        console.error("Erreur lors de la récupération des utilisateurs :", error);
      }
    },
    
    handleModifyOrganisation(organisationId) {
      console.log("Modifier l'organisation :", organisationId);
      // Ajoutez votre logique de modification ici
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
     // Fermeture de la modale des utilisateurs
     handleCloseUserModal() {
      this.showUserModal = false;
    },
    viewGroup(group) {
      this.$emit("view-group", group.id);
    },
    viewUsers() {
      console.log("Voir Users pour l'organisation :", this.organisation.id);
      this.handleViewUsers(this.organisation.id); // Émettre l'événement pour ouvrir la modale
    },

  },
  

  mounted() {
    this.fetchOrganisation(); // Récupérer l'organisation au montage du composant
  }
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
  justify-content: center;
  align-items: center;
  width: 100%;
  padding: 40px;
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
  width: 450px;  /* Largeur fixe */
  height: 400px; /* Hauteur fixe */
  display: flex;
  flex-direction: column;
  justify-content: space-between;
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

