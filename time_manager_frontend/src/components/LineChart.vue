<template>
  <div class="line-chart-container">
    <div class="filter-container">
      <label for="filterSelect" class="filter-label">Select Time Period:</label>
      <select v-model="selectedFilter" @change="fetchWorkingTimes" id="filterSelect">
        <option value="lastSixMonths">Last 6 Months (Monthly)</option>
        <option value="lastWeek">Last Week (Daily)</option>
        <option value="month">This Month (Weekly)</option>
      </select>
    </div>
    <canvas id="myChart"></canvas>
    <div v-if="displayPeriod" class="period-display">
      <p>Data from: <strong>{{ displayPeriod }}</strong></p>
    </div>
  </div>
</template>

<script>
import {
  Chart,
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
  LineController,
} from "chart.js";

Chart.register(
  Title,
  Tooltip,
  Legend,
  LineElement,
  PointElement,
  CategoryScale,
  LinearScale,
  LineController
);

export default {
  name: "LineChart",
  data() {
    return {
      chartInstance: null,
      selectedFilter: "lastSixMonths", // Définir le filtre par défaut
      displayPeriod: "",
    };
  },
  mounted() {
    this.$nextTick(() => {
      this.fetchWorkingTimes();
    });
  },
  methods: {
    async fetchWorkingTimes() {
      try {
        const response = await fetch("http://localhost:4000/api/workingtimes");
        const data = await response.json();

        let transformedData;

        if (this.selectedFilter === "lastWeek") {
          transformedData = this.groupWorkingTimesByDay(data.data);
          this.setDisplayPeriod("lastWeek", transformedData.dateRange);
        } else if (this.selectedFilter === "month") {
          transformedData = this.groupWorkingTimesByWeek(data.data);
          this.setDisplayPeriod("month", transformedData.dateRange);
        } else if (this.selectedFilter === "lastSixMonths") {
          transformedData = this.groupWorkingTimesByMonth(data.data);
          this.setDisplayPeriod("lastSixMonths", transformedData.dateRange);
        }

        this.renderChart(transformedData.labels, transformedData.hoursWorked);
      } catch (error) {
        console.error("Erreur lors de la récupération des working times:", error);
      }
    },

    setDisplayPeriod(filterType, dateRange) {
      if (filterType === "lastWeek") {
        this.displayPeriod = `${dateRange.start} to ${dateRange.end}`;
      } else if (filterType === "month") {
        this.displayPeriod = `Current Month`;
      } else if (filterType === "lastSixMonths") {
        this.displayPeriod = `Last 6 Months`;
      }
    },

    groupWorkingTimesByDay(data) {
      const today = new Date();
      const lastWeek = new Date(today);
      lastWeek.setDate(today.getDate() - 7);
      const dayMap = new Map();

      let startDate = today;
      let endDate = lastWeek;

      data.forEach((entry) => {
        const entryDate = new Date(entry.start);
        if (entryDate >= lastWeek && entryDate <= today) {
          const day = entryDate.toLocaleDateString("en-GB", {
            weekday: "short",
            day: "2-digit",
            month: "2-digit",
            year: "numeric",
          });

          if (entryDate < startDate) startDate = entryDate;
          if (entryDate > endDate) endDate = entryDate;

          if (dayMap.has(day)) {
            dayMap.set(day, dayMap.get(day) + entry.total_time / 60);
          } else {
            dayMap.set(day, entry.total_time / 60);
          }
        }
      });

      const sortedDays = Array.from(dayMap.keys());
      const hoursWorked = sortedDays.map((day) => dayMap.get(day));

      return {
        labels: sortedDays,
        hoursWorked: hoursWorked,
        dateRange: {
          start: startDate.toLocaleDateString("en-GB"),
          end: endDate.toLocaleDateString("en-GB"),
        },
      };
    },

    groupWorkingTimesByWeek(data) {
      const currentMonth = new Date().getMonth();
      const currentYear = new Date().getFullYear();
      const weekMap = new Map();

      data.forEach((entry) => {
        const entryDate = new Date(entry.start);
        const entryMonth = entryDate.getMonth();
        const entryYear = entryDate.getFullYear();

        if (entryYear === currentYear && entryMonth === currentMonth) {
          const weekNumber = this.getWeekNumber(entryDate);
          const label = `Week ${weekNumber}`;

          if (weekMap.has(label)) {
            weekMap.set(label, weekMap.get(label) + entry.total_time / 60);
          } else {
            weekMap.set(label, entry.total_time / 60);
          }
        }
      });

      const sortedWeeks = Array.from(weekMap.keys());
      const hoursWorked = sortedWeeks.map((week) => weekMap.get(week));

      return {
        labels: sortedWeeks,
        hoursWorked: hoursWorked,
        dateRange: {},
      };
    },

    groupWorkingTimesByMonth(data) {
      const monthMap = new Map();
      const today = new Date();
      const sixMonthsAgo = new Date();
      sixMonthsAgo.setMonth(today.getMonth() - 5);

      data.forEach((entry) => {
        const entryDate = new Date(entry.start);
        if (entryDate >= sixMonthsAgo && entryDate <= today) {
          const month = entryDate.toLocaleString("en-GB", {
            month: "short",
            year: "numeric",
          });

          if (monthMap.has(month)) {
            monthMap.set(month, monthMap.get(month) + entry.total_time / 60);
          } else {
            monthMap.set(month, entry.total_time / 60);
          }
        }
      });

      const sortedMonths = Array.from(monthMap.keys()).sort(
        (a, b) => new Date(a) - new Date(b)
      );
      const hoursWorked = sortedMonths.map((month) => monthMap.get(month));

      return {
        labels: sortedMonths,
        hoursWorked: hoursWorked,
        dateRange: {},
      };
    },

    getWeekNumber(date) {
      const startOfYear = new Date(date.getFullYear(), 0, 1);
      const pastDaysOfYear = (date - startOfYear) / 86400000;
      return Math.ceil((pastDaysOfYear + startOfYear.getDay() + 1) / 7);
    },

    renderChart(labels, hoursWorked) {
      const canvas = document.getElementById("myChart");

      if (!canvas) {
        console.error("Canvas element not found");
        return;
      }

      if (this.chartInstance) {
        this.chartInstance.destroy();
        this.chartInstance = null;
      }

      const chartContext = canvas.getContext("2d");

      this.chartInstance = new Chart(chartContext, {
        type: "line",
        data: {
          labels: labels,
          datasets: [
            {
              label: "Hours Worked",
              data: hoursWorked,
              fill: false,
              borderColor: "#FDCB12",
              tension: 0.1,
            },
          ],
        },
        options: {
          responsive: true,
          scales: {
            x: {
              title: {
                display: true,
                text: "Time Period",
                color: "#ffffff",
              },
              ticks: {
                color: "#ffffff", // Set tick color to black
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
              },
            },
            y: {
              beginAtZero: true,
              title: {
                display: true,
                text: "Hours Worked",
                color: "#ffffff",
              },
              ticks: {
                color: "#ffffff", // Set tick color to black
              },
              grid: {
                color: "rgba(255, 255, 255, 0.2)",
              },
            },
          },
          plugins: {
            legend: {
              labels: {
                color: "#ffffff", // Set legend text color to black
              },
            },
          },
        },
      });
    },
  },
};
</script>

<style scoped>
.line-chart-container {
  max-width: 700px;
  margin: 0 auto;
}
.filter-container {
  display: flex;
  justify-content: center;
  margin-bottom: 1rem;
}
.filter-label {
  margin-right: 10px;
  font-size: 1rem;
  color: #ffffff; /* Black color for better contrast */
}
#filterSelect {
  padding: 8px;
  font-size: 1rem;
  border: 1px solid #ccc;
  border-radius: 5px;
  width: 300px; /* Increased width for better visibility */
  color: #fdcb12; /* Black font color */
}
.period-display {
  text-align: center;
  margin-top: 10px;
  color: #ffffff;
}
</style>
