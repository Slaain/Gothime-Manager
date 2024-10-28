<template>
    <aside class="text-white bg-gray-900 sidebar">
      <div class="flex items-center justify-center py-6 logo">
        <img src="./assets/avatar.png" alt="Vue Logo" class="w-12 h-12" />
      </div>
      <nav class="flex flex-col space-y-4 text-center nav">
        <router-link to="/" class="p-2 bg-yellow-500 rounded-md hover:bg-yellow-700">
         Accueil
        </router-link>
        <router-link to="/settings" class="p-2 bg-gray-700 rounded-md hover:bg-gray-800">
          Settings
        </router-link>

        <div class="mb-6 create-organisation-modal">
        <button
          @click="showCreateOrganisationModal = true"
          class="btn btn-create-organisation">
          Create Organisation
        </button>
         <!-- Modale pour créer une nouvelle organisation -->
         <CreateOrganisationModal
                v-if="showCreateOrganisationModal"
                @close-modal="handleCloseCreateModal"
                @organisation-created="fetchOrganisation"
              />
        </div>
        
      </nav>

     
    </aside>
    


  </template>
  
  <script>
import CreateOrganisationModal from "../components/CreateOrganisationModal.vue";

  export default {
    name: 'SidebarManager',

    components: {
    CreateOrganisationModal,
  },
  data() {
    return {
      showCreateOrganisationModal: false,
    };
  },
  methods:{
    handleCloseCreateModal() {
      this.showCreateOrganisationModal = false;
    },

    async fetchOrganisation() {
      try {
        const response = await axios.get(
          `http://localhost:4000/api/organisations/${this.organisationId}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.organisation = response.data.data;
        this.groups = response.data.data.groups;

      } catch (error) {
        console.error("Erreur lors de la récupération de l'organisation:", error);
      }
    },
  },
  mounted() {
    this.fetchOrganisation();
  },

  };

  </script>
  
  <style scoped>
  /* Ajoute ici les styles de la sidebar si nécessaire */
  .sidebar {
    width: 200px;
    background-color: #212327;
    padding: 20px;
  }
  .nav {
    display: flex;
    flex-direction: column;
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
.btn-edit:hover {
  color: #f5b900;
}

 .btn {
  padding: 0.5em 1em;
  background-color: #fdcb12;
  border-radius: 5px;
  transition: background-color 0.3s;
  color: black;
}
  </style>
  