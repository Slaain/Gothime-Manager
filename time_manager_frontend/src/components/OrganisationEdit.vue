<!-- OrganisationEdit.vue -->
<template>
    <div class="modal-overlay" v-if="show">
      <div class="modal">
        <h2 class="text-lg font-semibold mb-4">Modifier l'Organisation</h2>
        <form @submit.prevent="submitForm">
          <div class="mb-4">
            <label for="organisation-name" class="block text-sm font-medium">Nom de l'organisation</label>
            <input
              id="organisation-name"
              v-model="organisationName"
              type="text"
              class="input-field mt-2 p-2 border border-gray-300 rounded w-full"
              required
            />
          </div>
          <div class="flex justify-end space-x-4">
            <button @click="closeModal" type="button" class="btn btn-secondary">Annuler</button>
            <button type="submit" class="btn btn-primary">Sauvegarder</button>
          </div>
        </form>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      show: {
        type: Boolean,
        required: true,
      },
      organisation: {
        type: Object,
        required: true,
      },
    },
    data() {
      return {
        organisationName: this.organisation.name, // Initialise avec le nom actuel de l'organisation
      };
    },
    methods: {
      closeModal() {
        this.$emit('close');
      },
      submitForm() {
        this.$emit('save', { id: this.organisation.id, name: this.organisationName });
        this.closeModal(); // Ferme la modale après la sauvegarde
      },
    },
  };
  </script>
  
  <style scoped>
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 50;
  }
  
  .modal {
    background: white;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
    width: 300px;
  }
  
  .input-field {
    border: 1px solid #ccc;
    padding: 10px;
    border-radius: 4px;
    width: 100%;
  }
  
  .btn {
    padding: 0.5em 1em;
    border-radius: 5px;
    transition: background-color 0.3s;
  }
  
  .btn-primary {
    background-color: #fdcb12;
    color: black;
  }
  
  .btn-primary:hover {
    background-color: #f5b900;
  }
  
  .btn-secondary {
    background-color: #6c757d;
    color: white;
  }
  
  .btn-secondary:hover {
    background-color: #5a6268;
  }
  </style>
  