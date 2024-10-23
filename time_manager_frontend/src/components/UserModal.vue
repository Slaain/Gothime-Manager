<!-- UserModal.vue -->
<template>
    <div class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center">
      <div class="bg-white p-6 rounded-lg shadow-md">
        <h2 class="text-lg font-semibold mb-4">Add User to {{ organisation.name }}</h2>
  
        <!-- Sélection d'un utilisateur -->
        <form @submit.prevent="submit">
          <label for="userSelect" class="block mb-2">Select User</label>
          <select v-model="selectedUser" class="w-full mb-4 p-2 border rounded">
            <option v-for="user in users" :key="user.id" :value="user.id">{{ user.username }}</option>
          </select>
  
          <div class="flex justify-end gap-4">
            <button type="submit" class="bg-blue-500 text-white px-4 py-2 rounded">Add User</button>
            <button @click="$emit('close')" class="bg-red-500 text-white px-4 py-2 rounded">Cancel</button>
          </div>
        </form>
      </div>
    </div>
  </template>
  
  <script>
  import userService from '../userService';
  
  export default {
    props: {
      organisation: Object,
    },
    data() {
      return {
        users: [],
        selectedUser: null,
      };
    },
    created() {
      this.fetchUsers();
    },
    methods: {
      fetchUsers() {
        userService.getAllUsers().then(response => {
          this.users = response.data.users;
        });
      },
      submit() {
        if (this.selectedUser) {
          this.$emit('add-user', this.selectedUser);
        }
      },
    },
  };
  </script>
  
  <style scoped>
  </style>
  