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
              <th class="text-left px-4 py-2 text-gray-600">Actions</th>
            </tr>
            </thead>
            <tbody>
            <tr v-for="(wt, index) in workingTimes" :key="wt.id" class="border-b">
              <td class="px-4 py-2">{{ `Session ${index + 1}` }}</td>
              <td class="px-4 py-2">{{ formatDateTime(wt.start) }}</td>
              <td class="px-4 py-2">{{ formatDateTime(wt.end) }}</td>
              <td class="px-4 py-2">{{ calculateDuration(wt.total_time) }}</td>
              <td class="px-4 py-2">
                <button @click="openModal(wt.id)" class="bg-blue-500 text-white px-4 py-1 rounded">
                  Ouvrir
                </button>
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <!-- Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-gray-600 bg-opacity-50 flex justify-center items-center">
      <div class="bg-white p-6 rounded shadow-lg max-w-lg w-full">
        <h3 class="text-xl font-semibold mb-4">Détails du Working Time</h3>

        <div v-if="loadingModal">
          <p class="text-gray-500">Chargement...</p>
        </div>

        <div v-else-if="selectedWorkingTime">
          <p><strong>Début :</strong> {{ formatDateTime(selectedWorkingTime.start) }}</p>
          <p><strong>Fin :</strong> {{ formatDateTime(selectedWorkingTime.end) }}</p>
          <p><strong>Durée :</strong> {{ calculateDuration(selectedWorkingTime.total_time) }} heures</p>

          <!-- Bouton Éditer -->
          <button class="bg-yellow-500 text-white px-4 py-1 rounded mt-4">Éditer</button>
        </div>

        <!-- Bouton Fermer -->
        <button @click="closeModal" class="bg-red-500 text-white px-4 py-1 rounded mt-4">
          Fermer
        </button>
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
      showModal: false,
      selectedWorkingTime: null,
      loadingModal: false,
    };
  },
  methods: {
    async getWorkingTimes() {
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
    async openModal(workingTimeID) {
      this.showModal = true;
      this.loadingModal = true;

      // Récupérer les détails du working time via la route
      try {
        const userID = 1; // ID de l'utilisateur
        const response = await axios.get(`http://localhost:4000/api/workingtimes/${userID}/${workingTimeID}`);
        this.selectedWorkingTime = response.data.data;
        this.loadingModal = false;
      } catch (error) {
        console.error('Erreur lors de la récupération du working_time:', error);
        this.loadingModal = false;
      }
    },
    closeModal() {
      this.showModal = false;
      this.selectedWorkingTime = null;
    },
    formatDateTime(datetime) {
      const date = new Date(datetime);
      return date.toLocaleString();
    },
    calculateDuration(totalTimeInMinutes) {
      const totalTimeInHours = (totalTimeInMinutes / 60).toFixed(2); // Convertir les minutes en heures
      return totalTimeInHours;
    },
  },
  mounted() {
    this.getWorkingTimes();
  },
};
</script>

<style scoped>
/* Tu peux ajouter des styles supplémentaires ici si nécessaire */
</style>
