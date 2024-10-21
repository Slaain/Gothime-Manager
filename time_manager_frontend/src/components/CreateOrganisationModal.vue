<template>
    <div class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
      <div class="mx-auto w-full max-w-lg rounded-lg border border-gray-300 bg-white shadow-md p-6">
        <h2 class="text-2xl font-extrabold text-zinc-950 mb-4">New Organisation</h2>
        <p class="mb-6 text-sm font-medium text-zinc-500">
          Enter the details to create a new organisation.
        </p>
  
        <!-- Organisation Name Input -->
        <label class="mb-3 block font-bold text-zinc-950">
          Organisation Name
          <p class="ml-1 mt-1 text-sm font-medium text-zinc-500">(30 characters maximum)</p>
        </label>
        <div class="mb-8">
          <input
            v-model="organisationName"
            placeholder="Enter organisation name"
            class="w-full rounded-lg border-2 border-gray-400 bg-transparent px-4 py-4 text-zinc-950 shadow-sm outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
            type="text"
          />
        </div>
  
        <!-- Submit Button -->
        <div class="flex justify-end">
          <button
            @click="createOrganisation"
            class="bg-blue-500 hover:bg-blue-600 text-white font-semibold px-6 py-3 rounded-lg shadow-lg transition duration-200"
          >
            Create Organisation
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        organisationName: ''
      };
    },
    methods: {
      createOrganisation() {
        // Crée un payload pour envoyer les informations de l'organisation
        const organisationData = {
          name: this.organisationName,
        };
  
        // Ici, vous pouvez ajouter une logique pour envoyer les données au backend.
        this.$emit('create-organisation', organisationData);
      }
    }
  };
  </script>
  
  <style scoped>
  /* Ajout d'un fond semi-transparent pour la modale */
  .bg-opacity-50 {
    background-color: rgba(0, 0, 0, 0.5);
  }
  </style>
  