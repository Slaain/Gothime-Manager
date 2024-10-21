<template>
  <div class="manager-dashboard">
    <h1>Manager Dashboar for {{ organizationName }}</h1>
    <p>Bienvenue sur le tableau de bord de l'organisation {{ organizationName }}.</p>
    <WorkingTimesChart /> <!-- Exemple de composant affichant des statistiques de travail -->
  
  <div v-for="employee in employees" :key="employee.id">
    <p>{{ employee.name }} - Heures travaillées : {{ employee.workingHours }}</p>
  </div>
</div>
</template>

<script>
import WorkingTimesChart from '@/components/WorkingTimesChart.vue';

export default {
  props: ['organizationId'],
  data() {
    return {
      organizationName: '',
      employees: [],
    };
  },
  mounted() {
    this.getOrganizationData();
  },
  methods: {
    async getOrganizationData() {
      try {
        const response = await axios.get(`http://localhost:4000/api/organizations/${this.organizationId}`);
        this.organizationName = response.data.name;
        this.employees = response.data.employees;
      } catch (error) {
        console.error("Erreur lors de la récupération des données de l'organisation", error);
      }
    }
  }
};
</script>

<style scoped>
.manager-dashboard {
  padding: 20px;
}
</style>
