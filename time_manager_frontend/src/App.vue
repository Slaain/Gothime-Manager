<template>
  <div class="bat-container">
    <div class="dashboard">
      <!-- Sidebar -->
      <aside class="text-white bg-gray-900 sidebar">
        <div class="flex items-center justify-center py-6 logo">
          <img src="./assets/avatar.png" alt="Vue Logo" class="w-12 h-12" />
        </div>
        <nav class="flex flex-col space-y-4 text-center nav">
          <button class="p-2 bg-green-600 rounded-md hover:bg-green-700">
            Dashboard
          </button>
          <button class="p-2 bg-gray-700 rounded-md hover:bg-gray-800">
            Charts
          </button>
          <button class="p-2 bg-gray-700 rounded-md hover:bg-gray-800">
            Users
          </button>
          <button class="p-2 bg-gray-700 rounded-md hover:bg-gray-800">
            Settings
          </button>
        </nav>
      </aside>

      <!-- Main Content -->
      <main class="flex-1 p-6 main-content">
        <header class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-white">Dashboard</h1>
          <div class="flex items-center space-x-4 text-white user-info">
            <span>ADMIN</span>
            <img
              src="./assets/avatar.png"
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
            <div class="h-40">
              <apexchart :options="chartOptions" :series="series"></apexchart>
            </div>
          </div>

          <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">Users Currently Working</h2>
            <div class="h-40">
              <apexchart :options="chartOptions" :series="series"></apexchart>
            </div>
          </div>

          <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">Working Times This Month</h2>
            <div class="h-40 flex items-center justify-center working-times-number">
              {{ workingTimesThisMonth }}
            </div>
          </div>
        </section>

        <section class="p-0 users">
          <h2 class="mb-4 text-xl text-white">Users List</h2>
          <div class="overflow-x-auto">
            <UserList @updateUserId="selectUser" />
          </div>
        </section>

        <section
          v-if="selectedUserId"
          class="p-6 mt-6 bg-gray-700 rounded-lg shadow-lg working-time-container"
        >
          <h2 class="mb-4 text-xl text-white">
            Working Times for User {{ selectedUserId }}
          </h2>
          <WorkingTimeUserContainer :userID="selectedUserId" />
        </section>
      </main>
    </div>
  </div>
</template>

<script>
import axios from 'axios';
import UserList from "./components/UserList.vue"; // Import de ton composant personnalisé
import LineChart from "./components/LineChart.vue"; // Import du nouveau composant LineChart
import WorkingTimeUserContainer from "./components/WorkingTimesUsersContainer.vue"; // Assurez-vous d'importer ce composant

export default {
  name: "Dashboard",
  components: {
    UserList, // Enregistrement du composant
    LineChart, // Enregistrement du LineChart
    WorkingTimeUserContainer,  // Enregistrement du WorkingTimeUserContainer
  },
  data() {
    return {
      workingTimesThisMonth: 0, // Initialisation avec une valeur par défaut
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
      series: [
        {
          name: "series-1",
          data: [30, 40, 35, 50, 49, 60, 70, 91, 125],
        },
      ],
      selectedUserId: null, // Variable pour stocker l'ID de l'utilisateur sélectionné
    };
  },
  mounted() {
    this.getWorkingTimesThisMonth(); // Appel de la méthode pour récupérer le count lors du montage du composant
  },
  methods: {
    async getWorkingTimesThisMonth() {
      try {
        const response = await axios.get('http://localhost:4000/api/workingtimes/count');
        this.workingTimesThisMonth = response.data.count; // Assigner le nombre retourné par l'API
      } catch (error) {
        console.error("Erreur lors de la récupération des working times", error);
      }
    },
    // Méthode pour mettre à jour l'ID de l'utilisateur sélectionné
    selectUser(userId) {
      console.log(userId);
      this.selectedUserId = userId;
    },
  },
};
</script>

<style scoped>

.working-times-number {
  font-size: 5rem;
  color: transparent; /* Texte transparent */
  -webkit-text-stroke: 2px #fdcb12; /* Contour jaune */
  border-radius: 10px;
  transition: all 0.3s ease; /* Transition pour l'effet smooth */
}

.chart:hover .working-times-number {
  color: #fdcb12; /* Le texte devient entièrement jaune */
  -webkit-text-stroke: 0px; /* Retire le contour au hover */
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

.bat-container {
  background: #333333;
  background-image: url("./assets/images/bat.png");
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
  background-image: url("./assets/images/noise.png"); /* Image PNG du bruit */
  background-repeat: repeat;
  opacity: 0.1; /* Ajuste l'opacité du bruit */
  pointer-events: none;
  z-index: 1; /* Met le bruit au-dessus des chauves-souris */
}

.dashboard {
  display: flex;
  min-height: 100vh;
  position: relative;
  background-image: url("./assets/images/noise.png"); /* Image PNG du bruit */
  z-index: 2; /* S'assurer que le contenu reste au-dessus */
}

.dashboard {
  display: flex;
  min-height: 100vh;
}
.sidebar {
  width: 200px;
  background-color: #2d3748;
  padding: 20px;
}

.main-content {
  flex: 1;
  background-color: rgba(0, 0, 0, 0.8);
  padding: 20px;
}

.chart {
  /* background-color: #2d3748; */
  padding: 20px;
  border-radius: 10px;
}

.line-chart {
  /* background-color: #2d3748; */
  padding: 20px;
  border-radius: 10px;
  width: 100%;
  color: white;
}

.working-time-container {
  /* background-color: #2d3748; */
  padding: 20px;
  border-radius: 10px;
}
</style>
