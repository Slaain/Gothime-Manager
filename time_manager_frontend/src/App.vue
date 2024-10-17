<template>
  <div class="bg-gotham-wallpaper bg-cover bg-center min-h-screen flex items-center justify-center">
    <inscriptionForm class="w-2/3 w-full rounded-lg shadow-md" />
  </div>
</template>


<script>

import UserList from './components/UserList.vue';
import LineChart from './components/LineChart.vue';
import WorkingTimeUserContainer from './components/WorkingTimesUsersContainer.vue';
import CreaGroupComponent from "@/components/CreaGroupComponent.vue";
import BarChart from "@/components/WorkingTimesChart.vue";
import axios from 'axios';
import inscriptionForm from "@/components/inscriptionForm.vue";

import { getCurrentInstance } from 'vue';

export default {
  name: "Dashboard",
  components: {

    UserList,
    LineChart,
    WorkingTimeUserContainer,
    CreaGroupComponent,
    BarChart, // Enregistrement du BarChart
    inscriptionForm
  },
  data() {
    return {
      currentUsers: 0,
      workingTimesThisMonth: 0, // Initialisation avec une valeur par défaut
      monthlyUsers : 0,
      chartOptions: {
        chart: {
          id: "basic-bar",
        },
        xaxis: {
          categories: [
            "Jan",
            "Feb",
            "Mar",
            "Apr",
            "May",
            "Jun",
            "Jul",
            "Aug",
            "Sep",
            "Oct",
            "Nov",
            "Dec",
          ],
        },
      },
      series: [{
        name: "series-1",
        data: [30, 40, 35, 50, 49, 60, 70, 91, 125],
      }],
      selectedUserId: null,
      showGroupComponent: false, // Variable pour contrôler l'affichage du composant CreaGroupComponent

    };
  },
  mounted() {
    this.getCurrentUsers();
    this.getWorkingTimesThisMonth(); // Appel de la méthode pour récupérer le count lors du montage du composant
  },
  methods: {

    showDashboard() {
      this.showGroupComponent = false;
    },
    toggleGroupView() {
      this.showGroupComponent = !this.showGroupComponent;
    },

    async getWorkingTimesThisMonth() {
      try {
        const response = await axios.get('http://localhost:4000/api/workingtimes/count');
        this.monthlyUsers = response.data.users_count; // Assigner le nombre retourné par l'API
        this.workingTimesThisMonth = response.data.working_times_count
      } catch (error) {
        console.error("Erreur lors de la récupération des working times", error);
      }
    },
    async getCurrentUsers() {
      try {
        const response = await axios.get('http://localhost:4000/api/clocks/countactive');
        console.log(response);
        this.currentUsers = response.data.count;
      } catch (error){
        console.error("Erreur lors de la récupération des utilisateurs actifs", error);
      }
    },
    // Méthode pour mettre à jour l'ID de l'utilisateur sélectionné

    selectUser(userId) {
      this.selectedUserId = userId;
    },
  },
};
</script>


<style scoped>

.working-times-number {
  font-size: 6rem;
  color: transparent; /* Texte transparent */
  -webkit-text-stroke: 2px #fdcb12; /* Contour jaune */
  border-radius: 10px;
  transition: all 0.3s ease; /* Transition pour l'effet smooth */
}

.chart:hover .working-times-number {
  color: #fdcb12; /* Le texte devient entièrement jaune */
  -webkit-text-stroke: 0px; /* Retire le contour au hover */
  text-shadow: 0 0 10px rgba(253, 203, 18, 0.8), /* Ombre jaune */
               0 0 20px rgba(253, 203, 18, 0.6); /* Ombre plus lointaine */
}


.glassmorphism {
  position: relative;
  background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px; /* Arrondi des angles */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
  color: white;
  overflow: hidden; /* Pour assurer que le pseudo-élément reste dans les limites du conteneur */
}

.glassmorphism::before {
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
    rgba(255, 255, 255, 0.5),
    #fdcb12
  ); /* Dégradé de la bordure */
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none; /* Empêche les événements de la souris sur le pseudo-élément */
}

.glassmorphism h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85); /* Couleur blanche avec transparence */
}

.glassmorphism .line-chart {
  padding: 1rem;
  border-radius: 8px;
}

.glassmorphism-bg-white {
  position: relative;
  background: rgba(255, 255, 255, 0.1); /* Couleur blanche semi-transparente */
  backdrop-filter: blur(10px); /* Effet de flou sur l'arrière-plan */
  -webkit-backdrop-filter: blur(10px); /* Support pour Safari */
  border-radius: 10px; /* Arrondi des angles */
  box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1); /* Légère ombre pour effet de profondeur */
  color: white;
  overflow: hidden; /* Pour assurer que le pseudo-élément reste dans les limites du conteneur */
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
  ); /* Dégradé entièrement blanc */
  -webkit-mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
  -webkit-mask-composite: destination-out;
  mask-composite: exclude;
  pointer-events: none; /* Empêche les événements de la souris sur le pseudo-élément */
}

.glassmorphism-bg-white h2 {
  font-weight: bold;
  color: rgba(255, 255, 255, 0.85); /* Couleur blanche avec transparence */
}

.glassmorphism-bg-white .line-chart {
  padding: 1rem;
  border-radius: 8px;
}

.bat-container {
  background: #333333;
  background-image: url("./assets/images/bat.png");
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
  background-image: url("./assets/images/noise.png"); /* Image PNG du bruit */
  background-repeat: repeat;
  opacity: 0.1; /* Ajuste l'opacité du bruit */
  pointer-events: none;
  z-index: 1; /* Met le bruit au-dessus des chauves-souris */
}

.dashboard {
  display: flex;
  min-height: 100vh;
  position: relative;
  background-image: url("./assets/images/noise.png"); /* Image PNG du bruit */
  z-index: 2; /* S'assurer que le contenu reste au-dessus */
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
  /* background-color: #2d3748; */
  padding: 20px;
  border-radius: 10px;
}

.line-chart {
  /* background-color: #2d3748; */
  padding: 20px;
  border-radius: 10px;
  width: 100%;
  color: white;
}

.working-time-container {
  /* background-color: #2d3748; */
  padding: 20px;
  border-radius: 10px;
}
* {
  margin: 0;

  box-sizing: border-box;
}

html, body {
  height: 100%;
  margin: 0;
}

</style>
