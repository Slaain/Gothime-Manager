<template>
  <div class="container mx-auto flex">
    <!-- Sidebar -->
    <Sidebar />

    <!-- Contenu principal -->
    <div class="flex-1 grid grid-cols-3 gap-4 ml-6">
      <!-- Liste des organisations sous forme de cartes -->
      <div v-for="organisation in organisations" :key="organisation.id" class="organisation-card bg-white p-4 shadow rounded-lg">
        <h2 class="text-xl font-semibold mb-4">{{ organisation.name }}</h2>
        
        <!-- Liste des groupes pour chaque organisation -->
        <div class="group-list">
          <h3 class="text-lg font-semibold mb-2">Groupes:</h3>
          <ul>
            <li v-for="group in organisation.groups" :key="group.id" class="mb-2 flex justify-between items-center">
              <span>{{ group.name }}</span>
              <button
                class="text-blue-500 hover:underline"
                @click="fetchUsers(group.id)"
              >
                Voir
              </button>
            </li>
          </ul>
        </div>

        <!-- Bouton pour ajouter ou gérer des groupes -->
        <div class="flex justify-between mt-4">
          <button
            class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
            @click="openCreateGroupModal(organisation.id)"
          >
            Créer Groupe
          </button>
          <button
            class="bg-yellow-500 text-white px-4 py-2 rounded hover:bg-yellow-600"
            @click="openManageUsersModal(organisation.id)"
          >
            Gérer utilisateurs
          </button>
        </div>
      </div>

      <!-- Détails des utilisateurs dans un groupe sélectionné -->
      <div v-if="selectedGroupUsers" class="user-list bg-white p-4 shadow rounded-lg col-span-3">
        <h3 class="text-xl font-semibold mb-4">Utilisateurs du groupe sélectionné:</h3>
        <ul>
          <li v-for="user in selectedGroupUsers" :key="user.id" class="mb-2">
            {{ user.username }} ({{ user.email }})
            <button
              class="text-red-500 hover:underline ml-4"
              @click="removeUserFromGroup(user.id)"
            >
              Supprimer
            </button>
          </li>
        </ul>
      </div>
    </div>

    <!-- Modale pour créer un groupe -->
    <CreateGroupModal
      v-if="showCreateGroupModal"
      :organisation-id="selectedOrganisationId"
      @close="showCreateGroupModal = false"
    />

    <!-- Modale pour gérer les utilisateurs -->
    <ManageUsersModal
      v-if="showManageUsersModal"
      :organisation-id="selectedOrganisationId"
      @close="showManageUsersModal = false"
    />
  </div>
</template>

<script>
import Sidebar from '../components/Sidebar.vue'; // Assurez-vous que Sidebar.vue existe
import CreateGroupModal from '../components/CreaGroupComponent.vue';
import ManageUsersModal from '../components/modal/ManageUserModal.vue';
import axios from 'axios';

export default {
  components: {
    Sidebar,
    CreateGroupModal,
    ManageUsersModal
  },
  data() {
    return {
      organisations: [],
      selectedGroupUsers: null,
      selectedOrganisationId: null,
      showCreateGroupModal: false,
      showManageUsersModal: false
    };
  },
  methods: {
    // Récupérer la liste des organisations
    async fetchOrganisations() {
      try {
        const response = await axios.get('http://localhost:4000/api/organisations');
        this.organisations = response.data.data;
      } catch (error) {
        console.error("Erreur lors de la récupération des organisations:", error);
      }
    },

    // Récupérer les utilisateurs associés à un groupe sélectionné
    async fetchUsers(groupId) {
      try {
        const response = await axios.get(`http://localhost:4000/api/groups/${groupId}/users`);
        this.selectedGroupUsers = response.data.data;
      } catch (error) {
        console.error("Erreur lors de la récupération des utilisateurs:", error);
      }
    },

    // Ouvrir la modale pour créer un nouveau groupe
    openCreateGroupModal(organisationId) {
      this.selectedOrganisationId = organisationId;
      this.showCreateGroupModal = true;
    },

    // Ouvrir la modale pour gérer les utilisateurs d'une organisation
    openManageUsersModal(organisationId) {
      this.selectedOrganisationId = organisationId;
      this.showManageUsersModal = true;
    },

    // Retirer un utilisateur d'un groupe
    async removeUserFromGroup(userId) {
      try {
        await axios.delete(`http://localhost:4000/api/users/${userId}`);
        this.selectedGroupUsers = this.selectedGroupUsers.filter(user => user.id !== userId);
      } catch (error) {
        console.error("Erreur lors de la suppression de l'utilisateur:", error);
      }
    }
  },
  mounted() {
    // Charger les organisations au montage du composant
    this.fetchOrganisations();
  }
};
</script>

<style scoped>
.container {
  display: flex;
  padding: 20px;
}

.organisation-card {
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}

.user-list {
  background-color: #fff;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
}
</style>
