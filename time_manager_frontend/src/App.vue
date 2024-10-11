<template>
  <header>
    <!-- Ajoutez du contenu pour l'en-tête si nécessaire -->
  </header>

  <main>
    <WorkingTimeActionContainer />
    <AccountDetails 
      v-if="selectedEmployeeId" 
      :selectedEmployeeId="selectedEmployeeId" 
      @user-updated="onUserUpdated" 
    /> 
    <UserList 
      :key="userListKey"
      :employees="userData" 
      @show-account-details="setSelectedEmployeeId" 
    />
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
const selectedEmployeeId = ref(null);
const userListKey = ref(0);  // Clé pour rafraîchir UserList

const setSelectedEmployeeId = (employeeId) => {
  selectedEmployeeId.value = employeeId;
  console.log(`Selected employee ID: ${employeeId}`);
};

const onUserUpdated = () => {
  // Incrémente la clé pour forcer le rafraîchissement du composant UserList
  userListKey.value += 1;
  fetchEmployees(); // Récupérer à nouveau les employés après la mise à jour
};

const fetchEmployees = () => {
  userService.getUser(userID.value)
    .then(user => {
      console.log('User data:', user);
      userData.value = user.employees || [];
    })
    .catch(error => {
      console.error('Erreur lors de la récupération des employés:', error);
    });
};

onMounted(() => {
  fetchEmployees();
});
</script>
