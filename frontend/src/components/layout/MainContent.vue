<script setup lang="ts">
import { RouterView } from 'vue-router'
import HelloWorld from '../HelloWorld.vue'

// Props for flexibility
interface Props {
  showHelloWorld?: boolean
}

withDefaults(defineProps<Props>(), {
  showHelloWorld: true
})
</script>

<template>
  <main class="flex-1 p-6 overflow-auto">
    <div class="max-w-7xl mx-auto">
      <!-- Optional HelloWorld component
      <HelloWorld v-if="showHelloWorld" msg="You did it!" class="mb-6" /> -->
      
      <!-- Main content area -->
      <div class="bg-base-100 rounded-lg shadow-lg p-6">
        <RouterView />
      </div>
    </div>
  </main>
</template>

<style scoped>
/* Additional custom styles can be added here if needed */
</style> 