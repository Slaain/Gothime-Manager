<template>
    <div v-if="visible" class="notification">
      <p>{{ message }}</p>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        visible: false,
        message: ''
      };
    },
    methods: {
      show(msg) {
        this.message = msg;
        this.visible = true;
        setTimeout(this.hide, 3000); // Masque la notification après 3 secondes
      },
      hide() {
        this.visible = false;
      }
    }
  };
  </script>
  
  <style scoped>
  .notification {
    position: fixed;
    top: 20px;
    right: 20px;
    background-color: rgb(256,188,12);
    color: black;
    padding: 1em;
    border-radius: 8px;
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
    z-index: 1000;
  }
  </style>
  