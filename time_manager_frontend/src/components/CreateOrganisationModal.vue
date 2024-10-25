<template>
  <div class="modal-overlay">
    <div class="modal">
      <h2 class="mb-4 text-lg font-semibold">Create a New Organisation</h2>
      <form @submit.prevent="createOrganisation">
        <div class="mb-4">
          <label for="organisation-name" class="block text-sm font-medium"
            >Organisation Name</label
          >
          <input
            id="organisation-name"
            v-model="organisationName"
            type="text"
            class="w-full p-2 mt-2 border border-gray-300 rounded input-field"
            required
          />
        </div>
        <div class="flex justify-end space-x-4">
          <button @click="closeModal" type="button" class="btn btn-secondary">
            Cancel
          </button>
          <button type="submit" class="btn btn-primary">Create</button>
        </div>
      </form>
    </div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  data() {
    return {
      organisationName: "", // Nom de la nouvelle organisation
    };
  },
  methods: {
    closeModal() {
      console.log("close-modal");
      this.$emit("close-modal"); // Émettre un événement pour fermer la modale
    },
    async createOrganisation() {
      try {
        await axios.post(
          "http://localhost:4000/api/organisations",
          {
            organisation: { name: this.organisationName },
          },
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.$emit("organisation-created"); // Émettre un événement pour signaler la création
        this.closeModal(); // Fermer la modale après la création
        this.closeModal();
      } catch (error) {
        console.error("Erreur lors de la création de l'organisation:", error);
      }
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
