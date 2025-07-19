import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/about',
      name: 'about',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: () => import('../views/AboutView.vue'),
    },
    {
      path: '/test-management',
      name: 'test-management',
      component: () => import('../views/TestManagementView.vue'),
    },
    {
      path: '/news-updates',
      name: 'news-updates',
      component: () => import('../views/NewsUpdatesView.vue'),
    },
    {
      path: '/alphapath-model',
      name: 'alphapath-model',
      component: () => import('../views/AlphaPathModelView.vue'),
    },
    {
      path: '/faq',
      name: 'faq',
      component: () => import('../views/FAQView.vue'),
    },
    {
      path: '/patient-resources',
      name: 'patient-resources',
      component: () => import('../views/PatientResourcesView.vue'),
    },
  ],
})

export default router
