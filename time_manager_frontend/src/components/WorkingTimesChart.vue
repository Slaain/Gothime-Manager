<template>
  <div class="flex flex-col items-center justify-center min-h-screen bg-gray-100">
    <div class="w-full max-w-4xl p-6 bg-white rounded-lg shadow-md">
      <h2 class="text-3xl font-semibold text-center text-gray-800 mb-6">Working Times Overview</h2>

      <div v-if="loading" class="text-center text-gray-500">Loading...</div>

      <div v-else>
        <div v-if="workingTimes.length === 0" class="text-center text-gray-500">
          No working times found.
        </div>

        <div v-else>
          <!-- Ajouter des étiquettes d'axes -->
          <div class="flex justify-between w-full mb-4">
            <span>8:00</span>
            <span>12:00</span>
            <span>16:00</span>
            <span>19:00</span>
          </div>

          <!-- Afficher les barres avec des hauteurs basées sur la durée de travail -->
          <div class="grid grid-cols-5 gap-4">
            <div v-for="(wt, index) in workingTimes" :key="index" class="relative">
              <div
                  :style="{ height: calculateBarHeight(wt.start, wt.end) + 'px' }"
                  class="bg-blue-500 w-full"
              ></div>
              <span class="absolute bottom-0 text-center">{{ `Session ${index + 1}` }}</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      workingTimes: [],
      loading: true,
    };
  },
  methods: {
    async fetchWorkingTimes() {
      try {
        const userID = 2; // ID de l'utilisateur
        const response = await axios.get(`http://localhost:4000/api/workingtimes/${userID}`);
        this.workingTimes = response.data.data;
        this.loading = false;
      } catch (error) {
        console.error('Erreur lors de la récupération des working_times:', error);
        this.loading = false;
      }
    },
    calculateBarHeight(start, end) {
      // Convertir les dates et calculer la durée en heures
      const startTime = new Date(start);
      const endTime = new Date(end);
      const duration = (endTime - startTime) / (1000 * 60 * 60); // Convertir en heures

      // Multiplication pour ajuster visuellement la hauteur de la barre
      return duration * 50; // Ajuster ce multiplicateur pour l'échelle visuelle
    },
  },
  mounted() {
    this.fetchWorkingTimes();
  },
};
</script>

<style scoped>
/* Tu peux ajuster les styles pour donner plus d'espace au graphique */
.grid-cols-5 {
  display: grid;
  grid-template-columns: repeat(5, 1fr);
}

.bg-blue-500 {
  transition: height 0.3s ease;
}
</style>
