<script setup lang="ts">
import BrandHeader from '@/components/brand/BrandHeader.vue'
import AuthWidget from '@/components/auth/AuthWidget.vue'
</script>

<template>
  <header class="navbar bg-base-100 shadow-lg">
    <BrandHeader />
    <div class="navbar-end">
      <AuthWidget />
    </div>
  </header>
</template>