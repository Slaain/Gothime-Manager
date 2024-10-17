<template>
  <div class="manager-dashboard">
    <h1>Manager Dashboard</h1>
    <p>Bienvenue sur le tableau de bord Manager.</p>
    <WorkingTimesChart /> <!-- Exemple de composant affichant des statistiques de travail -->
  </div>
</template>

<script>
import WorkingTimesChart from '@/components/WorkingTimesChart.vue';

export default {
  name: 'ManagerDashboard',
  components: {
    WorkingTimesChart
  }
};
</script>

<style scoped>
.manager-dashboard {
  padding: 20px;
}
</style>
