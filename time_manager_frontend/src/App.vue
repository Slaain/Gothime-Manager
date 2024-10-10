<script setup>
import { ref, onMounted } from 'vue';
import AccountDetails from './components/AccountDetails.vue';
import WorkingTimeActionContainer from './components/WorkingTimeActionContainer.vue';
import userService from './userService';

const userID = ref(6); // Initialise userID à 6

onMounted(() => {
  userService.getUser(userID.value)
    .then(user => {
      console.log('User data:', user);
    })
    .catch(error => {
      console.error('Erreur lors de la récupération de l\'utilisateur:', error);
    });
});
</script>

<template>
  <header>

  </header>

  <main>
    <WorkingTimeActionContainer />
    <AccountDetails :userID="userID" />
  </main>
</template>

<style scoped>
header {
  line-height: 1.5;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }
}
</style>
