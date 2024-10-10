<template>
  <header>
    <!-- Ajoutez du contenu pour l'en-tête si nécessaire -->
  </header>

  <main>
    <WorkingTimeActionContainer />
    <AccountDetails v-if="selectedEmployeeId" :selectedEmployeeId="selectedEmployeeId" /> <!-- Mise à jour ici -->
    <UserList :employees="userData" @show-account-details="setSelectedEmployeeId" />
  </main>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import AccountDetails from './components/AccountDetails.vue';
import WorkingTimeActionContainer from './components/WorkingTimeActionContainer.vue';
import UserList from './components/UserList.vue';
import userService from './userService';

const userID = ref(6); 
const userData = ref([]);
const selectedEmployeeId = ref(null); // Variable pour stocker l'ID de l'employé sélectionné

const setSelectedEmployeeId = (employeeId) => {
  selectedEmployeeId.value = employeeId; // Met à jour l'ID de l'employé sélectionné
  console.log(`Selected employee ID: ${employeeId}`);
};

onMounted(() => {
  userService.getUser(userID.value)
    .then(user => {
      console.log('User data:', user);
      userData.value = user.employees || [];
    })
    .catch(error => {
      console.error('Erreur lors de la récupération de l\'utilisateur:', error);
    });
});
</script>
