<script setup>
import { Bar } from 'vue-chartjs';
import { Chart, registerables } from 'chart.js';
import axios from 'axios';
import moment from 'moment';
import { ref, onMounted, watch } from 'vue';

Chart.register(...registerables);

const workingTimes = ref([]);
const loading = ref(true);
const chartData = ref({
  labels: [],
  datasets: [
    {
      label: 'Durée de travail (en heures)',
      backgroundColor: '#fdcb12',
      borderColor: '#f5b900',
      borderWidth: 1,
      data: [],
    },
  ],
});

const viewMode = ref('daily');

const fetchDataForViewMode = async (mode) => {
  try {
    loading.value = true;
    const response = await axios.get('http://localhost:4000/api/workingtimes');
    const sortedData = response.data.data.sort((a, b) => moment(a.start).valueOf() - moment(b.start).valueOf());
    processChartData(sortedData, mode);
    loading.value = false;
  } catch (error) {
    console.error('Erreur lors de la récupération des heures de travail :', error);
    loading.value = false;
  }
};

const processChartData = (data, mode) => {
  let groupedData = new Map();

  data.forEach((item) => {
    const startDate = moment(item.start);
    let dateKey;

    switch (mode) {
      case 'daily':
        dateKey = startDate.format('DD/MM');
        break;
      case 'weekly':
        dateKey = `S${startDate.isoWeek()} ${startDate.format('YYYY')}`;
        break;
      case 'monthly':
        dateKey = startDate.format('MMM YYYY');
        break;
      default:
        dateKey = startDate.format('DD/MM/YYYY');
    }

    const hours = item.total_time ? parseFloat(item.total_time) / 60 : 0;
    groupedData.set(dateKey, (groupedData.get(dateKey) || 0) + hours);
  });

  // Convertir Map en arrays triés
  const sortedEntries = Array.from(groupedData.entries()).sort((a, b) => {
    if (viewMode.value === 'daily') {
      return moment(a[0], 'DD/MM').valueOf() - moment(b[0], 'DD/MM').valueOf();
    } else if (viewMode.value === 'weekly') {
      return moment(a[0], 'Wo YYYY').valueOf() - moment(b[0], 'Wo YYYY').valueOf();
    } else {
      return moment(a[0], 'MMM YYYY').valueOf() - moment(b[0], 'MMM YYYY').valueOf();
    }
  });

  chartData.value = {
    labels: sortedEntries.map(entry => entry[0]),
    datasets: [{
      label: 'Durée de travail (en heures)',
      backgroundColor: '#fdcb12',
      borderColor: '#f5b900',
      borderWidth: 1,
      data: sortedEntries.map(entry => Math.round(entry[1] * 100) / 100),
    }]
  };
};

const changeViewMode = (mode) => {
  viewMode.value = mode;
  fetchDataForViewMode(mode);
};

onMounted(() => {
  fetchDataForViewMode(viewMode.value);
});
</script>

<template>
  <div class="bar-chart-container">
    <div class="button-container mb-4">
      <button
          @click="changeViewMode('daily')"
          :class="{ active: viewMode === 'daily' }"
      >
        Day
      </button>
      <button
          @click="changeViewMode('weekly')"
          :class="{ active: viewMode === 'weekly' }"
      >
        Week
      </button>
      <button
          @click="changeViewMode('monthly')"
          :class="{ active: viewMode === 'monthly' }"
      >
        Month
      </button>
    </div>
    <div v-if="loading" class="loading-indicator">
      <p>Chargement des données...</p>
    </div>
    <div v-else class="chart-wrapper">
      <Bar
          :data="chartData"
          :options="{
          responsive: true,
          maintainAspectRatio: false,
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                color: '#ffffff',
                padding: 10,
                callback: function(value) {
                  return value.toLocaleString();
                }
              },
              grid: {
                color: 'rgba(255, 255, 255, 0.2)',
                drawBorder: false
              }
            },
            x: {
              beginAtZero: true,
              ticks: {
                color: '#ffffff',
                padding: 10,
                maxRotation: 45,
                minRotation: 45
              },
              grid: {
                display: false,
                drawBorder: false
              }
            }
          },
          plugins: {
            legend: {
              labels: {
                color: '#ffffff',
                padding: 20
              }
            },
            title: {
              display: true,
              text: 'Working Hours',
              color: '#ffffff',
              font: {
                size: 20
              },
              padding: {
                top: 20,
                bottom: 20
              }
            }
          },
          layout: {
            padding: {
              left: 20,
              right: 30,
              top: 20,
              bottom: 20
            }
          },
          barPercentage: 0.7,
          categoryPercentage: 0.9
        }"
          style="height: 500px;"
      />
    </div>
  </div>
</template>

<style scoped>
.bar-chart-container {
  padding: 2rem;
  border-radius: 15px;
  width: 100%;
  color: white;
  background: #333333;
}

.chart-wrapper {
  position: relative;
  margin: auto;
  height: 500px;
  width: 100%;
}

.button-container {
  display: flex;
  gap: 10px;
  justify-content: center;
  margin-bottom: 2rem;
}

.button-container button {
  background-color: #3e3e3e;
  color: #fdcb12;
  padding: 0.75rem 1.5rem;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  font-weight: bold;
  transition: all 0.3s ease;
}

.button-container button:hover {
  background-color: #4e4e4e;
}

.button-container button.active {
  background-color: #fdcb12;
  color: #000;
}

.loading-indicator {
  text-align: center;
  color: #ffffff;
  font-size: 1.5rem;
  padding-top: 20px;
}
</style>