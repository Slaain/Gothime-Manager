<template>
    <div
      class="fixed inset-0 z-50 flex items-center justify-center w-full h-full overflow-y-auto bg-gray-800 bg-opacity-50"
    >
      <div class="w-1/2 px-8 py-4 bg-white rounded-lg">
        <p class="text-xl font-extrabold text-zinc-950">Update User</p>
        <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">
          User's Name
          <p class="ml-1 mt-[1px] text-sm font-medium leading-none text-zinc-500">
            (30 characters maximum)
          </p>
        </label>
        <input
          v-model="userCopy.username"
          placeholder="Please enter your full name"
          class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          type="text"
        />
        <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950"
          >User's Email</label
        >
        <input
          v-model="userCopy.email"
          placeholder="Please enter your email"
          class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
          type="text"
        />
        <p class="h-6 text-red-600">{{ error }}</p>
        <button
          @click="updateUser"
          class="w-full py-2 mt-4 text-black transition-all rounded-lg bg-primaryYellow hover:bg-primaryYellow400"
        >
          Update
        </button>
        <button
          @click="$emit('close')"
          class="w-full py-2 mt-2 text-black transition-all bg-white border rounded-lg border-primaryYellow hover:bg-neutral-100"
        >
          Cancel
        </button>
      </div>
    </div>
  </template>
  
  <script>
  import axios from "axios";
  
  export default {
    props: {
      user: {
        type: Object,
        required: true,
      },
    },
    data() {
      return {
        userCopy: { ...this.user },
        error: "",
      };
    },
    methods: {
      async updateUser() {
        try {
          await axios.put(
            `http://localhost:4000/api/users/${this.userCopy.id}`,
            this.userCopy,
            {
              headers: {
                Authorization: `Bearer ${localStorage.getItem("authToken")}`,
                "Content-Type": "application/json",
              },
            }
          );
          this.$emit("save");
          this.$emit("close");
        } catch (error) {
          console.error("Erreur lors de la mise à jour de l'utilisateur:", error);
          this.error = error.response.data.message || "Failed to update user.";
        }
      },
    },
  };
  </script>
  
  <style scoped>
  /* Ajoutez vos styles ici si nécessaire */
  </style>
  