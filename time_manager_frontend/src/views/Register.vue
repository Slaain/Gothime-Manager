<template>
  <div class="bg-gotham-wallpaper bg-cover bg-center min-h-screen flex items-center justify-center">
    <inscriptionForm class="max-w-xl w-full border border-gray-300 rounded-lg shadow-md" />

  </div>
</template>
<script>
import inscriptionForm from "@/components/inscriptionForm.vue";
export default {
  name: "Dashboard",
  components: {


    inscriptionForm
  },
}
</script>
  <style scoped>
  .glassmorphism-bg-white {
    position: relative;
    background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
    backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
    -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
    border-radius: 10px; /* Arrondi des angles */
    box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
    overflow: hidden; /* Pour s'assurer que le pseudo-élément reste dans les limites du conteneur */
  }

  .glassmorphism-bg-white::before {
    content: "";
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    padding: 2px; /* Épaisseur de la bordure */
    border-radius: 10px; /* Même bordure arrondie */
    background: linear-gradient(
      to bottom right,
      #ffffff,
      rgba(255, 255, 255, 0.8),
      #ffffff
    ); /* Dégradé */
    -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    -webkit-mask-composite: destination-out;
    mask-composite: exclude;
    pointer-events: none; /* Empêche les événements de la souris sur le pseudo-élément */
  }

  input:focus {
    outline: none;
    border-color: #fdcb12; /* Couleur jaune sur le focus */
    box-shadow: 0 0 5px rgba(253, 203, 18, 0.5); /* Ombre douce sur le focus */
  }
  </style>
