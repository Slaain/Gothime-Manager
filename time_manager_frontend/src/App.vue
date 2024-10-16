<template>
  <div class="dashboard">
    <!-- Sidebar -->
    <aside class="sidebar bg-gray-900 text-white">
      <div class="logo flex items-center justify-center py-6">
        <img src="./assets/avatar.png" alt="Vue Logo" class="w-12 h-12" />
      </div>
      <nav class="nav flex flex-col space-y-4 text-center">
        <button @click="showDashboard" class="p-2 rounded-md bg-green-600 hover:bg-green-700">Dashboard</button>
        <button class="p-2 rounded-md bg-gray-700 hover:bg-gray-800">Charts</button>
        <button class="p-2 rounded-md bg-gray-700 hover:bg-gray-800">Users</button>
        <button @click="toggleGroupView" class="p-2 rounded-md bg-gray-700 hover:bg-gray-800">Groupe</button>
        <button class="p-2 rounded-md bg-gray-700 hover:bg-gray-800">Settings</button>
      </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content flex-1 bg-gray-800 p-6">
      <!-- Header -->
      <header class="flex justify-between items-center mb-6">
        <h1 class="text-3xl font-bold text-white">Dashboard</h1>
        <div class="user-info text-white flex items-center space-x-4">
          <span>ADMIN</span>
          <img src="./assets/avatar.png" alt="User Avatar" class="w-10 h-10 rounded-full" />
        </div>
      </header>

      <!-- LineChart Section -->
      <section class="line-chart bg-gray-700 p-6 rounded-lg shadow-lg mb-6" v-if="!showGroupComponent">
        <h2 class="text-xl text-white mb-4">Working Hours Line Chart</h2>
        <LineChart />
      </section>

      <!-- Groupe Component Section -->
      <section v-if="showGroupComponent" class="group-section bg-gray-700 p-6 rounded-lg shadow-lg mb-6">
        <h2 class="text-xl text-white mb-4">Manage Groups</h2>
        <CreaGroupComponent />
      </section>

      <!-- Charts Section -->
      <section class="charts grid grid-cols-3 gap-6 mb-6" v-if="!showGroupComponent">
        <div class="chart bg-gray-700 p-4 rounded-lg shadow-lg">
          <h2 class="text-xl text-white mb-4">Performance</h2>
          <div class="h-40">
            <apexchart :options="chartOptions" :series="series"></apexchart>
          </div>
        </div>

        <div class="chart bg-gray-700 p-4 rounded-lg shadow-lg">
          <h2 class="text-xl text-white mb-4">Monthly Stats</h2>
          <div class="h-40">
            <apexchart :options="chartOptions" :series="series"></apexchart>
          </div>
        </div>

        <div class="chart bg-gray-700 p-4 rounded-lg shadow-lg">
          <h2 class="text-xl text-white mb-4">Comparison</h2>
          <div class="h-40">
            <apexchart :options="chartOptions" :series="series"></apexchart>
          </div>
        </div>
      </section>

      <!-- Users List Section -->
      <section class="users p-0" v-if="!showGroupComponent">
        <h2 class="text-xl text-white mb-4">Users List</h2>
        <div class="overflow-x-auto">
          <UserList @updateUserId="selectUser" />
        </div>
      </section>

      <!-- Conteneur pour le Working Time (affiché sous la liste des utilisateurs) -->
      <section v-if="selectedUserId && !showGroupComponent" class="working-time-container bg-gray-700 p-6 rounded-lg shadow-lg mt-6">
        <h2 class="text-xl text-white mb-4">Working Times for User {{ selectedUserId }}</h2>
        <WorkingTimeUserContainer :userID="selectedUserId" />
      </section>
      <section  class="working-time-container bg-gray-700 p-6 rounded-lg shadow-lg mt-6">
        <h2 class="text-xl text-white mb-4">Working Times for User {{ selectedUserId }}</h2>
        <BarChart :userID="selectedUserId" />
      </section>

    </main>
  </div>
</template>
<script>
import UserList from './components/UserList.vue';
import LineChart from './components/LineChart.vue';
import WorkingTimeUserContainer from './components/WorkingTimesUsersContainer.vue';
import CreaGroupComponent from "@/components/CreaGroupComponent.vue";
import BarChart from "@/components/WorkingTimesChart.vue";

export default {
  name: "Dashboard",
  components: {
    UserList,
    LineChart,
    WorkingTimeUserContainer,
    CreaGroupComponent,
    BarChart, // Enregistrement du BarChart
  },
  data() {
    return {
      chartOptions: {
        chart: {
          id: 'basic-bar',
        },
        xaxis: {
          categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
        },
      },
      series: [{
        name: "series-1",
        data: [30, 40, 35, 50, 49, 60, 70, 91, 125],
      }],
      selectedUserId: null,
      showGroupComponent: false, // Variable pour contrôler l'affichage du composant CreaGroupComponent
    };
  },
  methods: {
    showDashboard() {
      this.showGroupComponent = false;
    },
    toggleGroupView() {
      this.showGroupComponent = !this.showGroupComponent;
    },
    selectUser(userId) {
      console.log(userId);
      this.selectedUserId = userId;
    },
  },
};
</script>


<style scoped>
.dashboard {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  width: 200px;
  background-color: #2D3748;
  padding: 20px;
}

.main-content {
  flex: 1;
  background-color: #1A202C;
  padding: 20px;
}

.chart {
  background-color: #2D3748;
  padding: 20px;
  border-radius: 10px;
}

.line-chart {
  background-color: #2D3748;
  padding: 20px;
  border-radius: 10px;
  width: 100%;
}

.working-time-container {
  background-color: #2D3748;
  padding: 20px;
  border-radius: 10px;
}
</style>
