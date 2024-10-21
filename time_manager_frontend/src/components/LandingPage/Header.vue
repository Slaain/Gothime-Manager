<template>
  <header
    class="flex flex-row items-center justify-between w-full px-16 py-4 text-white"
  >
    <div>
      <router-link to="/" class="text-2xl bold">Goth'time Manager</router-link>
    </div>

    <nav>
      <ul class="flex items-center justify-between gap-x-8">
        <li class="cursor-pointer hover:underline">
          <a href="#features">Features</a>
        </li>
        <li class="cursor-pointer hover:underline">
          <a href="#how_it_works">How It Works</a>
        </li>
        <li class="cursor-pointer hover:underline">
          <a href="#pricing">Pricing</a>
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