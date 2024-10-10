<script setup>
import HelloWorld from './components/HelloWorld.vue'
import WorkingTimeShow from './components/WorkingTimeShow.vue';
import WorkingTimeActionContainer from './components/WorkingTimeActionContainer.vue'
</script>

<template>
  <header>

  </header>

  <main class="">
    <WorkingTimeActionContainer />
  </main>

  <div>
    <WorkingTimeShow :userId="user_id" />
  </div>
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

<script>
export default {
  components: {
    WorkingTimeShow
  },
  data() {
    return {
      user_id: 1 // Exemple, remplacez-le par l'ID de l'utilisateur que vous souhaitez
    };
  }
};
</script>
