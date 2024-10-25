<template>
  <div class="relative w-full">
    <!-- Input de recherche -->
    <input
      type="text"
      v-model="searchTerm"
      placeholder="Search..."
      @focus="toggleDropdown(true)"
      @blur="toggleDropdown(false)"
      @input="filterOptions"
      class="w-full px-4 py-2 border border-black rounded-md focus:outline-none"
    />

    <!-- Dropdown -->
    <ul
      v-if="showDropdown"
      class="absolute z-10 w-full mt-1 overflow-auto bg-white border border-gray-300 rounded-md shadow-lg max-h-60"
    >
      <li
        v-for="(option, index) in filteredOptions"
        :key="index"
        @mousedown.prevent="selectOption(option)"
        class="px-4 py-2 cursor-pointer hover:bg-gray-100"
      >
        {{ option.username }}
      </li>
    </ul>
  </div>
</template>

<script>
import axios from "axios";
export default {
  data() {
    return {
      // Liste des options du dropdown
      options: [],

      // Option sélectionnée
      selectedOption: null,

      // Terme de recherche saisi par l'utilisateur
      searchTerm: "",

      // Variable pour montrer ou cacher le dropdown
      showDropdown: false,

      // Liste des options filtrées
      filteredOptions: [],
    };
  },
  mounted() {
    this.getOptions();
  },
  methods: {
    // Filtrer les options en fonction du terme de recherche
    filterOptions() {
      const term = this.searchTerm.toLowerCase();
      this.filteredOptions = this.options.filter((option) =>
        option.username.toLowerCase().includes(term)
      );
    },
    // Obtenir la liste des utilisateurs depuis l'API
    getOptions() {
      axios
        .get("http://localhost:4000/api/users/all", {
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${localStorage.getItem("authToken")}`,
          },
        })
        .then((response) => {
          console.log("options : ", response.data.data);
          this.options = response.data.data;
          this.filteredOptions = this.options; // Initialise les options filtrées
        })
        .catch((error) => {
          console.error(error);
        });
    },

    // Sélectionner une option et masquer le dropdown
    selectOption(option) {
      this.searchTerm = option.username;
      this.selectedOption = option.id;
      this.showDropdown = false;
      this.$emit("onUserSelected", option.id);
      console.log("Utilisateur sélectionné dans le Dropdown:", option.id);
    },

    // Montrer ou cacher le dropdown
    toggleDropdown(show) {
      setTimeout(() => {
        this.showDropdown = show;
      }, 150); // Un délai pour éviter de fermer lors du clic sur une option
    },
  },
};
</script>
