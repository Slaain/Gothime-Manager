<script setup>
import Sidebar from "../components/Sidebar.vue";
import LineChart from "../components/LineChart.vue";
import BarChart from "../components/BarChart.vue";
</script>

<template>
  <div class="chart-container">
    <!-- Sidebar -->
    <Sidebar active="Charts" />

    <!-- Main Content with Line Chart -->
    <main class="flex-1 p-6 main-content">
      <section class="p-6 mb-6 rounded-lg shadow-lg glassmorphism line-chart">
        <h2 class="mb-4 text-xl text-white">Working Hours Line Chart</h2>
        <LineChart />
      </section>
      <section class="p-6 mb-6 rounded-lg shadow-lg glassmorphism line-chart">
        <h2 class="mb-4 text-xl text-white">Working Hours Bar Chart</h2>
        <BarChart />
      </section>
    </main>
  </div>
</template>

<style scoped>
.chart-container {
  display: flex;
  min-height: 100vh;
}

.main-content {
  flex: 1;
  padding: 20px;
  background-color: rgba(0, 0, 0, 0.8);
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
  padding: 1rem;
}

.line-chart {
  padding: 1rem;
  border-radius: 8px;
  width: 100%;
  color: white;
}
</style>
