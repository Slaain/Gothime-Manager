import { createRouter, createWebHistory } from 'vue-router';
import { isUserAdmin, isUserManager, authorizedOrganizationRoute, getOrganization } from '../auth'; 

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
    meta: { requiresManager: true, requiresOrganizationAuth: true }, // Ajout d'une meta donnée pour vérifier l'organisation
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
    meta: { requiresManager: true },
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
  
  if (to.matched.some(record => record.meta.requiresAdmin)) {
    if (!authToken || !isAdmin) {
      next('/login');
    } else {
      next();
    }
  } else if (to.matched.some(record => record.meta.requiresManager)) {
    if (!authToken || !isManager) {
      console.log("not manager");
      
      next('/login');
    } else {
      if (to.meta.requiresOrganizationAuth) {
        // Vérifie si l'utilisateur a l'accès à cette organisation
        const organizationId = to.params.organisationId;
        const isAuthorized = await authorizedOrganizationRoute(authToken, organizationId);
        const getOrganizationId = await getOrganization(authToken);

        // console.log("getOrganization : ", await getOrganization(authToken));
        
        console.log("isAuthorized:", isAuthorized);
        console.log("organizationId:", organizationId);
        
        

        if (!isAuthorized) {
          alert("Vous n'êtes pas autorisé à accéder à cette organisation.");
          next(`/manager/${getOrganizationId}`);
        } else {
          next();
        }
      } else {
        next();
      }
    }
  } else {
    next();
  }
});

export default router;
