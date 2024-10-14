<template>
  <div class="modal-overlay" v-if="visible" @click.self="close">
    <div class="modal-content">
      <slot></slot> <!-- Insérer du contenu personnalisé ici -->
      <button class="close-button" @click="close">Fermer</button>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    visible: {
      type: Boolean,
      required: true,
    }
  },
  methods: {
    close() {
      this.$emit('close');
    }
  }
}
</script>

<style scoped>
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
}

.modal-content {
  background-color: white;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
  width: 300px;
  max-width: 100%;
  text-align: center;
}

.close-button {
  background-color: red;
  color: white;
  padding: 10px;
  border: none;
  border-radius: 5px;
  cursor: pointer;
  margin-top: 10px;
}
</style>
