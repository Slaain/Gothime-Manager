<template>
  <div class="bat-container">
    <div class="dashboard">
      <!-- Sidebar -->
      <Sidebar active="Dashboard" />
      <!-- Main Content -->
      <main class="flex-1 p-6 main-content">
        <header class="flex items-center justify-between mb-6">
          <h1 class="text-3xl font-bold text-white">Dashboard</h1>
          <div
            class="relative flex items-center space-x-4 text-white user-info"
          >
            <span>ADMIN</span>
            <img
              src="../assets/avatar.jpg"
              alt="User Avatar"
              class="w-10 h-10 rounded-full cursor-pointer"
              @click="toggleDropdown"
            />

            <!-- Dropdown Menu -->
            <div
              v-if="isDropdownOpen"
              ref="dropdown"
              class="absolute right-0 z-20 w-48 mt-2 bg-white rounded-md shadow-lg top-10"
            >
              <ul class="py-1 text-gray-700">
                <li>
                  <button
                    @click="logout"
                    class="block w-full px-4 py-2 text-sm text-left hover:bg-gray-100 hover:text-gray-900"
                  >
                    Se déconnecter
                  </button>
                </li>
              </ul>
            </div>
          </div>
        </header>

        <section class="p-6 mb-6 rounded-lg shadow-lg glassmorphism line-chart">
          <div class="flex items-center justify-between mb-4">
            <button
              @click="previousChart"
              class="p-2 text-white transition-colors rounded-full hover:bg-white/10"
            >
              <ChevronLeftIcon class="w-6 h-6" />
            </button>

            <h2 class="text-xl text-white">
              Working Hours - {{ currentChartLabel }}
            </h2>

            <button
              @click="nextChart"
              class="p-2 text-white transition-colors rounded-full hover:bg-white/10"
            >
              <ChevronRightIcon class="w-6 h-6" />
            </button>
          </div>

          <component :is="currentChart" />
        </section>

        <section class="grid grid-cols-3 gap-6 mb-6 charts">
          <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">Users Worked This Month</h2>
            <div
              class="flex items-center justify-center h-40 working-times-number"
            >
              {{ monthlyUsers }}
            </div>
          </div>

          <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">Users Currently Working</h2>
            <div
              class="flex items-center justify-center h-40 working-times-number"
            >
              {{ currentUsers }}
            </div>
          </div>

          <div class="p-4 rounded-lg shadow-lg glassmorphism-bg-white chart">
            <h2 class="mb-4 text-xl text-white">Working Times This Month</h2>
            <div
              class="flex items-center justify-center h-40 working-times-number"
            >
              {{ workingTimesThisMonth }}
            </div>
          </div>
        </section>

        <section class="p-0 users">
          <h2 class="mb-4 text-xl text-white">Users List</h2>
          <div class="overflow-x-auto">
            <UserList
              @updateUserId="selectUser"
              @clock-toggle="getCurrentUsers"
            />
          </div>
        </section>

        <section v-if="selectedUserId" class="w-full mt-6">
          <WorkingTimeUserContainer :userID="selectedUserId" />
        </section>
      </main>
    </div>
  </div>
</template>

<script>
import {
  ChevronLeft as ChevronLeftIcon,
  ChevronRight as ChevronRightIcon,
} from "lucide-vue-next";
import UserList from "../components/UserList.vue";
import LineChart from "../components/LineChart.vue";
import WorkingTimeUserContainer from "../components/WorkingTimesUsersContainer.vue";
import CreaGroupComponent from "@/components/CreaGroupComponent.vue";
import DonutChart from "@/components/DonutChart.vue";
import Sidebar from "../components/Sidebar.vue";
import axios from "axios";

const CHART_TYPES = [
  { component: LineChart, label: "Line Chart" },
  { component: DonutChart, label: "Donut Chart" },
];

export default {
  name: "Dashboard",
  components: {
    Sidebar,
    UserList,
    LineChart,
    DonutChart,
    WorkingTimeUserContainer,
    CreaGroupComponent,
    ChevronLeftIcon,
    ChevronRightIcon,
  },
  data() {
    return {
      currentUsers: 0,
      workingTimesThisMonth: 0,
      monthlyUsers: 0,
      isDropdownOpen: false,
      selectedUserId: null,
      showGroupComponent: false,
      currentChartIndex: 0,
    };
  },
  computed: {
    currentChart() {
      return CHART_TYPES[this.currentChartIndex].component;
    },
    currentChartLabel() {
      return CHART_TYPES[this.currentChartIndex].label;
    },
  },
  mounted() {
    this.getCurrentUsers();
    this.getWorkingTimesThisMonth();
    document.addEventListener("click", this.handleClickOutside);
  },
  beforeUnmount() {
    document.removeEventListener("click", this.handleClickOutside);
  },
  methods: {
    previousChart() {
      this.currentChartIndex =
        (this.currentChartIndex - 1 + CHART_TYPES.length) % CHART_TYPES.length;
    },
    nextChart() {
      this.currentChartIndex =
        (this.currentChartIndex + 1) % CHART_TYPES.length;
    },
    showDashboard() {
      this.showGroupComponent = false;
    },
    toggleGroupView() {
      this.showGroupComponent = !this.showGroupComponent;
    },
    toggleDropdown() {
      this.isDropdownOpen = !this.isDropdownOpen;
    },
    logout() {
      localStorage.removeItem("authToken");
      this.$router.push("/login");
    },
    handleClickOutside(event) {
      const dropdown = this.$refs.dropdown;
      if (
        dropdown &&
        !dropdown.contains(event.target) &&
        !this.$el.contains(event.target)
      ) {
        this.isDropdownOpen = false;
      }
    },
    async getWorkingTimesThisMonth() {
      try {
        const response = await axios.get(
          "http://localhost:4000/api/workingtimes/count",
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.monthlyUsers = response.data.users_count;
        this.workingTimesThisMonth = response.data.working_times_count;
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des working times",
          error
        );
      }
    },
    async getCurrentUsers() {
      try {
        const response = await axios.get(
          "http://localhost:4000/api/clocks/countactive",
          {
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${localStorage.getItem("authToken")}`,
            },
          }
        );
        this.currentUsers = response.data.count;
      } catch (error) {
        console.error(
          "Erreur lors de la récupération des utilisateurs actifs",
          error
        );
      }
    },
    selectUser(userId) {
      this.selectedUserId = userId;
    },
  },
};
</script>

<style scoped>
/* Les styles restent identiques */
.working-times-number {
  font-size: 6rem;
  color: transparent;
  -webkit-text-stroke: 2px #fdcb12;
  border-radius: 10px;
  transition: all 0.3s ease;
}

.chart:hover .working-times-number {
  color: #fdcb12;
  -webkit-text-stroke: 0px;
  text-shadow: 0 0 10px rgba(253, 203, 18, 0.8),
    0 0 20px rgba(253, 203, 18, 0.6);
}

.glassmorphism {
  position: relative;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  color: white;
  overflow: hidden;
}

.glassmorphism::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 2px;
  border-radius: 10px;
  background: linear-gradient(
    to bottom right,
    #ffffff,
    rgba(255, 255, 255, 0.5),
    #fdcb12
  );
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none;
}

.glassmorphism h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85);
}

.glassmorphism .line-chart {
  padding: 1rem;
  border-radius: 8px;
}

.glassmorphism-bg-white {
  position: relative;
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-radius: 10px;
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
  color: white;
  overflow: hidden;
}

.glassmorphism-bg-white::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 2px;
  border-radius: 10px;
  background: linear-gradient(
    to bottom right,
    #ffffff,
    rgba(255, 255, 255, 0.8),
    #ffffff
  );
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none;
}

.glassmorphism-bg-white h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85);
}

.glassmorphism-bg-white .line-chart {
  padding: 1rem;
  border-radius: 8px;
}

.bat-container {
  background: #333333;
  background-image: url("../assets/images/bat.png");
  background-repeat: repeat;
  background-size: 100px 100px;
  background-position: 0 0;
}

.bat-container::after {
  content: "";
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-image: url("../assets/images/noise.png");
  background-repeat: repeat;
  opacity: 0.1;
  pointer-events: none;
  z-index: 1;
}

.dashboard {
  display: flex;
  min-height: 100vh;
  position: relative;
  background-image: url("../assets/images/noise.png");
  z-index: 2;
}

.dashboard {
  display: flex;
  min-height: 100vh;
}

.sidebar {
  width: 200px;
  background-color: #212327;
  padding: 20px;
}

.main-content {
  flex: 1;
  background-color: rgba(0, 0, 0, 0.8);
  padding: 20px;
}

.chart {
  padding: 20px;
  border-radius: 10px;
}

.line-chart {
  padding: 20px;
  border-radius: 10px;
  width: 100%;
  color: white;
}

.working-time-container {
  padding: 20px;
  border-radius: 10px;
}
</style>