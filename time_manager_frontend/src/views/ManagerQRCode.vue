<template>
  <div class="flex items-center justify-center min-h-screen bg-gray-100">
    <div
      class="max-w-sm p-8 text-center bg-white rounded-lg shadow-lg glassmorphism"
    >
      <h1 class="mb-4 text-2xl font-bold text-gray-800">Generate QR Code</h1>

      <p class="mb-6 text-gray-600">
        Click the button below to generate a QR code for our example URL.
      </p>

      <button
        @click="generateQRCode"
        class="px-6 py-3 mb-6 font-bold text-white rounded-lg bg-yellowPrimary hover:bg-yellowPrimary400"
      >
        Generate QR Code
      </button>
      <a :href="url" target="_blank">{{ url }}</a>

      <canvas ref="qrcodeCanvas" class="mx-auto"></canvas>
    </div>
  </div>
</template>

<script>
import QRCode from "qrcode";
import axios from "axios";

export default {
  name: "QRCodePage",
  data() {
    organizationId: 3;
    return {
      url: "http://localhost:4000/api/clocks/3/1", // Organization ID/Employee ID
    };
  },
  methods: {
    generateQRCode() {
      axios
        .post(
          `http://localhost:4000/api/qrcode/generate/3`,
          {},
          {
            headers: {
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        )
        .then((response) => {
          console.log(response.data);

          this.url = `http://localhost:4000/api/clocks/3/1?token=${response.data.qr_code}`; // Organization ID/Employee ID
          if (response.data.qr_code) {
            const canvas = this.$refs.qrcodeCanvas;
            QRCode.toCanvas(
              canvas,
              this.url,
              { width: 200, margin: 2 },
              function (error) {
                if (error) console.error(error);
                console.log("QR code generated successfully!");
              }
            );
          }
        });
    },
  },
};
</script>

<style scoped>
.glassmorphism {
  background: rgba(255, 255, 255, 0.2); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre */
}

.bg-yellowPrimary {
  background-color: #fdcb12; /* Couleur principale */
}

.hover\:bg-yellowPrimary400:hover {
  background-color: #fbbf24; /* Couleur hover */
}
</style>
