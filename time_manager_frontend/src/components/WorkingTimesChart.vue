<template>
  <div class="bar-chart-container">
    <canvas id="barChart"></canvas>
  </div>
</template>

<script>
import { Chart, BarController, BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend } from 'chart.js';

// Enregistrement des composants nécessaires de Chart.js pour le Bar Chart
Chart.register(BarController, BarElement, CategoryScale, LinearScale, Title, Tooltip, Legend);

export default {
  name: 'BarChart',
  props: {
    userID: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      chartInstance: null // Stocke l'instance du graphique
    };
  },
  watch: {
    userID: {
      immediate: true,
      handler(newUserID) {
        // Appelle fetchWorkingTimes lorsque l'ID de l'utilisateur change
        if (newUserID) {
          this.fetchWorkingTimes(newUserID);
        }
      }
    }
  },
  methods: {
    async fetchWorkingTimes(userID) {
      try {
        const response = await fetch(`http://localhost:4000/api/workingtimes/${userID}`);
        const data = await response.json();
        const transformedData = this.prepareChartData(data.data);

        // Afficher les données dans le graphique
        this.renderChart(transformedData.labels, transformedData.durations);
      } catch (error) {
        console.error('Erreur lors de la récupération des working times:', error);
      }
    },

    prepareChartData(data) {
      const labels = data.map(wt => this.formatDate(wt.start));
      const durations = data.map(wt => this.calculateDurationInHours(wt.start, wt.end));

      return {
        labels: labels,
        durations: durations,
      };
    },

    formatDate(datetime) {
      const date = new Date(datetime);
      return date.toLocaleDateString();
    },

    calculateDurationInHours(start, end) {
      const startTime = new Date(start);
      const endTime = new Date(end);
      const durationMs = endTime - startTime;
      const durationHours = durationMs / (1000 * 60 * 60); // Convertir en heures
      return Math.round(durationHours); // Arrondir à l'entier le plus proche
    },

    renderChart(labels, durations) {
      const canvas = document.getElementById('barChart');

      // Vérifie que l'élément canvas est trouvé dans le DOM
      if (!canvas) {
        console.error('Canvas element not found');
        return;
      }

      // Vérifie s'il existe déjà un graphique et le détruit pour éviter les erreurs
      if (this.chartInstance) {
        this.chartInstance.destroy();
        this.chartInstance = null; // Réinitialise l'instance après destruction
      }

      const chartContext = canvas.getContext('2d');

      // Crée une nouvelle instance de Chart
      this.chartInstance = new Chart(chartContext, {
        type: 'bar',
        data: {
          labels: labels, // Labels pour chaque barre (dates)
          datasets: [{
            label: 'Working Time Duration (hrs)',
            data: durations, // Durées travaillées
            backgroundColor: 'rgba(75, 192, 192, 0.6)',
            borderColor: 'rgb(75, 192, 192)',
            borderWidth: 1,
          }]
        },
        options: {
          responsive: true,
          scales: {
            x: {
              title: {
                display: true,
                text: 'Dates',
              },
            },
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: 'Hours Worked',
              },
            },
          },
        }
      });
    }
  }
};
</script>

<style scoped>
.bar-chart-container {
  max-width: 700px;
  margin: 0 auto;
}
</style>
