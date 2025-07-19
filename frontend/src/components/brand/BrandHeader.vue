<script setup lang="ts">
// Brand component - handles logo and title display
</script>

<template>
  <div class="navbar-start">
    <img 
      alt="Michigan Medicine Logo" 
      class="h-12 w-auto" 
      src="@/assets/Michigan-Medicine_Logo-Horizontal-White.png" 
    />
  </div>
  <div class="navbar-center">
    <div class="brand-title">ALPHAPATH</div>
  </div>
</template>

<style scoped>
.brand-title {
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0;
  padding: 0 1rem;
  font-size: 1.5rem;
  font-weight: 900;
  line-height: 1;
  color: #e5e7eb;
  letter-spacing: 0.1em;
  text-transform: uppercase;
}
</style> 