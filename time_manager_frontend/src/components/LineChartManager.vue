<script>
import { Line } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, LineElement, CategoryScale, LinearScale } from 'chart.js';
import axios from 'axios';

ChartJS.register(Title, Tooltip, Legend, LineElement, CategoryScale, LinearScale);

export default {
  props: {
    organizationId: {
      type: String,
      required: true
    }
  },
  components: {
    Line
  },
  data() {
    return {
      chartData: {
        labels: [],
        datasets: [
          {
            label: 'Working Hours',
            data: [],
            fill: false,
            borderColor: '#fdcb12'
          }
        ]
      }
    };
  },
  methods: {
    async fetchWorkingTimes() {
      try {
        const response = await axios.get(`http://localhost:4000/api/workingtimes/by_organisation/${this.organizationId}`);
        const workingTimes = response.data;

        // Remplir les labels et données du graphique
        this.chartData.labels = workingTimes.map(item => new Date(item.start).toLocaleDateString());
        this.chartData.datasets[0].data = workingTimes.map(item => {
          const start = new Date(item.start);
          const end = item.end ? new Date(item.end) : new Date();
          return (end - start) / (1000 * 60 * 60); // Convertir en heures
        });
      } catch (error) {
        console.error('Erreur lors de la récupération des données:', error);
      }
    }
  },
  mounted() {
    this.fetchWorkingTimes();
  }
};
</script>
