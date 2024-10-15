<template>
  <div class="dashboard">
    <!-- Sidebar -->
    <aside class="sidebar bg-gray-900 text-white">
      <div class="logo flex items-center justify-center py-6">
        <img src="./assets/avatar.png" alt="Vue Logo" class="w-12 h-12">
      </div>
      <nav class="nav flex flex-col space-y-4 text-center">
        <button class="p-2 rounded-md bg-green-600 hover:bg-green-700">Dashboard</button>
        <button class="p-2 rounded-md bg-gray-700 hover:bg-gray-800">Charts</button>
        <button class="p-2 rounded-md bg-gray-700 hover:bg-gray-800">Users</button>
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
          <img src="./assets/avatar.png" alt="User Avatar" class="w-10 h-10 rounded-full">
        </div>
      </header>

      <!-- LineChart Section -->
      <section class="line-chart bg-gray-700 p-6 rounded-lg shadow-lg mb-6">
        <h2 class="text-xl text-white mb-4">Working Hours Line Chart</h2>
        <LineChart />
      </section>

      <!-- Charts Section -->
      <section class="charts grid grid-cols-3 gap-6 mb-6">
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
      <section class="users p-0">
        <h2 class="text-xl text-white mb-4">Users List</h2>
        <div class="overflow-x-auto">
          <UserList />
        </div>
      </section>
    </main>
  </div>
</template>

<script>
import UserList from './components/UserList.vue';  // Import de ton composant personnalisé
import LineChart from './components/LineChart.vue';  // Import du nouveau composant LineChart

export default {
  name: "Dashboard",
  components: {
    UserList,  // Enregistrement du composant
    LineChart, // Enregistrement du LineChart
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
    };
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
  width: 100%; /* Prendre toute la largeur */
}

table {
  width: 100%;
}

table thead th {
  padding-bottom: 10px;
}

table tbody td {
  padding: 10px 0;
}
</style>
