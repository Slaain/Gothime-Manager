<template>
  <header>
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
const userListKey = ref(0);

const setSelectedEmployeeId = (employeeId) => {
  selectedEmployeeId.value = employeeId;
  console.log(`Selected employee ID: ${employeeId}`);
};

const onUserUpdated = () => {
  userListKey.value += 1;
  fetchEmployees();
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
