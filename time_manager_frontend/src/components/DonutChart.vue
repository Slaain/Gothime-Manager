<template>
  <div>
    <!-- Doughnut chart affichant les données dynamiques récupérées de l'API -->
    <Doughnut :data="chartData" :options="chartOptions" />
  </div>
</template>

<script>
import { defineComponent } from 'vue';
import { Doughnut } from 'vue-chartjs';
import axios from 'axios'; // Utilisation d'axios pour les requêtes HTTP

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
        labels: [], // Labels des organisations
        datasets: [
          {
            label: 'Hours Worked',
            backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40'], // Couleurs pour le graphique
            data: [] // Données pour les heures travaillées
          }
        ]
      },
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false
      }
    };
  },
  props: {
    // L'ID de l'organisation, s'il est nécessaire pour la requête
    organisationId: {
      type: String,
      required: false
    }
  },
  methods: {
    async fetchWorkingTimes() {
      try {
        // Requête pour récupérer les heures travaillées par organisation
        const response = await axios.get("http://localhost:4000/api/workingtimes/by_organisation", {
      headers: {
      Authorization: `Bearer ${token}`
      }
    });

        // Transformer les données pour qu'elles soient affichables dans le graphique
        this.updateChartData(data);
      } catch (error) {
        console.error("Erreur lors de la récupération des données :", error);
      }
    },
    updateChartData(data) {
      // Création de maps pour stocker les heures travaillées par organisation
      const organisationMap = new Map();

      // Parcours des données et ajout des heures travaillées pour chaque organisation
      data.forEach((entry) => {
        const orgName = entry.organisation_name; // Assurez-vous que le nom de l'organisation est bien présent
        const hours = entry.total_time / 60; // Convertir en heures

        if (organisationMap.has(orgName)) {
          organisationMap.set(orgName, organisationMap.get(orgName) + hours);
        } else {
          organisationMap.set(orgName, hours);
        }
      });

      // Extraire les labels (nom des organisations) et les données (heures travaillées)
      const labels = Array.from(organisationMap.keys());
      const hoursWorked = Array.from(organisationMap.values());

      // Mise à jour des données du graphique
      this.chartData.labels = labels;
      this.chartData.datasets[0].data = hoursWorked;
    }
  },
  mounted() {
    // Appel de la méthode pour récupérer les données au montage du composant
    this.fetchWorkingTimes();
  }
});
</script>

<style scoped>
canvas {
  max-width: 600px;
  max-height: 400px;
  margin: 0 auto;
  width: 100%; /* Assurez-vous que le canvas prend bien tout l'espace */
  height: 100%;
}
</style>
