<template>
  <header
    class="flex flex-row items-center justify-between w-full px-16 py-4 text-white"
  >
    <div>
      <p class="text-2xl bold">Goth'time Manager</p>
    </div>

    <nav>
      <ul class="flex items-center justify-between gap-x-8">
        <li class="cursor-pointer hover:underline">
          <router-link to="/">How It Works</router-link>
        </li>
        <li class="cursor-pointer hover:underline">
          <router-link to="/working-times">Features</router-link>
        </li>
        <li class="cursor-pointer hover:underline">
          <router-link to="/users">About</router-link>
        </li>
      </ul>
    </nav>

    <div class="flex gap-4">
      <router-link
        class="flex items-center justify-center px-6 py-2 text-black bg-white border-2 rounded cursor-pointer border-primaryYellow hover:bg-neutral-100"
        to="/login"
        >Sign In</router-link
      >
      <router-link
        class="flex items-center justify-center px-6 py-2 text-black border-2 rounded cursor-pointer border-primaryYellow bg-primaryYellow hover:bg-primaryYellow400"
        to="/register"
        >Sign Up</router-link
      >
    </div>
  </header>
</template>