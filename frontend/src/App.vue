<script setup lang="ts">
import AppHeader from './components/layout/AppHeader.vue'
import Sidebar from './components/layout/Sidebar.vue'
import MainContent from './components/layout/MainContent.vue'
</script>

<template>
  <div class="min-h-screen bg-base-200 flex flex-col">
    <!-- Top Banner - kept as-is -->
    <AppHeader />
    
    <!-- Main Layout Container -->
    <div class="flex flex-1">
      <!-- Left Navigation Pane -->
      <Sidebar />
      
      <!-- Right Main Content Pane -->
      <MainContent />
    </div>
  </div>
</template>

<style scoped>
/* DaisyUI classes handle all the styling now */
</style>
