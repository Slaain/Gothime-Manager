<template>
  <div class="flex flex-col justify-center items-center bg-white min-h-[100vh]">
    <div
      class="mx-auto flex w-full mt-20 flex-col justify-center px-5 pt-0 md:h-[unset] max-w-[520px] lg:px-6 xl:pl-0"
    >
      <div class="relative flex w-full flex-col pt-[20px] md:pt-0">
        <div
          class="max-w-full px-6 pt-8 pb-6 mb-5 text-black bg-white border border-gray-300 rounded-lg shadow-md h-min dark:border-zinc-800"
        >
          <p class="text-xl font-extrabold text-zinc-950 md:text-3xl">
            Account Details
          </p>
          <p
            class="mt-1 mb-6 text-sm font-medium text-zinc-500 dark:text-zinc-400 md:mt-4 md:text-base"
          >
            Here you can change your account information
          </p>

          <!-- Name Input -->
          <label class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950">
            Your Name
            <p
              class="ml-1 mt-[1px] text-sm font-medium leading-none text-zinc-500"
            >
              (30 characters maximum)
            </p>
          </label>
          <div class="flex flex-col mb-8 md:flex-row">
            <input
              v-model="username"
              placeholder="Please enter your full name"
              class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 mr-4 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              type="text"
            />
          </div>

          <!-- Email Input -->
          <label
            class="mb-3 ml-2.5 flex px-2.5 font-bold leading-none text-zinc-950"
            >Your Email</label
          >
          <div class="flex flex-col mb-8 md:flex-row">
            <input
              v-model="email"
              placeholder="Please enter your email"
              class="flex items-center justify-center w-full h-full px-4 py-4 mb-2 mr-4 transition-all duration-200 bg-transparent border-2 border-gray-400 rounded-lg shadow-sm outline-none text-zinc-950 focus:ring-2 focus:ring-blue-500 focus:border-blue-500"
              type="text"
            />
            <button
              @click="updateEmail"
              class="whitespace-nowrap ring-offset-background transition-colors bg-blue-500 hover:bg-blue-600 text-white flex h-full max-h-full w-full items-center justify-center rounded-lg px-4 py-4 text-base md:ms-4 font-medium md:w-[300px] shadow-lg hover:shadow-xl transition-shadow duration-200"
            >
              Update
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
    
  <script>
import userService from "../userService";

export default {
  props: {
    selectedEmployeeId: {
      type: Number,
      required: true,
    },
  },
  data() {
    return {
      username: "",
      email: "",
    };
  },
  watch: {
    selectedEmployeeId: {
      immediate: true,
      handler(newId) {
        if (newId) {
          this.fetchUserDetails(newId);
        }
      },
    },
  },
  methods: {
    fetchUserDetails(userID) {
      console.log(userID);
      userService
        .getUser(userID)
        .then((user) => {
          console.log("User data retrieved:", user);
          this.username = user.data.username;
          this.email = user.data.email;
        })
        .catch((error) => {
          console.error(
            "Erreur lors de la récupération des informations de l'utilisateur:",
            error
          );
        });
    },
    updateEmail() {
      const userData = {
        email: this.email,
        username: this.username,
      };

      userService
        .updateUser(this.selectedEmployeeId, userData)
        .then((response) => {
          console.log("User updated successfully:", response);
          this.$emit("user-updated");
          id: this.selectedEmployeeId; // Émettre l'événement après la mise à jour
        })
        .catch((error) => {
          console.error(
            "Erreur lors de la mise à jour de l'utilisateur:",
            error
          );
        });
    },
  },
};
</script>
    
  <style scoped>
</style>
  