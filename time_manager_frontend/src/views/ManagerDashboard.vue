<template>
  <div class="organisation-page flex min-h-screen bg-custom-background"> 
    <Sidebar />
    <div class="content flex-1 p-6">
      <h1 class="text-3xl font-bold mb-6 text-yellow-400"> {{ organisation?.name }}</h1>
        <div v-if="organisation">
          <div class="organisation-card">
            <h2>{{ organisation.name }}</h2>
            <p>{{ organisation.description }}</p>

            <div class="groups-container overflow-y-auto mb-4">
              <h3 class="font-medium text-white">List Groups:</h3>
              <ul>
                <li v-for="group in groups" :key="group.id" class="flex justify-between items-center mb-2 text-white">
                  {{ group.groupname }}
                  <button @click="viewGroup(group)" class="btn btn-secondary ml-4">Voir</button>
                </li>
              </ul>
            </div> <!--div groups-container-->
            <button @click="viewUsers" class="btn btn-secondary mt-2">Voir Les employés</button>
            <!-- Ajouter des boutons pour afficher/modifier l'organisation -->
            <button @click="handleModifyOrganisation(organisation.id)" class="btn">Modifier</button>
          </div><!--div oraganisation-card-->
        </div><!--div oraganisation-->
        <div v-else>
          <p>Aucune organisation trouvée.</p>
        </div>
    </div><!--div content-->
    
    <UserModal
      v-if="showUserModal"
      :organisation-id="selectedOrganisationId"
      @close-modal="handleCloseUserModal"
    />

        <!-- Main Content -->
        <main class="flex-1 p-6 main-content">
          <header class="flex items-center justify-between mb-6">
            <h1 class="text-3xl font-bold text-white">Dashboard : {{ organisation?.name }}</h1>
            <div class="flex items-center space-x-4 text-white user-info">
              <span>Manager</span>
              <img
                src="../assets/avatar.jpg"
                alt="User Avatar"
                class="w-10 h-10 rounded-full"
              />
            </div>
          </header>

          <section class="p-6 mb-6 rounded-lg shadow-lg glassmorphism line-chart">
            <h2 class="mb-4 text-xl text-white">Working Hours Line Chart</h2>
            <LineChart />
          </section>

          <section class="grid grid-cols-3 gap-6 mb-6 charts">
            <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
              <h2 class="mb-4 text-xl text-white">Users Worked This Month</h2>
              <div class="h-40 flex items-center justify-center working-times-number">
                {{ monthlyUsers }}
              </div>
            </div>
            
            <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
              <h2 class="mb-4 text-xl text-white">Users Currently Working</h2>
              <div class="h-40 flex items-center justify-center working-times-number">
                {{ currentUsers }}
              </div>
            </div>
  
  
            <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
              <h2 class="mb-4 text-xl text-white">Working Times This Month</h2>
              <div class="h-40 flex items-center justify-center working-times-number">
                {{ workingTimesThisMonth }}
              </div>
            </div>
          </section>
        </main>
 </div> 

</template>

<script>
import Sidebar from '../components/Sidebar.vue';
import UserModal from '../components/OrganisationUserList.vue'; // Import de la modale UserModal
import OrganisationList from '../components/OrganisationList.vue';
import UserList from '../components/UserList.vue';
import LineChart from '../components/LineChart.vue';
import WorkingTimeUserContainer from '../components/WorkingTimesUsersContainer.vue';
import BarChart from "@/components/WorkingTimesChart.vue";
import axios from 'axios';

export default {
  components: {
    Sidebar,
    OrganisationList,
    UserModal,
    UserList,
    LineChart,
    WorkingTimeUserContainer,
    BarChart,
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
      currentUsers: 0,
      workingTimesThisMonth: 0,
      monthlyUsers : 0,
      chartOptions: {
          chart: {
            id: "basic-bar",
          },
          xaxis: {
            categories: [
              "Jan",
              "Feb",
              "Mar",
              "Apr",
              "May",
              "Jun",
              "Jul",
              "Aug",
              "Sep",
              "Oct",
              "Nov",
              "Dec",
            ],
          },
        },
        series: [{
          name: "series-1",
          data: [30, 40, 35, 50, 49, 60, 70, 91, 125],
        }],
        selectedUserId: null,
        showGroupComponent: false,
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

    async getWorkingTimesThisMonth() {
        try {
          const response = await axios.get('http://localhost:4000/api/workingtimes/count');
          this.monthlyUsers = response.data.users_count; // Assigner le nombre retourné par l'API
          this.workingTimesThisMonth = response.data.working_times_count
        } catch (error) {
          console.error("Erreur lors de la récupération des working times", error);
        }
      },
      async getCurrentUsers() {
        try {
          const response = await axios.get('http://localhost:4000/api/clocks/countactive');
          console.log(response);
          this.currentUsers = response.data.count;
        } catch (error){
          console.error("Erreur lors de la récupération des utilisateurs actifs", error);
        }
      },
      // Méthode pour mettre à jour l'ID de l'utilisateur sélectionné
      selectUser(userId) {
        this.selectedUserId = userId;
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
    showDashboard() {
        this.showGroupComponent = false;
      },
      toggleGroupView() {
        this.showGroupComponent = !this.showGroupComponent;
      },

  },
  

  mounted() {
    this.fetchOrganisation(); // Récupérer l'organisation au montage du composant
    this.getCurrentUsers();
    this.getWorkingTimesThisMonth(); 
  }
};
</script>

<style scoped>
 
/* .bat-container {
    background: #333333;
    background-image: url("../assets/images/bat.png");
    background-repeat: repeat;
    background-size: 100px 100px;
    background-position: 0 0;
  } */

  /* .bat-container::after {
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
  } */

   .chart {
     background-color: #2d3748; 
    padding: 20px;
    border-radius: 10px;
  } 

  .chart:hover .working-times-number {
    color: #fdcb12; /* Le texte devient entièrement jaune */
    -webkit-text-stroke: 0px; /* Retire le contour au hover */
    text-shadow: 0 0 10px rgba(253, 203, 18, 0.8), /* Ombre jaune */
                 0 0 20px rgba(253, 203, 18, 0.6); /* Ombre plus lointaine */
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

.dashboard {
    display: flex;
    min-height: 100vh;
    position: relative;
    background-image: url("../assets/images/noise.png"); 
    z-index: 2; 
  } 
  
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

.glassmorphism {
    position: relative;
    background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
    backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
    -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
    border-radius: 10px; /* Arrondi des angles */
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
    color: white;
    overflow: hidden; /* Pour assurer que le pseudo-élément reste dans les limites du conteneur */
  }
  
.glassmorphism::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 2px; /* Épaisseur de la bordure */
  border-radius: 10px; /* Même bordure arrondie */
  background: linear-gradient(
    to bottom right,
    #ffffff,
    rgba(255, 255, 255, 0.5),
    #fdcb12
  ); /* Dégradé de la bordure */
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none; /* Empêche les événements de la souris sur le pseudo-élément */
}
  
.glassmorphism h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85); /* Couleur blanche avec transparence */
}
  
.glassmorphism .line-chart {
  padding: 1rem;
  border-radius: 8px;
}
  
.glassmorphism-bg-white {
  position: relative;
  background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px; /* Arrondi des angles */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
  color: white;
  overflow: hidden; /* Pour assurer que le pseudo-élément reste dans les limites du conteneur */
}

.glassmorphism-bg-white::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    padding: 2px; /* Épaisseur de la bordure */
    border-radius: 10px; /* Même bordure arrondie */
    background: linear-gradient(
      to bottom right,
      #ffffff,
      rgba(255, 255, 255, 0.8),
      #ffffff
    ); /* Dégradé entièrement blanc */
    -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    -webkit-mask-composite: destination-out;
    mask-composite: exclude;
    pointer-events: none; /* Empêche les événements de la souris sur le pseudo-élément */
  }
  
  .glassmorphism-bg-white h2 {
    font-weight: bold;
    color: rgba(255, 255, 255, 0.85); /* Couleur blanche avec transparence */
  }
  
  .glassmorphism-bg-white .line-chart {
    padding: 1rem;
    border-radius: 8px;
  }


h1 {
  color: #fdcb12;
}
.line-chart {
    /* background-color: #2d3748; */
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

  
  .sidebar {
    width: 200px;
    background-color: #212327;
    padding: 20px;
  }

   
 
 
  
  .working-time-container {
    /* background-color: #2d3748; */
    padding: 20px;
    border-radius: 10px;
  }
  .working-times-number {
    font-size: 6rem;
    color: transparent; /* Texte transparent */
    -webkit-text-stroke: 2px #fdcb12; /* Contour jaune */
    border-radius: 10px;
    transition: all 0.3s ease; /* Transition pour l'effet smooth */
  }
   
  
</style>

