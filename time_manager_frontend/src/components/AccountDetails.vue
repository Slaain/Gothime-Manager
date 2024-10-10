<template>
    <div class="flex flex-col justify-center items-center bg-white min-h-[100vh]">
      <div
        class="mx-auto flex w-full mt-20 flex-col justify-center px-5 pt-0 md:h-[unset] max-w-[520px] lg:px-6 xl:pl-0"
      >
        <div class="relative flex w-full flex-col pt-[20px] md:pt-0">
          <div
            class="rounded-lg border border-gray-300 bg-white text-black shadow-md mb-5 h-min max-w-full pt-8 pb-6 px-6 dark:border-zinc-800"
          >
  
            <p class="text-xl font-extrabold text-zinc-950 md:text-3xl">
              Account Details
            </p>
            <p
              class="mb-6 mt-1 text-sm font-medium text-zinc-500 dark:text-zinc-400 md:mt-4 md:text-base"
            >
              Here you can change your account information
            </p>
  
            <!-- Name Input -->
            <label
              class="mb-3 flex px-2.5 font-bold leading-none text-zinc-950"
            >
              Your Name
              <p
                class="ml-1 mt-[1px] text-sm font-medium leading-none text-zinc-500"
              >
                (30 characters maximum)
              </p>
            </label>
            <div class="mb-8 flex flex-col md:flex-row">
              <input
                v-model="fullName"
                placeholder="Please enter your full name"
                class="mb-2 mr-4 flex h-full w-full items-center justify-center rounded-lg border-2 border-gray-400 bg-transparent px-4 py-4 text-zinc-950 shadow-sm outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
                type="text"
              />
            </div>
  
            <!-- Email Input -->
            <label
              class="mb-3 ml-2.5 flex px-2.5 font-bold leading-none text-zinc-950"
            >
              Your Email
            </label>
            <div class="mb-8 flex flex-col md:flex-row">
              <input
                v-model="email"
                placeholder="Please enter your email"
                class="mb-2 mr-4 flex h-full w-full items-center justify-center rounded-lg border-2 border-gray-400 bg-transparent px-4 py-4 text-zinc-950 shadow-sm outline-none focus:ring-2 focus:ring-blue-500 focus:border-blue-500 transition-all duration-200"
                type="text"
              />
              <button
                @click="Update"
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
  export default {
    data() {
      return {
        fullName: 'VBZ',
        email: 'vbz@gmail.com',
      };
    },
    methods: {
      updateName() {
        console.log(`Updated name to: ${this.fullName}`);
      },
      updateEmail() {
        console.log(`Updated email to: ${this.email}`);
      },
    }
  };
  </script>
  
  <style scoped>
  </style>
  