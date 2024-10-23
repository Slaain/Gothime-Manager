<template>
  <div class="organisation-card glassmorphism-bg-white p-6 shadow-md rounded-xl">
    <div class="header flex justify-between items-center mb-4">
      <h2 class="text-xl font-semibold text-white">{{ organisation.name }}</h2>
      <button @click="modifyOrganisation" class="btn btn-primary">Modifier</button>
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

export default {
  props: {
    organisation: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      groups: [],
    };
  },
  mounted() {
    this.fetchGroups();
  },
  methods: {
    modifyOrganisation() {
      this.$emit("modify-organisation", this.organisation.id);
    },
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
      console.log("Voir Users pour l'organisation :", this.organisation.id);
      this.$emit("view-users", this.organisation.id); // Émettre l'événement pour ouvrir la modale
    }

  },
};
</script>



<style scoped>
/* Taille fixe de la carte */
.organisation-card {
  width: 300px;  /* Largeur fixe */
  height: 400px; /* Hauteur fixe */
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

/* Glassmorphism pour correspondre au design global */
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

.glassmorphism-bg-white::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 2px;
  border-radius: 10px;
  background: linear-gradient(
    to bottom right,
    #ffffff,
    rgba(255, 255, 255, 0.2),
    #fdcb12
  );
  opacity: 0.3;
  pointer-events: none;
}

.header h2 {
  color: #fdcb12;
}

/* Liste des groupes avec une scrollbar stylisée */
.groups-container {
  overflow-y: auto;
  max-height: 175px; /* Hauteur maximale de la liste des groupes */
  flex-grow: 1;
  margin-bottom: 10px;
}

.groups-container::-webkit-scrollbar {
  width: 6px;
}

.groups-container::-webkit-scrollbar-thumb {
  background-color: #000; /* Couleur noire pour la scrollbar */
  border-radius: 10px; /* Bordure arrondie pour la scrollbar */
}

.groups-container::-webkit-scrollbar-track {
  background: transparent; /* Couleur transparente pour l'arrière-plan de la scrollbar */
}

/* Styles des boutons */
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
