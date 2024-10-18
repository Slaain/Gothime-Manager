<template>
  <div>
    <h1 class="text-3xl font-bold mb-6">List of Organisations</h1>
    <div v-if="organisations.length">
      <h2 class="text-xl font-bold">Organisations</h2>
      <ul>
        <li v-for="organisation in organisations" :key="organisation.id" @click="selectOrganisation(organisation)">
          <button class="text-lg text-blue-600 underline">{{ organisation.name }}</button>
        </li>
      </ul>
    </div>
    <div v-if="selectedOrganisation">
      <h2 class="text-xl font-bold mt-6">Groups in {{ selectedOrganisation.name }}</h2>
      <ul>
        <li v-for="group in selectedOrganisation.groups" :key="group.id" @click="selectGroup(group)">
          <button class="text-lg text-green-600 underline">{{ group.name }}</button>
        </li>
      </ul>
    </div>
    <div v-if="selectedGroup">
      <h2 class="text-xl font-bold mt-6">Users in {{ selectedGroup.name }}</h2>
      <ul>
        <li v-for="user in selectedGroup.users" :key="user.id">{{ user.username }}</li>
      </ul>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      organisations: [],
      selectedOrganisation: null,
      selectedGroup: null,
    };
  },
  methods: {
    async fetchOrganisations() {
      try {
        const response = await axios.get('/api/organisations');
        this.organisations = response.data;
      } catch (error) {
        console.error('Error fetching organisations:', error);
      }
    },
    selectOrganisation(organisation) {
      this.selectedOrganisation = organisation;
      this.selectedGroup = null; // Reset the group when a new organisation is selected
    },
    selectGroup(group) {
      this.selectedGroup = group;
    },
  },
  mounted() {
    this.fetchOrganisations();
  },
};
</script>

<style scoped>
/* Styles pour l'organisation */
</style>
