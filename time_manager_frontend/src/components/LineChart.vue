  <template>
  <div class="line-chart-container">
    <canvas id="myChart"></canvas>
  </div>
</template>
    
    <script>
import {
  Chart,
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
  LineController,
} from "chart.js";

// Enregistrement des composants nécessaires de Chart.js, y compris le LineController
Chart.register(
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
  LineController
);

export default {
  name: "LineChart",
  data() {
    return {
      chartInstance: null, // Stocke l'instance du graphique
    };
  },
  mounted() {
    // Attendre que le DOM soit prêt avant d'afficher le graphique
    this.$nextTick(() => {
      this.fetchWorkingTimes(); // Appel de la fonction pour récupérer et traiter les données
    });
  },
  methods: {
    async fetchWorkingTimes() {
      try {
        const response = await fetch("http://localhost:4000/api/workingtimes"); // Remplace avec la bonne route si nécessaire
        const data = await response.json();
        // Appel de la fonction pour traiter les données et les grouper par mois
        const transformedData = this.groupWorkingTimesByMonth(data.data);

        // Afficher les données dans le graphique
        this.renderChart(transformedData.labels, transformedData.hoursWorked);
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des working times:",
          error
        );
      }
    },

    groupWorkingTimesByMonth(data) {
      const monthMap = new Map();
      const currentMonth = new Date().getMonth(); // Mois actuel (de 0 à 11)
      const currentYear = new Date().getFullYear(); // Année actuelle

      // Parcours de chaque working time
      data.forEach((entry) => {
        const entryDate = new Date(entry.start);
        const entryMonth = entryDate.getMonth();
        const entryYear = entryDate.getFullYear();

        // Vérifie si l'entrée est antérieure ou égale au mois actuel et à l'année actuelle
        if (
          entryYear < currentYear ||
          (entryYear === currentYear && entryMonth <= currentMonth)
        ) {
          const month = entryDate.toLocaleString("en-US", {
            month: "short",
            year: "numeric",
          });

          // Additionne le total_time pour chaque mois
          if (monthMap.has(month)) {
            monthMap.set(month, monthMap.get(month) + entry.total_time / 60); // Convertir en heures
          } else {
            monthMap.set(month, entry.total_time / 60); // Convertir en heures
          }
        }
      });

      // Trier les mois par ordre chronologique
      const sortedMonths = Array.from(monthMap.keys()).sort(
        (a, b) => new Date(a) - new Date(b)
      );
      const hoursWorked = sortedMonths.map((month) => monthMap.get(month));

      // Retourner les 8 derniers mois
      return {
        labels: sortedMonths.slice(-8),
        hoursWorked: hoursWorked.slice(-8),
      };
    },

    renderChart(labels, hoursWorked) {
      const canvas = document.getElementById("myChart");

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
        type: "line",
        data: {
          labels: labels, // Mois
          datasets: [
            {
              label: "Hours Worked",
              data: hoursWorked, // Heures travaillées
              fill: false,
              borderColor: "#FDCB12",
              tension: 0.1,
            },
          ],
        },
        options: {
          responsive: true,
          scales: {
            x: {
              title: {
                display: true,
                text: "Months",
                color: "#ffffff", // Couleur des titres X en blanc
              },
              ticks: {
                color: "#ffffff", // Couleur des ticks X en blanc
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)", // Grille légèrement transparente
              },
            },
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: "Hours Worked",
                color: "#ffffff", // Couleur des titres Y en blanc
              },
              ticks: {
                color: "#ffffff", // Couleur des ticks Y en blanc
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)", // Grille légèrement transparente
              },
            },
          },
          plugins: {
            legend: {
              labels: {
                color: "#ffffff", // Couleur de la légende en blanc
              },
            },
          },
        },
      });
    },
  },
};
</script>
    
    <style scoped>
.line-chart-container {
  max-width: 700px;
  margin: 0 auto;
  /* border-radius: 10px; */
}
</style>
    