<template>
  <div id="app">
    <router-view /> <!-- Cela affichera AdminDashboard ou d'autres pages selon la route -->
  </div>
</template>

<script>
export default {
  name: 'App'
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  text-align: center;
  color: #2c3e50;
}
</style>
