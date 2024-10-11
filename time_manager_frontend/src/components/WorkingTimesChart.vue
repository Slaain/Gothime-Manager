<template>
  <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-4xl p-6 bg-white rounded-lg shadow-md">
      <h2 class="text-3xl font-semibold text-center text-gray-800 mb-6">Working Times Bar Chart</h2>

      <div v-if="loading" class="text-center text-gray-500">Loading...</div>

      <div v-else>
        <div v-if="workingTimes.length === 0" class="text-center text-gray-500">
          No working times found.
        </div>

        <div v-else>
          <!-- Graphique ApexCharts -->
          <apexchart width="500" height="350" type="bar" :options="chartOptions" :series="series"></apexchart>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import VueApexCharts from 'vue3-apexcharts';
import axios from 'axios';

export default {
  name: 'WorkingTimesChart',
  components: {
    apexchart: VueApexCharts,
  },
  data() {
    return {
      workingTimes: [], // Les données des heures de travail
      loading: true,
      chartOptions: {
        chart: {
          id: 'working-time-bar',
        },
        xaxis: {
          categories: [], // Les jours seront mis à jour ici
        },
        yaxis: {
          title: {
            text: 'Duration (hours)', // L'axe vertical représente les heures
          },
        },
      },
      series: [
        {
          name: 'Working Time Duration (hrs)',
          data: [], // Les durées en heures seront ajoutées ici
        },
      ],
    };
  },
  methods: {
    async fetchWorkingTimes() {
      try {
        const userID = 1; // Remplace par l'ID de l'utilisateur voulu
        const response = await axios.get(`http://localhost:4000/api/workingtimes/${userID}`);
        this.workingTimes = response.data.data;
        this.loading = false;

        // Préparer les données pour le graphique
        this.prepareChartData();
      } catch (error) {
        console.error('Erreur lors de la récupération des working_times:', error);
        this.loading = false;
      }
    },
    prepareChartData() {
      // Extraire les dates et les durées de chaque session de travail
      const categories = this.workingTimes.map(wt => this.formatDate(wt.start));
      const durations = this.workingTimes.map(wt => this.calculateDurationInHours(wt.start, wt.end));

      // Mettre à jour les données du graphique
      this.chartOptions.xaxis.categories = categories; // Les jours
      this.series[0].data = durations; // Les durées en heures
    },
    formatDate(datetime) {
      const date = new Date(datetime);
      // Retourner uniquement la date (jour/mois/année)
      return date.toLocaleDateString();
    },
    calculateDurationInHours(start, end) {
      const startTime = new Date(start);
      const endTime = new Date(end);
      const durationMs = endTime - startTime;
      return (durationMs / (1000 * 60 * 60)).toFixed(2); // Convertir en heures
    },
  },
  mounted() {
    this.fetchWorkingTimes(); // Récupérer les données lorsque le composant est monté
  },
};
</script>

<style scoped>
h2 {
  text-align: center;
  margin-bottom: 1.5rem;
}
</style>
