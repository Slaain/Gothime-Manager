<template>
  <div class="carousel-container relative">
    <!-- Previous Button -->
    <button @click="prev" class="absolute left-0 top-1/2 transform -translate-y-1/2 bg-gray-800 text-white px-3 py-2 rounded-full">
      &lt;
    </button>

    <!-- Dynamic Chart Slot -->
    <div class="carousel-item w-full flex justify-center items-center">
      <component :is="charts[currentIndex]" />
    </div>

    <!-- Next Button -->
    <button @click="next" class="absolute right-0 top-1/2 transform -translate-y-1/2 bg-gray-800 text-white px-3 py-2 rounded-full">
      &gt;
    </button>

    <!-- Carousel Indicators -->
    <div class="flex justify-center mt-4">
      <span
          v-for="(chart, index) in charts"
          :key="index"
          :class="[
          'mx-1 w-3 h-3 rounded-full',
          currentIndex === index ? 'bg-white' : 'bg-gray-500'
        ]"
          class="cursor-pointer"
          @click="goTo(index)"
      ></span>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      currentIndex: 0,
      charts: ['LineChart', 'BarChart', 'PieChart'], // Add or modify chart components here
    };
  },
  methods: {
    prev() {
      this.currentIndex =
          this.currentIndex > 0 ? this.currentIndex - 1 : this.charts.length - 1;
    },
    next() {
      this.currentIndex =
          this.currentIndex < this.charts.length - 1 ? this.currentIndex + 1 : 0;
    },
    goTo(index) {
      this.currentIndex = index;
    },
  },
};
</script>

<style scoped>
.carousel-container {
  position: relative;
  width: 100%;
  overflow: hidden;
  padding: 2rem;
}

.carousel-item {
  transition: all 0.5s ease;
}
</style>
