<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'
</script>

<template>
  <div class="min-h-screen bg-base-200">
    <div class="navbar bg-base-100 shadow-lg">
      <div class="navbar-start">
        <img alt="Vue logo" class="w-12 h-12" src="@/assets/logo.svg" />
      </div>
      <div class="navbar-center">
        <h1 class="text-xl font-bold text-neutral-200">Azure Go + Vue + Postgres</h1>
      </div>
      <div class="navbar-end">
        <div class="tabs tabs-boxed">
          <RouterLink to="/" class="tab tab-lifted" active-class="tab-active">Home</RouterLink>
          <RouterLink to="/about" class="tab tab-lifted" active-class="tab-active">About</RouterLink>
        </div>
      </div>
    </div>

    <main class="container mx-auto p-4">
      <HelloWorld msg="You did it!" />
      <RouterView />
    </main>
  </div>
</template>

<style scoped>
/* DaisyUI classes handle all the styling now */
</style>
