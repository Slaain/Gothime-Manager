<!-- src/components/OrganisationList.vue -->
<template>
  <div
    class="grid grid-cols-1 gap-6 organisation-list md:grid-cols-2 lg:grid-cols-3"
  >
    <OrganisationCard
      v-for="organisation in organisations"
      :key="organisation.id"
      :organisation="organisation"
      @modify-organisation="modifyOrganisation"
      @modify-users="modifyUsers"
      @view-users="$emit('view-users', organisation.id)"
    />
  </div>
</template>
  
  <script>
import OrganisationCard from "./OrganisationCard.vue";

export default {
  components: {
    OrganisationCard,
  },
  props: {
    organisations: {
      type: Array,
      required: true,
    },
  },
  methods: {
    modifyOrganisation(organisationId) {
      this.$emit("modify-organisation", organisationId);
    },
    viewGroup(groupId) {
      this.$emit("view-group", groupId);
    },
    modifyUsers(organisationId) {
      this.$emit("modify-users", organisationId);
    },
  },
};
</script>
  
  <style scoped>
.organisation-list {
  padding: 20px;
}
</style>
  