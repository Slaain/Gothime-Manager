<template>
  <div
    class="flex flex-col items-center justify-center min-h-screen bg-gray-100"
  >
    <div class="w-full max-w-4xl p-6 bg-white rounded-lg shadow-md">
      <h2 class="mb-6 text-3xl font-semibold text-center text-gray-800">
        Working Times Overview
      </h2>

      <div v-if="loading" class="text-center text-gray-500">Loading...</div>

      <div v-else>
        <div v-if="workingTimes.length === 0" class="text-center text-gray-500">
          No working times found.
        </div>

        <div v-else>
          <table class="min-w-full bg-white">
            <thead class="border-b">
              <tr>
                <th class="px-4 py-2 text-left text-gray-600">
                  Session {{ userID }}
                </th>
                <th class="px-4 py-2 text-left text-gray-600">Start</th>
                <th class="px-4 py-2 text-left text-gray-600">End</th>
                <th class="px-4 py-2 text-left text-gray-600">
                  Duration (hrs)
                </th>
              </tr>
            </thead>
            <tbody>
              <tr
                v-for="(wt, index) in workingTimes"
                :key="wt.id"
                class="border-b"
              >
                <td class="px-4 py-2">{{ `Session ${index + 1}` }}</td>
                <td class="px-4 py-2">{{ formatDateTime(wt.start) }}</td>
                <td class="px-4 py-2">{{ formatDateTime(wt.end) }}</td>
                <td class="px-4 py-2">
                  {{ calculateDuration(wt.total_time) }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  props: ["userID"],

  data() {
    return {
      workingTimes: [],
      loading: true,
    };
  },
  watch: {
    userID(newUserID) {
      if (newUserID) {
        console.log("UserID a changé :", newUserID);
        // console.log("this.userID : ", this.userID);

        this.getWorkingTimes(); // Appel de la méthode pour mettre à jour les données
      }
    },
  },
  methods: {
    async getWorkingTimes() {
      console.log("allo : ", this.userID);
      try {
        const response = await axios.get(
          `http://localhost:4000/api/workingtimes/${this.userID}`
        );
        this.workingTimes = response.data.data;
        console.log("aled : ", this.workingTimes);
        this.loading = false;
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des working_times:",
          error
        );
        this.loading = false;
      }
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
/* Tu peux aussi ajouter des styles personnalisés ici si nécessaire */
</style>
