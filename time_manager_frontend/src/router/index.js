import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: '/admin',
    name: 'AdminDashboard',
    component: () => import("@/views/AdminDashboard.vue")
  },
  {
    path: '/manager/:organisationId',
    name: 'ManagerDashboard',
    component: () => import("@/views/ManagerDashboard.vue"),
    props: true,
  },
  {
    path: '/manager/:organisationId/groups',
    name: 'GroupsPage',
    component: () => import("http://localhost:4000/api/organisations/1e"),
    props: true,
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import("@/views/Register.vue")
  },
  {
    path: '/organisations',
    name: 'organisations',
    component: () => import("@/views/Organisation.vue")
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

export default router;
