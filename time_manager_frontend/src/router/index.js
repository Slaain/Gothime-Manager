import { createRouter, createWebHistory } from 'vue-router';
import { isUserAdmin, isUserManager } from '../auth'; 

const routes = [
  {
    path: '/admin',
    name: 'AdminDashboard',
    component: () => import("@/views/AdminDashboard.vue"),
    meta: { requiresAdmin: true },
  },
  {
    path: '/contact',
    name: 'Contact',
    component: () => import("@/views/Contact.vue"),
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
    path: '/charts',
    name: 'Charts',
    component: () => import("@/views/Chart.vue"),
    meta: { requiresAdmin: true }, // Access for managers
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
    meta: { requiresManager: true, requiresAdmin: true }, // Access for managers and admins
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
  }
  // Route spécifique pour /organisations, accessible pour managers et admins
  else if (to.path === '/organisations' && (isManager || isAdmin)) {
    next();
  }
  // Routes protégées pour les managers avec vérification de l'organisation
  else if (to.matched.some(record => record.meta.requiresManager)) {
    if (!authToken || !isManager) {
      next('/login');
    } else {
      if (to.meta.requiresOrganizationAuth) {
        const organizationId = to.params.organisationId;
        const isAuthorized = isAdmin || await authorizedOrganizationRoute(authToken, organizationId);

        if (!isAuthorized) {
          // Rediriger le manager vers sa page organisation par défaut
          const managerOrganizationId = await getOrganization(authToken);
          next(`/manager/${managerOrganizationId}`);
        } else {
          next();
        }
      } else {
        next();
      }
    }
  } 
  // Routes ouvertes ou sans restriction spécifique
  else {
    next();
  }
});

export default router;