<!-- src/components/OrganisationList.vue -->
<template>
    <div class="organisation-list grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
      <OrganisationCard
        v-for="organisation in organisations"
        :key="organisation.id"
        :organisation="organisation"
        @modify-organisation="modifyOrganisation"
        @modify-users="modifyUsers"
        @organisation-updated="handleOrganisationUpdated"
        @view-users="$emit('view-users', organisation.id)" 
        @delete-organisation="handleDeleteOrganisation"


      />
    </div>
  </template>
  
  <script>
  import OrganisationCard from './OrganisationCard.vue';
  
  export default {
    components: {
      OrganisationCard
    },
    props: {
      organisations: {
        type: Array,
        required: true
      }
    },
    methods: {
      modifyOrganisation(organisationId) {
        this.$emit('modify-organisation', organisationId);
      },

      handleDeleteOrganisation(){
        this.$emit('delete-organisation');
      },

      handleOrganisationUpdated() {
        // Émettre un événement pour que le composant parent (Organisation.vue) puisse réagir
        this.$emit('organisation-updated');
      },

      viewGroup(groupId) {
        this.$emit('view-group', groupId);
      },
      modifyUsers(organisationId) {
        this.$emit('modify-users', organisationId);
      }
    }
  }
  </script>
  
  <style scoped>
  .organisation-list {
    padding: 20px;
  }
  </style>
  