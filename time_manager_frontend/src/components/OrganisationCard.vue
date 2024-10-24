<template>
  <div class="organisation-card glassmorphism-bg-white p-6 shadow-md rounded-xl" @click="cancelEdit">
    <div class="header flex justify-between items-center mb-4" @click.stop>
      <!-- Affichage du nom de l'organisation ou champ d'édition -->
      <h2 v-if="!isEditing" class="text-xl font-semibold text-white">{{ organisation.name }}</h2>
      <div v-if="isEditing" class="flex items-center">
        <input
          v-model="organisationName"
          @keyup.enter="saveOrganisationName"
          @blur="toggleEdit"
          class="input-field text-xl font-semibold"
          type="text"
        />
        <!-- Bouton de coche pour sauvegarder -->
        <button @click="saveOrganisationName" class="btn-save ml-2">
          <i class="fas fa-check"></i>
        </button>
      </div>
      <!-- Bouton avec icône de stylo pour l'édition -->
      <button @click="toggleEdit" class="btn-edit" v-if="!isEditing">
        <i class="fas fa-pencil-alt"></i> <!-- Icône de stylo -->
      </button>
    </div>

    <div class="groups-container overflow-y-auto mb-4">
      <h3 class="font-medium text-white">List Groups:</h3>
      <ul>
        <li v-for="group in groups" :key="group.id" class="flex justify-between items-center mb-2 text-white">
          {{ group.groupname }}
          <button @click="viewGroup(group)" class="btn btn-secondary ml-4">Voir</button>
        </li>
      </ul>
    </div>

    <button @click="viewUsers" class="btn btn-secondary mt-2">Voir Users</button>
  </div>
</template>

<script>
import axios from "axios";
import { useToast } from "vue-toastification";

export default {
  props: {
    organisation: {
      type: Object,
      required: true,
    },
  },
  setup() {
    const toast = useToast(); // Utiliser le toast via setup
    return { toast };
  },
  data() {
    return {
      groups: [],
      isEditing: false, // Gérer l'état d'édition du nom
      organisationName: this.organisation.name, // Initialise avec le nom actuel de l'organisation
    };
  },
  mounted() {
    this.fetchGroups();
  },
  methods: {
    async fetchGroups() {
      try {
        const response = await axios.get(
          `http://localhost:4000/api/organisations/${this.organisation.id}`
        );
        this.groups = response.data.data.groups;
      } catch (error) {
        console.error("Erreur lors de la récupération des groupes:", error);
      }
    },
    viewGroup(group) {
      this.$emit("view-group", group.id);
    },
    viewUsers() {
      this.$emit("view-users", this.organisation.id);
    },
    toggleEdit() {
      if (!this.isEditing) {
        this.isEditing = true; // Activer le mode édition
      }
    },
    cancelEdit() {
      if (this.isEditing) {
        this.isEditing = false; // Désactiver le mode édition
        this.organisationName = this.organisation.name; // Réinitialiser le nom si non sauvegardé
      }
    },
    async saveOrganisationName() {
      try {
        await axios.put(`http://localhost:4000/api/organisations/${this.organisation.id}`, {
          organisation: { name: this.organisationName },
        });

        // Affiche un toast de succès après la mise à jour
        this.toast.success("Organisation's name updated successfully!");

        this.$emit('organisation-updated');

        this.isEditing = false; // Revenir à l'affichage normal après la sauvegarde
      } catch (error) {
        // Affiche un toast d'erreur en cas de problème
        this.toast.error("Error updating the organisation's name.");
        console.error("Erreur lors de la mise à jour du nom de l'organisation:", error);
      }
    }
  },
};
</script>

<style scoped>
/* Taille fixe de la carte */
.organisation-card {
  width: 320px; /* Agrandir un peu la carte */
  height: 400px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

.glassmorphism-bg-white {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  overflow: hidden;
  position: relative;
  color: white;
}

.header h2 {
  color: #fdcb12;
}

/* Bouton d'édition avec icône */
.btn-edit {
  background: none;
  border: none;
  cursor: pointer;
  color: #fdcb12;
  margin-left: 10px; /* Espace entre le nom et l'icône */
}

.btn-edit:hover {
  color: #f5b900;
}

/* Bouton de coche pour sauvegarder */
.btn-save {
  background: none;
  border: none;
  cursor: pointer;
  color: #00ff00;
}

.btn-save:hover {
  color: #00cc00;
}

/* Champ d'édition plus petit et adapté à la carte */
.input-field {
  background-color: rgba(255, 255, 255, 0.1);
  border: 1px solid #fdcb12;
  color: #fdcb12;
  padding: 0.2em;
  border-radius: 4px;
  outline: none;
  width: 180px; /* Agrandir légèrement */
}

/* Liste des groupes avec une scrollbar stylisée */
.groups-container {
  overflow-y: auto;
  max-height: 175px;
  flex-grow: 1;
  margin-bottom: 10px;
}

.groups-container::-webkit-scrollbar {
  width: 6px;
}

.groups-container::-webkit-scrollbar-thumb {
  background-color: #000;
  border-radius: 10px;
}

.groups-container::-webkit-scrollbar-track {
  background: transparent;
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
