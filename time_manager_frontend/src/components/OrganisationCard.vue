<template>
    <div class="organisation-card bg-white p-4 shadow-md rounded-lg">
      <h3 class="text-xl font-bold mb-2">{{ organisation.name }}</h3>
      <p class="font-semibold mb-2">Groups:</p>
      <ul class="mb-4">
        <li v-for="group in organisation.groups" :key="group.id" class="flex justify-between">
          <span>{{ group.name }}</span>
          <button class="text-blue-500" @click="$emit('view-group', group)">View</button>
        </li>
      </ul>
  
      <button class="bg-blue-500 text-white py-1 px-3 rounded mb-2" @click="$emit('add-user', organisation)">
        Add User
      </button>
      <button class="bg-green-500 text-white py-1 px-3 rounded mb-2" @click="$emit('create-user', organisation)">
        Create User
      </button>
      <button class="bg-yellow-500 text-white py-1 px-3 rounded" @click="$emit('manage-groups', organisation)">
        Manage Groups
      </button>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      organisation: {
        type: Object,
        required: true,
      },
    },
  };
  </script>
  
  <style scoped>
  .organisation-card {
    max-width: 300px;
    margin-bottom: 20px;
  }
  </style>
  