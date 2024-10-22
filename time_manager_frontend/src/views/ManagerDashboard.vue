<template>
  <div class="dashboard-container">
    <header class="dashboard-header">
      <h1>{{ managerName }}'s Organisation</h1>
    </header>

    <!-- Organisation Details -->
    <section class="organisation-details">
      <h2>Organisation: {{ organisationName }}</h2>
      <p>Groupes dans l'organisation :</p>
      <ul>
        <li v-for="group in groups" :key="group.id">
          {{ group.name }} - {{ group.description }}
        </li>
      </ul>
    </section>

    <!-- Groupes et utilisateurs -->
    <section class="group-users">
      <h2>Utilisateurs par groupe</h2>
      <div v-for="group in groups" :key="group.id" class="group-card">
        <h3>{{ group.name }}</h3>
        <ul>
          <li v-for="user in group.users" :key="user.id">
            {{ user.name }} - Heures travaillées : {{ user.workingTime }}
          </li>
        </ul>
      </div>
    </section>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      managerName: 'Nom du Manager',
      organisationName: '',
      groups: [], // Assurez-vous d'utiliser 'groups' au lieu de 'groupes'
    };
  },
  methods: {
    async fetchOrganisationData() {
      try {
        const orgId = this.$route.params.organisationId; 
        const response = await axios.get(`/api/organisations/${orgId}/details`); // Changez l'URL si nécessaire
        this.organisationName = response.data.organisation.name; // Ajustez selon la structure de la réponse
        this.groups = response.data.organisation.groups; // Inclure les utilisateurs dans chaque groupe
      } catch (error) {
        console.error('Erreur lors de la récupération des données :', error);
      }
    },
  },
  mounted() {
    this.fetchOrganisationData();
  },
};
</script>

<style scoped>
.dashboard-container {
  /* Styles pour la mise en page principale */
}
.organisation-details, .group-users {
  /* Styles pour chaque section */
}
.group-card {
  /* Styles pour les cartes des groupes */
}
</style>
