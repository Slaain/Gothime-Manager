<template>
    <div>
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-semibold">{{ group.name }}</h2>
        <button @click="$emit('close')" class="text-red-500">Close</button>
      </div>
  
      <div class="mt-4">
        <h3 class="text-lg font-semibold">Users</h3>
        <ul class="list-disc ml-6">
          <li v-for="user in group.users" :key="user.id">
            {{ user.name }} ({{ user.email }})
            <button class="text-sm text-red-600 hover:underline ml-2" @click="deleteUser(user.id)">Delete</button>
          </li>
        </ul>
      </div>
  
      <div class="flex justify-between items-center mt-6">
        <button @click="$emit('add-user')" class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
          Add User
        </button>
        <button @click="$emit('create-user')" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">
          Create User
        </button>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    props: {
      group: Object,
    },
    methods: {
      deleteUser(userId) {
        // Logique pour supprimer un utilisateur du groupe
        console.log(`Supprimer l'utilisateur avec l'ID ${userId}`);
      },
    },
  };
  </script>
  
  <style scoped>
  ul {
    padding-left: 1rem;
  }
  
  button {
    transition: background-color 0.2s ease;
  }
  </style>
  