<script setup lang="ts">
import { RouterLink } from 'vue-router'
import { computed } from 'vue'
import { useRoute } from 'vue-router'

// Define navigation items for better maintainability
const navigationItems = [
  {
    name: 'Dashboard',
    path: '/',
    icon: '🏠',
    description: 'Main dashboard'
  },
  {
    name: 'Test Management',
    path: '/test-management',
    icon: '🔬',
    description: 'Manage and track diagnostic tests'
  },
  {
    name: 'News & Updates',
    path: '/news-updates',
    icon: '📰',
    description: 'Latest news and updates'
  },
  {
    name: 'AlphaPath Model',
    path: '/alphapath-model',
    icon: '🤖',
    description: 'AI model information and capabilities'
  },
  {
    name: 'FAQ',
    path: '/faq',
    icon: '❓',
    description: 'Frequently asked questions'
  },
  {
    name: 'Patient Resources',
    path: '/patient-resources',
    icon: '👥',
    description: 'Helpful resources for patients'
  },
  {
    name: 'About',
    path: '/about',
    icon: 'ℹ️',
    description: 'About this application'
  }
]

const route = useRoute()

// Computed property to check if a nav item is active
const isActive = (path: string) => route.path === path
</script>

<template>
  <nav class="space-y-2">
    <RouterLink
      v-for="item in navigationItems"
      :key="item.path"
      :to="item.path"
      :class="[
        'flex items-center gap-3 px-3 py-2 rounded-lg transition-colors duration-200',
        'hover:bg-base-200 hover:text-base-content',
        isActive(item.path) 
          ? 'bg-primary text-primary-content' 
          : 'text-base-content'
      ]"
      :title="item.description"
    >
      <span class="font-medium">{{ item.name }}</span>
    </RouterLink>
  </nav>
</template>

<style scoped>
/* Navigation-specific styles if needed */
</style> 