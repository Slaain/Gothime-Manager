<template>
  <div class="max-w-[720px] mx-auto">
    <div v-if="loading" class="text-center text-gray-500">Loading...</div>

    <div v-else>
      <div
        v-if="workingTimes.length === 0"
        class="py-5 text-center text-gray-500 glassmorphism-bg-white"
      >
        No working times found.
      </div>

      <div v-else>
        <table class="min-w-full glassmorphism-bg-white">
          <thead class="border-b">
            <tr>
              <th class="px-4 py-2 text-left text-gray-600">
                Session {{ userID }}
              </th>
              <th class="px-4 py-2 text-left text-gray-600">Start</th>
              <th class="px-4 py-2 text-left text-gray-600">End</th>
              <th class="px-4 py-2 text-left text-gray-600">Duration (hrs)</th>
              <th class="px-4 py-2 text-left text-gray-600"></th>
              <th class="px-4 py-2 text-left text-gray-600"></th>
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
              <td class="px-4 py-2">
                <button
                  @click="openUpdateWorkingtimeModal(wt.id)"
                  class="px-4 text-sm text-blue-600 hover:underline"
                >
                  Edit
                </button>
                <button
                  @click.stop="openDeleteWorkingtimeModal(wt.id)"
                  class="px-4 py-2 text-sm text-red-600 hover:underline"
                >
                  Delete
                </button>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>

  <!-- Modal to update working time -->
  <div
    v-if="showUpdateWorkingtimeModal"
    class="fixed inset-0 z-50 flex flex-col items-center justify-center bg-black bg-opacity-50"
  >
    <div class="px-12 py-4 bg-white">
      <h2 class="mb-4 text-lg font-bold">Update working time</h2>
      <!-- Dropdown et input pour la modification -->
      <p class="mb-2">User</p>
      <Dropdown class="w-full" />
      <div class="w-full">
        <p>Start time</p>
        <input
          type="datetime-local"
          v-model="startTime"
          class="w-full px-2 py-2 border border-black rounded-lg"
        />
      </div>
      <div class="w-full">
        <p>End time</p>
        <input
          type="datetime-local"
          v-model="endTime"
          class="w-full px-2 py-2 border border-black rounded-lg"
        />
      </div>
      <button
        @click="updateWorkingTime"
        class="w-full px-4 py-2 mt-4 text-black bg-primaryYellow rounded-md hover:bg-primaryYellow400"
      >
        Update
      </button>
      <button
        @click="closeUpdateWorkingtimeModal"
        class="w-full px-4 py-2 mt-2 text-black border border-primaryYellow rounded-md hover:bg-neutral-100"
      >
        Cancel
      </button>
    </div>
  </div>

  <!-- Modal to delete working time -->
  <div
    v-if="showDeleteWorkingtimeModal"
    class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
  >
    <div class="w-1/2 px-8 py-4 bg-white">
      <p class="text-xl font-extrabold text-zinc-950">Delete Working Time</p>
      <p>Are you sure you want to delete this working time?</p>
      <button
        @click="deleteWorkingTime"
        class="w-full py-2 mt-4 text-black transition-all bg-primaryYellow rounded-lg hover:bg-primaryYellow400"
      >
        Delete
      </button>
      <button
        @click="closeDeleteWorkingtimeModal"
        class="w-full py-2 mt-2 text-black transition-all border border-primaryYellow rounded-lg hover:bg-neutral-100"
      >
        Cancel
      </button>
    </div>
  </div>

  <!-- Modal to create working time -->
  <div
    v-if="showCreateWorkingtimeModal"
    class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
  >
    <div class="w-1/2 px-8 py-4 bg-white">
      <h2 class="mb-4 text-lg font-bold">Add Working Time</h2>
      <!-- Dropdown and input for creation -->
      <h2 class="mb-4 text-lg font-bold">Update working time</h2>
      <!-- Dropdown et input pour la modification -->
      <p class="mb-2">User</p>
      <Dropdown class="w-full" />
      <div class="w-full">
        <p>Start time</p>
        <input
          type="datetime-local"
          v-model="startTime"
          class="w-full px-2 py-2 border border-black rounded-lg"
        />
      </div>
      <div class="w-full">
        <p>End time</p>
        <input
          type="datetime-local"
          v-model="endTime"
          class="w-full px-2 py-2 border border-black rounded-lg"
        />
      </div>
      <button
        @click="createWorkingTime"
        class="w-full px-4 py-2 mt-4 text-white bg-purple-700 rounded-md hover:bg-purple-800"
      >
        Create
      </button>
      <button
        @click="closeCreateWorkingtimeModal"
        class="w-full px-4 py-2 mt-2 text-white bg-red-500 rounded-md hover:bg-red-600"
      >
        Cancel
      </button>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toastification";

export default {
  props: ["userID"],

  setup() {
    const toast = useToast();
    return { toast };
  },

  data() {
    return {
      workingTimes: [],
      loading: true,
      showUpdateWorkingtimeModal: false,
      showDeleteWorkingtimeModal: false,
      startTime: "",
      endTime: "",
      showCreateWorkingtimeModal: false,
      selectedWorkingTimeID: null,
    };
  },
  watch: {
    userID(newUserID) {
      if (newUserID) {
        console.log("UserID a changé :", newUserID);
        this.getWorkingTimes();
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
    deleteWorkingTime() {
      axios
        .delete(
          `http://localhost:4000/api/workingtime/${this.selectedWorkingTimeID}`
        )
        .then((response) => {
          console.log("Réponse :", response.data);
          this.toast.success(response.data.message);
          this.getWorkingTimes();
          this.closeDeleteWorkingtimeModal();
        })
        .catch((error) => {
          console.error("Erreur lors de la requête :", error);
        });
    },
    calculateDuration(totalTimeInMinutes) {
      const totalTimeInHours = totalTimeInMinutes / 60;
      return Math.ceil(totalTimeInHours);
    },
    createWorkingTime() {
      console.log("start time: ", this.startTime);
      console.log("end time: ", this.endTime);

      axios
        .post(
          `http://localhost:4000/api/workingtime/${this.userID}`,
          {
            start: this.startTime,
            end: this.endTime,
          },
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          console.log("Réponse :", response.data);
          this.toast.success(response.data.message);
          this.getWorkingTimes();
          this.closeCreateWorkingtimeModal();
        })
        .catch((error) => {
          console.error("Erreur lors de la requête :", error);
        });
    },
    updateWorkingTime() {
      console.log("start time: ", this.startTime);

      axios
        .put(
          `http://localhost:4000/api/workingtime/${this.selectedWorkingTimeID}`,
          {
            start: this.startTime,
            end: this.endTime,
          },
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          console.log("Réponse :", response.data);
          this.toast.success(response.data.message);
          this.getWorkingTimes();
          this.closeUpdateWorkingtimeModal();
        })
        .catch((error) => {
          console.error("Erreur lors de la requête :", error);
        });
    },
    getWorkingTime() {
      console.log("getWorkingTime : ", this.userID);

      axios
        .get(
          `http://localhost:4000/api/workingtime/${this.userID}/${this.selectedWorkingTimeID}`
        )
        .then((response) => {
          const workingTimeData = response.data;
          console.log("Données récupérées :", workingTimeData.data);

          this.startTime = workingTimeData.data.start;
          this.endTime = workingTimeData.data.end;
        })
        .catch((error) => {
          console.error("Erreur lors de la requête :", error);
        });
    },
    openUpdateWorkingtimeModal(workingTimeID) {
      this.showUpdateWorkingtimeModal = true;
      this.selectedWorkingTimeID = workingTimeID;
      this.getWorkingTime();
    },
    openDeleteWorkingtimeModal(workingTimeID) {
      this.showDeleteWorkingtimeModal = true;
      this.selectedWorkingTimeID = workingTimeID;
    },
    openCreateWorkingtimeModal() {
      this.showCreateWorkingtimeModal = true;
    },
    closeUpdateWorkingtimeModal() {
      this.showUpdateWorkingtimeModal = false;
      this.selectedWorkingTimeID = null;
      this.startTime = "";
      this.endTime = "";
    },
    closeDeleteWorkingtimeModal() {
      this.showDeleteWorkingtimeModal = false;
      this.selectedWorkingTimeID = null;
    },
    closeCreateWorkingtimeModal() {
      this.showCreateWorkingtimeModal = false;
      this.selectedWorkingTimeID = null;
      this.startTime = "";
      this.endTime = "";
    },
  },
  mounted() {
    this.getWorkingTimes();
  },
};
</script>


<style scoped>
.glassmorphism-bg-white {
  position: relative;
  background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px; /* Arrondi des angles */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
  color: white;
  overflow: hidden; /* Pour assurer que le pseudo-élément reste dans les limites du conteneur */
}

.glassmorphism-bg-white::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 2px; /* Épaisseur de la bordure */
  border-radius: 10px; /* Même bordure arrondie */
  background: linear-gradient(
    to bottom right,
    #ffffff,
    rgba(255, 255, 255, 0.8),
    #ffffff
  ); /* Dégradé entièrement blanc */
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none; /* Empêche les événements de la souris sur le pseudo-élément */
}

.glassmorphism-bg-white h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85); /* Couleur blanche avec transparence */
}

.glassmorphism-bg-white .line-chart {
  padding: 1rem;
  border-radius: 8px;
}
</style>
