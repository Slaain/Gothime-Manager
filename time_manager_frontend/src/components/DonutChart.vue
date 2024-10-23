<template>
    <div>
      <!-- Vérifie que data est correctement passé -->
      <Doughnut :data="chartData" :options="chartOptions" />
    </div>
  </template>
  
  <script>
  import { defineComponent } from 'vue';
  import { Doughnut } from 'vue-chartjs'; // Vérifie l'import correct
  
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
          labels: ['Org A', 'Org B', 'Org C', 'Org D'],
          datasets: [
            {
              label: 'Hours Worked',
              backgroundColor: ['#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0'],
              data: [120, 80, 100, 60] // Simulated data for hours worked
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
      console.log("Chart data:", this.chartData);
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
  