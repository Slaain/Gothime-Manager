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
          <table class="min-w-full bg-white">
            <thead class="border-b">
            <tr>
              <th class="text-left px-4 py-2 text-gray-600">Session</th>
              <th class="text-left px-4 py-2 text-gray-600">Start</th>
              <th class="text-left px-4 py-2 text-gray-600">End</th>
              <th class="text-left px-4 py-2 text-gray-600">Duration (hrs)</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(wt, index) in workingTimes" :key="wt.id" class="border-b">
              <td class="px-4 py-2">{{ `Session ${index + 1}` }}</td>
              <td class="px-4 py-2">{{ formatDateTime(wt.start) }}</td>
              <td class="px-4 py-2">{{ formatDateTime(wt.end) }}</td>
              <td class="px-4 py-2">{{ calculateDuration(wt.start, wt.end) }}</td>
            </tr>
            </tbody>
          </table>
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
        const userID = 1; // ID de l'utilisateur
        const response = await axios.get(`http://localhost:4000/api/workingtimes/${userID}`);
        this.workingTimes = response.data.data;
        this.loading = false;
      } catch (error) {
        console.error('Erreur lors de la récupération des working_times:', error);
        this.loading = false;
      }
    },
    formatDateTime(datetime) {
      const date = new Date(datetime);
      return date.toLocaleString();
    },
    calculateDuration(start, end) {
      const startTime = new Date(start);
      const endTime = new Date(end);
      const durationMs = endTime - startTime;
      const durationHours = (durationMs / (1000 * 60 * 60)).toFixed(2); // Convertir en heures
      return durationHours;
    },
  },
  mounted() {
    this.fetchWorkingTimes();
  },
};
</script>

<style scoped>
/* Tu peux aussi ajouter des styles personnalisés ici si nécessaire */
</style>
