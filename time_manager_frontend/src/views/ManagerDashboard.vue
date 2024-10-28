<template>
  <div class="bat-container">
    <div class="dashboard">
      <SidebarManager />
      <main class="flex-1 p-6 main-content">
        <header class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-white">Dashboard : {{ organisation?.name }}</h1>
          <div class="flex items-center space-x-4 text-white user-info">
            <span>Manager</span>
            <img src="../assets/avatar.jpg" 
              alt="User Avatar" 
              class="w-10 h-10 rounded-full"
              @click="toggleDropdown" />

            <div v-if="isDropdownOpen" ref="dropdown"
              class="absolute right-0 z-20 w-48 mt-2 bg-white rounded-md shadow-lg top-10">
              <ul class="py-1 text-gray-700">
                <li>
                  <button @click="logout"
                    class="block w-full px-4 py-2 text-sm text-left hover:bg-gray-100 hover:text-gray-900">
                    Se déconnecter
                  </button>
                </li>
              </ul>
            </div>
          </div>
        </header>

          <div class="container ">
          <div v-if="organisation" class="organisation-card p-6 mb-6 rounded-lg shadow-lg glassmorphism">
            <h2 v-if="!isEditing" class="text-xl font-semibold text-white">
              {{ organisation.name }}
            </h2>
            <p>{{ organisation.description }}</p>

            <div v-if="isEditing" class="flex items-center">
              <input v-model="organisationName" @keyup.enter="saveOrganisationName" @blur="toggleEdit"
                class="text-xl font-semibold input-field" type="text" />
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
              <button @click="deleteOrganisation" class="btn-delete" v-if="!isEditing">
                <i class="fas fa-trash"></i>
              </button>
            </div>
            <!-- Bouton "Add Group" au centre -->
            <div class="flex justify-center mb-4">
              <button @click="openCreateGroupModal" class="btn btn-primary">
                Add Group
              </button>
            </div>

            <div class="mb-4 overflow-y-auto groups-container">
              <h3 class="font-medium text-white">List Groups:</h3>
              <ul>
                <li v-for="group in groups" :key="group.id" class="flex justify-between items-center mb-2 text-white">
                  {{ group.groupname }}

                  <button @click="viewGroup(group)" class="ml-4 btn btn-secondary">
                    Voir
                  </button>
                </li>
              </ul>
            </div>

            <!-- Modale pour afficher les utilisateurs -->
            <div v-if="showGroupModal"
              class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70">
              <div
                class="relative w-full max-w-3xl p-10 rounded-lg shadow-lg modal-content glassmorphism-bg-white pt-9">
                <button @click="closeGroupModal"
                  class="absolute px-3 py-1 font-bold text-black bg-yellow-400 rounded close-button top-2 right-2">
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
                  <li v-for="time in selectedGroupWorkingTimes" :key="time.id" class="flex justify-between mb-2">
                    <span class="text-white">Start: {{ formatDate(time.start) }} - End:
                      {{ formatDate(time.end) }}</span>
                  </li>
                </ul>
                <!-- Liste des utilisateurs -->
                <h4 class="mb-2 text-lg font-bold text-white">Users in this Group</h4>
                <ul>
                  <li v-for="user in selectedGroupUsers" :key="user.id" class="flex justify-between mb-2">
                    <span class="text-white">{{ user.username }} ({{ user.email }})</span>
                    <button @click="removeUserFromGroup(user.id)" class="text-red-600 hover:underline">
                      Remove
                    </button>
                  </li>
                </ul>
                <!-- Boutons pour ajouter un utilisateur ou supprimer le groupe -->
                <div class="flex justify-between mt-4">
                  <button @click="openUserModal" class="px-4 py-2 text-white bg-blue-500 rounded hover:bg-blue-600">
                    Add User
                  </button>
                  <button @click="deleteGroup" class="px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600">
                    Delete Group
                  </button>
                </div>
              </div>
            </div>

            <!-- Modale pour créer un groupe avec CreaGroupComponent -->
            <div v-if="showCreateGroupModal"
              class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-70">
              <div
                class="relative w-full max-w-3xl p-10 rounded-lg shadow-lg modal-content glassmorphism-bg-white pt-9">
                <button @click="closeCreateGroupModal"
                  class="absolute px-3 py-1 font-bold text-black bg-yellow-400 rounded close-button top-2 right-2">
                  X
                </button>
                <CreaGroupComponent @group-created="handleGroupCreated" @close="closeCreateGroupModal" />
              </div>
            </div>

            <!-- Modale d'ajout d'utilisateur -->
            <div v-if="showUserModal"
              class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
              <div class="w-1/2 px-8 py-4 rounded-lg shadow-md modal-content glassmorphism-bg-white">
                <h3 class="mb-4 text-lg font-semibold text-yellow-400">
                  Add User to Group
                </h3>
                <select v-model="selectedUser" class="w-full p-2 mb-4 text-white border rounded">
                  <option class="text-black" v-for="user in allUsers" :key="user.id" :value="user.id">
                    {{ user.username }} ({{ user.email }})
                  </option>
                </select>
                <div class="flex justify-end gap-4 mt-4">
                  <button @click="addUserToGroup" class="px-4 py-2 text-white bg-green-500 rounded hover:bg-green-600">
                    Add
                  </button>
                  <button @click="closeUserModal" class="px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600">
                    Cancel
                  </button>
                </div>
              </div>
            </div>

            <button @click="viewUsers" class="mt-2 btn btn-secondary">
              Voir les employés
            </button>

          </div>
        </div>

        
        <section class="p-6 mb-6 rounded-lg shadow-lg glassmorphism line-chart">
          <h2 class="mb-4 text-xl text-white">Working Hours Line Chart</h2>
          <LineChartManager :organisationId="organisationId" />
        </section>

        <section class="grid grid-cols-3 gap-6 mb-6 charts">
          <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">Users Worked This Month</h2>
            <div class="flex items-center justify-center h-40 working-times-number">
              {{ monthlyUsers }}
            </div>
          </div>

          <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">Users Currently Working</h2>
            <div class="flex items-center justify-center h-40 working-times-number">
              {{ currentUsers }}
            </div>
          </div>

          <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">Working Times This Month</h2>
            <div class="flex items-center justify-center h-40 working-times-number">
              {{ workingTimesThisMonth }}
            </div>
          </div>
        </section>

        <section id="employeeList" class="p-0 users">
          <h2 class="mb-4 text-xl text-white">Listes des employés</h2>
          <div class="overflow-x-auto">
            <UserListManager :organisationId="organisationId" @updateUserId="selectUser" />
          </div>
        </section>

        <section v-if="selectedUserId" class="w-full mt-6">
          <WorkingTimeUserContainer :userID="selectedUserId" />
        </section>
      </main>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import LineChartManager from '../components/LineChartManager.vue';
import UserModal from '../components/OrganisationUserList.vue';
import SidebarManager from "../components/SidebarManager.vue";
import UserListManager from '../components/UserListManager.vue';
import WorkingTimeUserContainer from '../components/WorkingTimesUsersContainer.vue';
import CreaGroupComponent from "@/components/CreaGroupComponent.vue";
import BarChart from "@/components/WorkingTimesChart.vue";
import { useToast } from "vue-toastification";

export default {
  name: "Dashboard",
  components: {
    SidebarManager,
    LineChartManager,
    BarChart,
    UserModal,
    UserListManager,
    WorkingTimeUserContainer,
    CreaGroupComponent,
  },
  props: {
    organisationId: {
      type: String,
      required: true,
    },
  },
  setup() {
    const toast = useToast(); // Utiliser le toast via setup
    return { toast };
  },
  data() {
    return {
      organisation: null,
      currentUsers: 0,
      workingTimes: [],
      workingTimesThisMonth: 0,
      showGroupComponent: false,
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
      isDropdownOpen: false,
      specifiedOrganisationId: '1',
      allEmployees: [],
      selectedUserId: null,
      organisationName: null,
      monthlyUsers: 0,

    };
  },
  methods: {
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
    selectUser(userId) {
      this.selectedUserId = userId;
      console.log("Selected user ID:", this.selectedUserId);
    },

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
        this.toast.success("Organisation name updated successfully.");
        this.$emit("organisation-updated");
        this.isEditing = false; // Fermer l'édition après la sauvegarde
      } catch (error) {
        this.toast.error("Error updating the organisation's name.");
        console.error(
          "Erreur lors de la mise à jour du nom de l'organisation:",
          error
        );
      }
    },
    toggleEdit() {
      if (!this.isEditing) {
        this.isEditing = true;
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
      const element = document.getElementById("employeeList");
      if (element) {
        element.scrollIntoView({ behavior: "smooth" });
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

    async fetchWorkingTimesByOrganisation() {
      try {
        const response = await axios.get(`http://localhost:4000/api/workingtimes/by_organisation/${this.organisationId}`);
        this.workingTimes = response.data;
        this.updateCharts();
      } catch (error) {
        console.error("Erreur lors de la récupération des working times:", error);
      }
    },

    // Récupérer et filtrer les working times en fonction de l'organisation
    async getWorkingTimesThisMonthByOrganisation() {
      try {
        const response = await axios.get(
          "http://localhost:4000/api/workingtimes/count_by_organisation/${this.organisationId}",
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.monthlyUsers = response.data.users_count;
        this.workingTimesThisMonth = response.data.working_times_count;
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des working times",
          error
        );
      }
    },

    async getCurrentUsers() {
      try {
        const response = await axios.get(
          `http://localhost:4000/api/clocks/countactive_by_organisation/${this.organisationId}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );

        this.currentUsers = response.data.count;
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs actifs",
          error
        );
      }
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

    toggleDropdown() {
      this.isDropdownOpen = !this.isDropdownOpen;
    },
    logout() {
      // Logique de déconnexion
      localStorage.removeItem("authToken"); // Supprime le token de l'utilisateur
      this.$router.push("/login"); // Redirige vers la page de connexion
    },
    handleClickOutside(event) {
      const dropdown = this.$refs.dropdown;
      if (
        dropdown &&
        !dropdown.contains(event.target) &&
        !this.$el.contains(event.target)
      ) {
        this.isDropdownOpen = false;
      }
    },
    showDashboard() {
      this.showGroupComponent = false;
    },
    toggleGroupView() {
      this.showGroupComponent = !this.showGroupComponent;
    },

  },

  mounted() {
    console.log("Dashboard mounted : ", localStorage.getItem("authToken"));
    this.fetchOrganisation();
    this.fetchWorkingTimesByOrganisation();
    this.getWorkingTimesThisMonthByOrganisation();
    this.getCurrentUsers();
    this.fetchGroups();
    this.fetchAllUsers();
    document.addEventListener("click", this.handleClickOutside);

  },
  beforeUnmount() {
    document.removeEventListener("click", this.handleClickOutside);
  },
};
</script>


<style scoped>
.bat-container {
  background: #333333;
  background-image: url("../assets/images/bat.png");
  background-repeat: repeat;
  background-size: 100px 100px;
  background-position: 0 0;
}

.bat-container::after {
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



/* Bouton d'édition avec icône */
.btn-edit {
  background: none;
  border: none;
  cursor: pointer;
  color: #fdcb12;
  margin-left: 10px;
  /* Espace entre le nom et l'icône */
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

.chart {
  background-color: #2d3748;
  padding: 20px;
  border-radius: 10px;
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

.chart:hover .working-times-number {
  color: #fdcb12;
  -webkit-text-stroke: 0px;
  text-shadow: 0 0 10px rgba(253, 203, 18, 0.8),
    0 0 20px rgba(253, 203, 18, 0.6);
}

.dashboard {
  display: flex;
  min-height: 100vh;
  position: relative;
  background-image: url("../assets/images/noise.png");
  z-index: 2;
}

.groups-container {
  max-height: 200px;
  overflow-y: auto;
  padding-right: 10px;
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
.groups-container::-webkit-scrollbar {
  width: 12px; /* Définit la largeur de la barre de défilement */
}
.groups-container::-webkit-scrollbar-track {
  background: rgba(255, 255, 255, 0.1); /* Couleur de fond de la piste */
}

.groups-container::-webkit-scrollbar-thumb {
  background-color: #fdcb12; /* Couleur de la barre de défilement */
  border-radius: 10px;
  border: 3px solid rgba(0, 0, 0, 0.1); /* Bordure pour une séparation nette */
}

.glassmorphism {
  position: relative;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  color: white;
  overflow: hidden;
}

.glassmorphism::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 2px;
  border-radius: 10px;
  background: linear-gradient(to bottom right,
      #ffffff,
      rgba(255, 255, 255, 0.5),
      #fdcb12);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none;
}

.glassmorphism h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85);
}

.glassmorphism .line-chart {
  padding: 1rem;
  border-radius: 8px;
}

.glassmorphism-bg-white {
  position: relative;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  color: white;
  overflow: hidden;
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
  background: linear-gradient(to bottom right,
      #ffffff,
      rgba(255, 255, 255, 0.8),
      #ffffff);
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none;
}

.glassmorphism-bg-white h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85);
}

.glassmorphism-bg-white .line-chart {
  padding: 1rem;
  border-radius: 8px;
}

h1 {
  color: #fdcb12;
}

/* Champ d'édition plus petit et adapté à la carte */
.input-field {
  background-color: rgba(255, 255, 255, 0.1);
  border: 1px solid #fdcb12;
  color: #fdcb12;
  padding: 0.2em;
  border-radius: 4px;
  outline: none;
  width: 180px;
  /* Agrandir légèrement */
}


.line-chart {
  padding: 20px;
  border-radius: 10px;
  width: 100%;
  color: white;
}

.main-content {
  flex: 1;
  background-color: rgba(0, 0, 0, 0.8);
  padding: 20px;
}

.container {
  display: flex;
  justify-content: center;
  align-items: center;
 height: 80vh;
}

.organisation-card {
  background: rgba(255, 255, 255, 0.1); 
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  padding: 30px; 
  border-radius: 15px; 
  box-shadow: 0 4px 40px rgba(0, 0, 0, 0.2);
  color: white;
  width: 80%; 
  max-width: 900px; 
  text-align: center;
}

.organisation-card p {
  margin: 10px 0;
}

.organisation-card h2 {
  font-size: 1.5rem;
  color: #fdcb12;
  margin-bottom: 10px;
}

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

.sidebarManager {
  width: 200px;
  background-color: #212327;
  padding: 20px;
}

.working-times-number {
  font-size: 6rem;
  color: transparent;
  -webkit-text-stroke: 2px #fdcb12;
  border-radius: 10px;
  transition: all 0.3s ease;
}

.working-time-container {
  padding: 20px;
  border-radius: 10px;
}
</style>