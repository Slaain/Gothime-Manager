import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: '/admin',
    name: 'AdminDashboard',
    component: () => import("@/views/AdminDashboard.vue")
  },
  {
    path: '/manager',
    name: 'ManagerDashboard',
    component: () => import("@/views/ManagerDashboard.vue")
  },
  {
    path: '/register',
    name: 'Register',
    component: () => import("@/views/Register.vue")
  },
  {
    path: '/login',
    name: 'login',
    component: () => import("@/views/Login.vue")
  },
  {
    path: '/',
    redirect: '/admin' // Redirige vers /admin par défaut
  }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
