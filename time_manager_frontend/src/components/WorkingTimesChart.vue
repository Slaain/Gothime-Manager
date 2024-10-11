<template>
  <div class="flex flex-col items-center justify-center min-h-screen bg-gradient-to-r from-blue-50 via-white to-blue-50">
    <div class="w-full max-w-5xl p-8 bg-white rounded-lg shadow-2xl">
      <h2 class="text-4xl font-bold text-center text-blue-800 mb-8 tracking-wide">Working Times Bar Chart</h2>

      <div v-if="loading" class="flex items-center justify-center h-40">
        <!-- Animation de chargement -->
        <div class="loader ease-linear rounded-full border-4 border-t-4 border-gray-200 h-12 w-12"></div>
      </div>

      <div v-else>
        <div v-if="workingTimes.length === 0" class="text-center text-gray-500">
          No working times found.
        </div>

        <div v-else>
          <!-- Graphique ApexCharts -->
          <div class="flex justify-center">
            <apexchart class="w-full" width="100%" height="400" type="bar" :options="chartOptions" :series="series"></apexchart>
          </div>
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
      workingTimes: [],
      loading: true,
      chartOptions: {
        chart: {
          id: 'working-time-bar',
          toolbar: {
            show: false, // Cache la barre d'outils
          },
        },
        xaxis: {
          categories: [],
          labels: {
            style: {
              colors: '#4A5568', // Couleur des labels
              fontSize: '14px',
            },
          },
        },
        yaxis: {
          title: {
            text: 'Duration (hours)',
            style: {
              color: '#4A5568',
              fontSize: '16px',
            },
          },
          labels: {
            style: {
              colors: '#4A5568',
              fontSize: '14px',
            },
          },
        },
        fill: {
          colors: ['#4A90E2'], // Couleur des barres
        },
        dataLabels: {
          enabled: false, // Désactiver les labels sur les barres
        },
        plotOptions: {
          bar: {
            borderRadius: 5, // Ajoute des coins arrondis aux barres
            columnWidth: '50%',
          },
        },
        grid: {
          borderColor: '#E2E8F0', // Couleur des lignes de la grille
        },
      },
      series: [
        {
          name: 'Working Time Duration (hrs)',
          data: [],
        },
      ],
    };
  },
  methods: {
    async getWorkingTimes() {
      try {
        const userID = 1;
        const response = await axios.get(`http://localhost:4000/api/workingtimes/${userID}`);
        this.workingTimes = response.data.data;
        this.loading = false;
        this.prepareChartData();
      } catch (error) {
        console.error('Erreur lors de la récupération des working_times:', error);
        this.loading = false;
      }
    },
    prepareChartData() {
      const categories = this.workingTimes.map(wt => this.formatDate(wt.start));
      const durations = this.workingTimes.map(wt => this.calculateDurationInHours(wt.start, wt.end));
      this.chartOptions.xaxis.categories = categories;
      this.series[0].data = durations;
    },
    formatDate(datetime) {
      const date = new Date(datetime);
      return date.toLocaleDateString();
    },
    calculateDurationInHours(start, end) {
      const startTime = new Date(start);
      const endTime = new Date(end);
      const durationMs = endTime - startTime;
      return (durationMs / (1000 * 60 * 60)).toFixed(2);
    },
  },
  mounted() {
    this.getWorkingTimes();
  },
};
</script>

<style scoped>
h2 {
  margin-bottom: 1.5rem;
}

.loader {
  border-top-color: #3490dc;
  animation: spinner 0.6s linear infinite;
}

@keyframes spinner {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
}
</style>
