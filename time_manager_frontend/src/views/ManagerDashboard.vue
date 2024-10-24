<template>
  <div class="bat-container">
    <div class="dashboard">
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

        <div v-if="organisation" class="organisation-card">
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
          <button @click="handleModifyOrganisation(organisation.id)" class="btn">Modifier</button>
        </div><!--div oraganisation-card-->
        <!-- Main Content -->
    
        <section class="p-6 mb-6 rounded-lg shadow-lg glassmorphism line-chart">
          <h2 class="mb-4 text-xl text-white">Working Hours Line Chart</h2>
          <LineChart />
        </section>

        <section class="grid grid-cols-3 gap-6 mb-6 charts">
          <div v-for="chart in chartsData" :key="chart.id" class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">{{ chart.title }}</h2>
            <div class="h-40 flex items-center justify-center working-times-number">
              {{ chart.value }}
            </div>
          </div>
        </section>
      </main>
    </div><!--div dashboard-->
    
    <UserModal
      v-if="showUserModal"
      :organisation-id="selectedOrganisationId"
      @close-modal="handleCloseUserModal"
    />
  </div><!--div bat-container-->
</template>

<script>
import axios from 'axios';
import LineChart from '../components/LineChart.vue';
import UserModal from '../components/OrganisationUserList.vue'; // Import de la modale UserModal

export default {
  components: {
    LineChart,
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
      chartsData: [
        { id: 1, title: 'Users Worked This Month', value: 0 },
        { id: 2, title: 'Users Currently Working', value: 0 },
        { id: 3, title: 'Working Times This Month', value: 0 },
      ],
      selectedOrganisationId: null,
    };
  },
  methods: {
    async fetchOrganisation() {
      try {
        const response = await axios.get(`http://localhost:4000/api/organisations/${this.organisationId}`);
        this.organisation = response.data.data;
        this.groups = response.data.data.groups;
      } catch (error) {
        console.error("Erreur lors de la récupération de l'organisation:", error);
      }
    },
    async fetchChartData() {
      try {
        const [usersResponse, timesResponse] = await Promise.all([
          axios.get('http://localhost:4000/api/clocks/countactive'),
           axios.get('http://localhost:4000/api/workingtimes/count'),
        ]);
  
        this.chartsData[0].value = timesResponse.data.users_count;
        this.chartsData[1].value = usersResponse.data.count;
        this.chartsData[2].value = timesResponse.data.working_times_count;
      } catch (error) {
        console.error("Erreur lors de la récupération des données", error);
      }
    },
    viewGroup(group) {
      this.$emit("view-group", group.id);
    },
    viewUsers() {
      this.selectedOrganisationId = this.organisation.id;
      this.showUserModal = true;
    },
    handleModifyOrganisation(organisationId) {
      console.log("Modifier l'organisation :", organisationId);
    },
    handleCloseUserModal() {
      this.showUserModal = false;
    },
  },
  mounted() {
    this.fetchOrganisation();
    this.fetchChartData();
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

  .chart {
    background-color: #2d3748; 
    padding: 20px;
    border-radius: 10px;
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
    background: linear-gradient(
      to bottom right,
      #ffffff,
      rgba(255, 255, 255, 0.5),
      #fdcb12
    );
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
    background: linear-gradient(
      to bottom right,
      #ffffff,
      rgba(255, 255, 255, 0.8),
      #ffffff
    );
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
  
  .working-times-number {
    font-size: 6rem;
    color: transparent;
    -webkit-text-stroke: 2px #fdcb12;
    border-radius: 10px;
    transition: all 0.3s ease;
  }
</style>

