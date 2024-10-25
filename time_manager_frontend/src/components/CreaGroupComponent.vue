<template>
  <div class="max-w-[720px] mx-auto bg-transparent">
    <div
      class="relative flex flex-col w-full h-full px-6 py-5 mt-4 text-white bg-gray-800 shadow-md rounded-xl"
    >
      <!-- Liste des groupes -->
      <div class="flex items-center justify-between">
        <h3 class="text-lg font-semibold text-yellow-400">Work Groups</h3>
        <button
          @click="openGroupModal"
          class="flex items-center gap-2 bg-yellow-400 py-2.5 px-4 text-xs font-semibold text-black rounded-md hover:bg-yellow-500"
        >
          <svg
            xmlns="http://www.w3.org/2000/svg"
            fill="currentColor"
            viewBox="0 0 24 24"
            class="w-4 h-4"
          >
            <path
              d="M12 4v16m8-8H4"
              stroke-width="2"
              stroke="currentColor"
              fill="none"
            />
          </svg>
          Add Work Group
        </button>
      </div>

      <!-- Formulaire de création de groupe -->
      <div v-if="showGroupModal" class="mt-4">
        <label class="block mt-2 text-sm font-bold">Group Name</label>
        <input
          v-model="newGroup.name"
          type="text"
          class="w-full p-2 text-white bg-gray-600 border border-gray-300 rounded"
        />

        <label class="block mt-2 text-sm font-bold">Start Date and Time</label>
        <input
          v-model="newGroup.start_date"
          type="datetime-local"
          class="w-full p-2 text-white bg-gray-600 border border-gray-300 rounded"
        />

        <label class="block mt-2 text-sm font-bold">End Date and Time</label>
        <input
          v-model="newGroup.end_date"
          type="datetime-local"
          class="w-full p-2 text-white bg-gray-600 border border-gray-300 rounded"
        />

        <!-- Sélection d'une organisation -->
        <label class="block mt-2 text-sm font-bold">Select Organisation</label>
        <select
          v-model="selectedOrganisationId"
          class="w-full p-2 text-white bg-gray-600 border border-gray-300 rounded"
        >
          <option
            v-for="organisation in organisations"
            :key="organisation.id"
            :value="organisation.id"
          >
            {{ organisation.name }}
          </option>
        </select>

        <div class="flex justify-end gap-4 mt-4">
          <button
            @click="createGroup"
            class="px-4 py-2 text-black bg-yellow-400 rounded hover:bg-yellow-500"
          >
            Create
          </button>
          <button
            @click="closeGroupModal"
            class="px-4 py-2 text-white bg-red-500 rounded hover:bg-red-600"
          >
            Cancel
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      showGroupModal: false,
      newGroup: {
        name: "",
        start_date: "",
        end_date: "",
      },
      organisations: [], // Liste des organisations
      selectedOrganisationId: null, // ID de l'organisation sélectionnée
    };
  },
  mounted() {
    this.fetchOrganisations(); // Charger les organisations au montage
  },
  methods: {
    openGroupModal() {
      this.showGroupModal = true;
    },
    closeGroupModal() {
      this.showGroupModal = false;
    },
    // Récupérer les organisations depuis l'API
    async fetchOrganisations() {
      try {
        const response = await axios.get(
          "http://localhost:4000/api/organisations"
        );
        this.organisations = response.data.data;
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des organisations",
          error
        );
      }
    },
    // Créer le groupe avec une organisation
    async createGroup() {
      try {
        const response = await axios.post(
          "http://localhost:4000/api/groups",
          {
            group: {
              name: this.newGroup.name,
              start_date: this.newGroup.start_date,
              end_date: this.newGroup.end_date,
            },
            organisation_id: this.selectedOrganisationId, // Lien avec l'organisation
          },
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );

        console.log("Groupe créé avec succès", response.data);
        this.closeGroupModal();
      } catch (error) {
        console.error("Erreur lors de la création du groupe", error);
      }
    },
  },
};
</script>

<style scoped>
/* Ajout de couleurs pour correspondre au parent */
.bg-gray-800 {
  background-color: #1c1c1c;
}
.text-yellow-400 {
  color: #fdcb12;
}
.bg-yellow-400 {
  background-color: #fdcb12;
}
.bg-yellow-500:hover {
  background-color: #f5b900;
}
</style>
