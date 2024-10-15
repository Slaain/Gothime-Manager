<template>
  <header></header>
  <main>
    <!-- Pass the userID and listen for updates -->
    <UserList
      :key="userListKey"
      :employees="userData"
      :userID="userID"
      @updateUserId="updateUserId"
    />

    <!-- Pass the selected user ID to other child components -->
    <!-- <WorkingTimeActionContainer :user-id="userID" /> -->
    <WorkingTimesUsersContainer :userID="userID" />
    <!-- <Test :testValue="userID" /> -->
  </main>
</template>

<script setup>
import { ref, onMounted } from "vue";
import UserList from "./components/UserList.vue";
import WorkingTimeActionContainer from "./components/WorkingTimeActionContainer.vue";
import WorkingTimesUsersContainer from "./components/WorkingTimesUsersContainer.vue";
import Test from "./components/Test.vue";
import userService from "./userService";

// Define the user ID to pass to children
const userID = ref(null); // Will be updated by the UserList selection
const userData = ref([]); // List of users
const userListKey = ref(0); // To trigger re-rendering when user data changes

// Method to handle updating the selected user ID from UserList
const updateUserId = (newId) => {
  userID.value = newId;
  console.log(`Updated userID in parent: ${userID.value}`);
};

// Fetch user data from API
const fetchEmployees = () => {
  userService
    .getUsers()
    .then((response) => {
      userData.value = response.data || [];
    })
    .catch((error) => {
      console.error("Error fetching employees:", error);
    });
};

onMounted(() => {
  fetchEmployees();
});
</script>
