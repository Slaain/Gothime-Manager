<template>
  <div
    class="flex flex-col items-center justify-center min-h-screen bg-gradient-to-r from-blue-50 via-white to-blue-50"
  >
    <div class="w-full max-w-5xl p-8 bg-white rounded-lg shadow-2xl">
      <h2
        class="mb-8 text-4xl font-bold tracking-wide text-center text-blue-800"
      >
        Working Times Bar Chart
      </h2>

      <div v-if="loading" class="flex items-center justify-center h-40">
        <!-- Animation de chargement -->
        <div
          class="w-12 h-12 ease-linear border-4 border-t-4 border-gray-200 rounded-full loader"
        ></div>
      </div>

      <div v-else>
        <div
          v-if="workingTimes.length === 0"
          class="w-1/2 p-6 text-center rounded-lg shadow-lg glassmorphism-bg-white"
        >
          <p>No working times found.</p>
        </div>

        <div v-else>
          <!-- Graphique ApexCharts -->
          <div class="flex justify-center">
            <apexchart
              class="w-full"
              width="100%"
              height="400"
              type="bar"
              :options="chartOptions"
              :series="series"
            ></apexchart>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import VueApexCharts from "vue3-apexcharts";
import axios from "axios";

export default {
  name: "WorkingTimesChart",
  components: {
    apexchart: VueApexCharts,
  },
  data() {
    return {
      workingTimes: [],
      loading: true,
      chartOptions: {
        chart: {
          id: "working-time-bar",
          toolbar: {
            show: false, // Cache la barre d'outils
          },
        },
        xaxis: {
          categories: [],
          labels: {
            style: {
              colors: "#4A5568", // Couleur des labels
              fontSize: "14px",
            },
          },
        },
        yaxis: {
          title: {
            text: "Duration (hours)",
            style: {
              color: "#4A5568",
              fontSize: "16px",
            },
          },
          labels: {
            style: {
              colors: "#4A5568",
              fontSize: "14px",
            },
          },
        },
        fill: {
          colors: ["#4A90E2"], // Couleur des barres
        },
        dataLabels: {
          enabled: false, // Désactiver les labels sur les barres
        },
        plotOptions: {
          bar: {
            borderRadius: 5, // Ajoute des coins arrondis aux barres
            columnWidth: "50%",
          },
        },
        grid: {
          borderColor: "#E2E8F0", // Couleur des lignes de la grille
        },
      },
      series: [
        {
          name: "Working Time Duration (hrs)",
          data: [],
        },
      ],
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
      },
    },
  },
  methods: {
    async fetchWorkingTimes(userID) {
      try {
        const userID = 1;
        const response = await axios.get(
          `http://localhost:4000/api/workingtimes/${userID}`,
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.workingTimes = response.data.data;
        this.loading = false;
        this.prepareChartData();
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des working_times:",
          error
        );
        this.loading = false;
      }
    },
    async prepareChartData() {
      try {
        const categories = this.workingTimes.map((wt) =>
          this.formatDate(wt.start)
        );
        const durations = this.workingTimes.map((wt) =>
          this.calculateDurationInHours(wt.start, wt.end)
        );
        this.chartOptions.xaxis.categories = categories;
        this.series[0].data = durations;
        const response = await fetch(
          `http://localhost:4000/api/workingtimes/${userID}`
        );
        const data = await response.json();
        const transformedData = this.prepareChartData(data.data);

        // Afficher les données dans le graphique
        this.renderChart(transformedData.labels, transformedData.durations);
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des working times:",
          error
        );
      }
    },

    prepareChartData(data) {
      const labels = data.map((wt) => this.formatDate(wt.start));
      const durations = data.map((wt) =>
        this.calculateDurationInHours(wt.start, wt.end)
      );

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
  },
  mounted() {
    this.getWorkingTimes();
  },

  renderChart(labels, durations) {
    const canvas = document.getElementById("barChart");

    // Vérifie que l'élément canvas est trouvé dans le DOM
    if (!canvas) {
      console.error("Canvas element not found");
      return;
    }

    // Vérifie s'il existe déjà un graphique et le détruit pour éviter les erreurs
    if (this.chartInstance) {
      this.chartInstance.destroy();
      this.chartInstance = null; // Réinitialise l'instance après destruction
    }

    const chartContext = canvas.getContext("2d");

    // Crée une nouvelle instance de Chart
    this.chartInstance = new Chart(chartContext, {
      type: "bar",
      data: {
        labels: labels, // Labels pour chaque barre (dates)
        datasets: [
          {
            label: "Working Time Duration (hrs)",
            data: durations, // Durées travaillées
            backgroundColor: "rgba(75, 192, 192, 0.6)",
            borderColor: "rgb(75, 192, 192)",
            borderWidth: 1,
          },
        ],
      },
      options: {
        responsive: true,
        scales: {
          x: {
            title: {
              display: true,
              text: "Dates",
            },
          },
          y: {
            beginAtZero: true,
            title: {
              display: true,
              text: "Hours Worked",
            },
          },
        },
      },
    });
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

.bar-chart-container {
  max-width: 700px;
  margin: 0 auto;
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
