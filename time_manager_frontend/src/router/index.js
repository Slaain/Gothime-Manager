import { createRouter, createWebHistory } from 'vue-router';
import { isUserAdmin, isUserManager, authorizedOrganizationRoute, getOrganization } from '../auth'; 

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
    path: '/charts',
    name: 'Charts',
    component: () => import("@/views/Chart.vue"),
  },
  {
    path: '/manager/:organisationId',
    name: 'ManagerDashboard',
    component: () => import("@/views/ManagerDashboard.vue"),
    props: true,
    meta: { requiresManager: true, requiresOrganizationAuth: true },
  },
  {
    path: '/manager/:organisationId/groups',
    name: 'GroupsPage',
    component: () => import("@/views/GroupsPage.vue"),
    props: true,
    meta: { requiresManager: true, requiresOrganizationAuth: true },
  },
  {
    path: '/manager/qrcode',
    name: 'ManagerQRCode',
    component: () => import("@/views/ManagerQRCode.vue"),
  },
  {
    path: '/organisations',
    name: 'organisations',
    component: () => import("@/views/Organisation.vue"),
    meta: { requiresManager: true, requiresAdmin: true }, // Access for managers and admins
  },
  {
    path: '/login',
    name: 'login',
    component: () => import("@/views/Login.vue"),
  },
  {
    path: '/',
    name: 'Home',
    component: () => import("@/views/LandingPage.vue"),
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach(async (to, from, next) => {
  const authToken = localStorage.getItem('authToken');
  const isAdmin = await isUserAdmin(authToken);
  const isManager = await isUserManager(authToken);

  console.log("isAdmin:", isAdmin);

  // Route protégée pour les admins
  if (to.matched.some(record => record.meta.requiresAdmin)) {
    if (!authToken || !isAdmin) {
      next('/login');
    } else {
      next();
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
