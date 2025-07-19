<script setup lang="ts">
import { RouterLink } from 'vue-router'
</script>

<template>
  <header class="navbar bg-base-100 shadow-lg">
    <div class="navbar-start">
      <img 
        alt="Michigan Medicine Logo" 
        class="h-12 w-auto" 
        src="@/assets/Michigan-Medicine_Logo-Horizontal-White.png" 
      />
    </div>
    <div class="navbar-center">
      <h1 class="text-xl font-bold text-neutral-200">AlphaPath Diagnostic System</h1>
    </div>
    <div class="navbar-end">
      <div class="tabs tabs-boxed">
        <RouterLink to="/" class="tab tab-lifted" active-class="tab-active">Home</RouterLink>
        <RouterLink to="/about" class="tab tab-lifted" active-class="tab-active">About</RouterLink>
      </div>
    </div>
  </header>
</template>

<style scoped>
/* DaisyUI classes handle all the styling */
</style> 