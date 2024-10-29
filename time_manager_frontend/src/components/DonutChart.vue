    <template>
      <div>
        <!-- Test console pour vérifier si le composant est rendu -->
        <p>Vérification du rendu du composant DonutChart</p>
        <Doughnut :data="chartData" :options="chartOptions" />
      </div>
    </template>


    <script>
    import { defineComponent } from 'vue';
    import { Doughnut } from 'vue-chartjs';
    import axios from 'axios';

    import {
      Chart as ChartJS,
      Title,
      Tooltip,
      Legend,
      ArcElement,
      CategoryScale
    } from 'chart.js';

    ChartJS.register(Title, Tooltip, Legend, ArcElement, CategoryScale);

    export default defineComponent({
    name: 'DonutChart',
    components: {
      Doughnut
    },
    data() {
      return {
        chartData: {
          labels: [],
          datasets: [
            {
              label: 'Hours Worked',
              backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
              data: [] // Rempli dynamiquement avec les données
            }
          ]
        },
        chartOptions: {
          responsive: true,
          maintainAspectRatio: false
        }
      };
    },
    mounted() {
      console.log('test');
      this.fetchOrganisationsAndWorkingTimes();
    },
    methods: {
      async fetchOrganisationsAndWorkingTimes() {
        console.log('fetchorga');
        try {
          // Étape 1 : Obtenir toutes les organisations
          const organisationsResponse = await axios.get('http://localhost:4000/api/organisations');
          console.log("Response complète de l'API pour les organisations :", organisationsResponse);
          const organisations = organisationsResponse.data.data;

          // Initialiser les labels et les données pour le graphique
          const labels = [];
          const data = [];

          // Parcourir chaque organisation et récupérer les heures travaillées
          for (const organisation of organisations) {
            // Ajouter le nom de l'organisation au label
            labels.push(organisation.name);

            // Étape 2 : Obtenir les heures travaillées pour cette organisation
            const workingTimesResponse = await axios.get(`http://localhost:4000/api/workingtimes/by_organisation/${organisation.id}`);
            const workingTimes = workingTimesResponse.data;
            console.log('workingtimes', workingTimes);

            // Calculer le total des heures travaillées pour cette organisation en utilisant `total_time`
            const totalHours = workingTimes.reduce((sum, time) => sum + (time.working_time.total_time / 3600), 0); // Convertir en heures
            console.log('totalHours', totalHours);

            data.push(totalHours);
          }

          // Mettre à jour chartData en recréant l'objet pour forcer la réactivité
          this.chartData = {
            labels: labels,
            datasets: [
              {
                label: 'Hours Worked',
                backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
                data: data
              }
            ]
          };
        } catch (error) {
          console.error("Erreur lors de la récupération des données pour le graphique :", error);
        }
      }
    }
  });

    </script>

    <style scoped>
    canvas {
      max-width: 600px;
      max-height: 400px;
      margin: 0 auto;
      width: 100%;
      height: 100%;
    }
    </style>
