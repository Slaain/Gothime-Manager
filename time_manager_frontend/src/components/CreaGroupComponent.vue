<template>
  <div class="max-w-[720px] mx-auto bg-transparent">
    <div
        class="relative flex flex-col w-full h-full bg-gray-800 text-white shadow-md rounded-xl px-6 py-5 mt-4"
    >
      <!-- Liste des groupes -->
      <div class="flex justify-between items-center">
        <h3 class="text-lg font-semibold text-yellow-400">Work Groups</h3>
        <button
            @click="openGroupModal"
            class="flex items-center gap-2 bg-yellow-400 py-2.5 px-4 text-xs font-semibold text-black rounded-md hover:bg-yellow-500"
        >
          <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" viewBox="0 0 24 24" class="w-4 h-4">
            <path d="M12 4v16m8-8H4" stroke-width="2" stroke="currentColor" fill="none" />
          </svg>
          Add Work Group
        </button>
      </div>

      <!-- Formulaire de création de groupe -->
      <div v-if="showGroupModal" class="mt-4">
        <label class="block text-sm font-bold mt-2">Group Name</label>
        <input v-model="newGroup.name" type="text" class="w-full p-2 border border-gray-300 rounded bg-gray-600 text-white" />
        <label class="block text-sm font-bold mt-2">Start Date and Time</label>
        <input v-model="newGroup.start_date" type="datetime-local" class="w-full p-2 border border-gray-300 rounded bg-gray-600 text-white" />
        <label class="block text-sm font-bold mt-2">End Date and Time</label>
        <input v-model="newGroup.end_date" type="datetime-local" class="w-full p-2 border border-gray-300 rounded bg-gray-600 text-white" />
        <div class="flex justify-end gap-4 mt-4">
          <button @click="createGroup" class="bg-yellow-400 text-black px-4 py-2 rounded hover:bg-yellow-500">Create</button>
          <button @click="closeGroupModal" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Cancel</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      showGroupModal: false,
      newGroup: {
        name: "",
        start_date: "",
        end_date: "",
      },
    };
  },
  methods: {
    openGroupModal() {
      this.showGroupModal = true;
    },
    closeGroupModal() {
      this.showGroupModal = false;
    },
    createGroup() {
      // Logique de création de groupe (à implémenter)
      this.closeGroupModal();
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
