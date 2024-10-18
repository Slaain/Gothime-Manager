<template>
    <div>
      <h1>Organisations</h1>
      <ul>
        <li v-for="organisation in organisations" :key="organisation.id">
          <router-link :to="`/organisations/${organisation.id}`">
            {{ organisation.name }}
          </router-link>
        </li>
      </ul>
    </div>
  </template>
  
  <script>
  import axios from 'axios';
  
  export default {
    data() {
      return {
        organisations: [],
      };
    },
    mounted() {
      this.fetchOrganisations();
    },
    methods: {
      async fetchOrganisations() {
        try {
          const response = await axios.get('/api/organisations');
          this.organisations = response.data;
        } catch (error) {
          console.error('Erreur lors de la récupération des organisations', error);
        }
      },
    },
  };
  </script>
  