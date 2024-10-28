import { createRouter, createWebHistory } from 'vue-router';
import { isUserAdmin, isUserManager } from '../auth'; 

const routes = [
  {
    path: '/admin',
    name: 'AdminDashboard',
    component: () => import("@/views/AdminDashboard.vue"),
    meta: { requiresAdmin: true }, // Ajout d'une meta donnée pour vérifier le rôle admin

  },
  //Contact page

  {
    path: '/contact',
    name: 'Contact',
    component: () => import("@/views/Contact.vue"),
  },
  {
    path: '/charts',
    name: 'Charts',
    component: () => import("@/views/Chart.vue"),
  },
  {
    path: '/manager/:organisationId',
    name: 'ManagerDashboard',
    component: () => import("@/views/ManagerDashboard.vue"),
    props: true,
    meta: { requiresManager: true }, // Ajout d'une meta donnée pour vérifier le rôle manager
  },
  {
    path: '/manager/:organisationId/groups',
    name: 'GroupsPage',
    component: () => import("http://localhost:4000/api/organisations/1e"),
    props: true,
    meta: { requiresManager: true }, // Ajout d'une meta donnée pour vérifier le rôle manager

  },
  {
    path: '/manager/qrcode',
    name: 'ManagerQRCode',
    component: () => import("@/views/ManagerQRCode.vue")
  },
  // {
  //   path: '/register',
  //   name: 'Register',
  //   component: () => import("@/views/Register.vue")
  // },
  {
    path: '/organisations',
    name: 'organisations',
    component: () => import("@/views/Organisation.vue"),
        meta: { requiresManager: true }, // Ajout d'une meta donnée pour vérifier le rôle manager

  },
  {
    path: '/login',
    name: 'login',
    component: () => import("@/views/Login.vue")
  },
  {
    path: '/',
    name: 'Home',
    component: () => import("@/views/LandingPage.vue")
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach(async (to, from, next) => {
  const authToken = localStorage.getItem('authToken'); // Exemple: récupérer le token
  const isAdmin = await isUserAdmin(authToken); // Fonction pour vérifier si l'utilisateur est admin
  const isManager = await isUserManager(authToken); // Fonction pour vérifier si l'utilisateur est manager

  console.log("isAdmin : ", isAdmin);
  
  // Vérifie si la route nécessite un accès admin
  if (to.matched.some(record => record.meta.requiresAdmin)) {
    // Si l'utilisateur n'est pas admin, redirige vers la page de connexion
    if (!authToken || !isAdmin) {
      next('/login'); // Redirige vers la page de connexion si l'utilisateur n'est pas admin
    } else {
      next(); // L'utilisateur est admin, permet de continuer
    }
  } else if (to.matched.some(record => record.meta.requiresManager)) {
    // Si l'utilisateur n'est pas manager, redirige vers la page de connexion
    if (!authToken || !isManager) {
      next('/login'); // Redirige vers la page de connexion si l'utilisateur n'est pas manager
    } else {
      next(); // L'utilisateur est manager, permet de continuer
    }
  } else {
    next(); // Pas de restriction d'accès, on continue
  }
});

export default router;