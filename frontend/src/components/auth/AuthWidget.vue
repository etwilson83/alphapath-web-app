<script setup lang="ts">
import { ref } from 'vue'

// Mock user state - in real app this would come from a store/auth service
const isLoggedIn = ref(false)
const currentUser = ref({
  username: 'john.doe',
  email: 'john.doe@example.com'
})

const showDropdown = ref(false)
const showLoginModal = ref(false)
const loginForm = ref({
  email: '',
  password: ''
})

const toggleDropdown = () => {
  showDropdown.value = !showDropdown.value
}

const handleLogin = () => {
  // Show login modal instead of directly logging in
  showLoginModal.value = true
}

const handleLoginSubmit = () => {
  // Mock login - ignore form data and just log in
  console.log('Mock login successful!')
  isLoggedIn.value = true
  showLoginModal.value = false
  // Reset form
  loginForm.value = { email: '', password: '' }
}

const handleLogout = () => {
  // Mock logout - in real app this would call an API
  isLoggedIn.value = false
  showDropdown.value = false
}

const handleAccountDetails = () => {
  // Mock account details - in real app this would navigate to account page
  console.log('Navigate to account details')
  showDropdown.value = false
}

const closeLoginModal = () => {
  showLoginModal.value = false
  // Reset form
  loginForm.value = { email: '', password: '' }
}
</script>

<template>
  <!-- Login/User Account Component -->
  <div v-if="!isLoggedIn" class="flex items-center">
    <button 
      class="btn btn-ghost btn-sm"
      @click="handleLogin"
    >
      <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
      </svg>
      <span>Login</span>
    </button>
  </div>
  
  <div v-else class="dropdown dropdown-end">
    <div 
      tabindex="0" 
      role="button" 
      class="btn btn-ghost btn-sm"
      @click="toggleDropdown"
    >
      <div class="flex items-center gap-2">
        <div class="avatar placeholder">
          <div class="bg-neutral text-neutral-content rounded-full w-8">
            <span class="text-xs">{{ currentUser.username.charAt(0).toUpperCase() }}</span>
          </div>
        </div>
        <span>{{ currentUser.username }}</span>
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
        </svg>
      </div>
    </div>
    
    <ul 
      tabindex="0" 
      class="dropdown-content z-[1] menu p-2 shadow bg-base-100 rounded-box w-52"
      :class="{ 'dropdown-open': showDropdown }"
    >
      <li>
        <button @click="handleAccountDetails" class="flex items-center gap-2">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
          </svg>
          Account Details
        </button>
      </li>
      <li>
        <button @click="handleLogout" class="flex items-center gap-2 text-error">
          <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path>
          </svg>
          Logout
        </button>
      </li>
    </ul>
  </div>

  <!-- Login Modal -->
  <dialog :class="{ 'modal modal-open': showLoginModal }" @click="closeLoginModal">
    <div class="modal-box" @click.stop>
      <h3 class="font-bold text-lg mb-4">Login to AlphaPath</h3>
      <form @submit.prevent="handleLoginSubmit">
        <div class="form-control w-full mb-4">
          <label class="label">
            <span class="label-text">Email</span>
          </label>
          <input 
            type="email" 
            placeholder="Enter your email" 
            class="input input-bordered w-full" 
            v-model="loginForm.email"
            required
          />
        </div>
        <div class="form-control w-full mb-6">
          <label class="label">
            <span class="label-text">Password</span>
          </label>
          <input 
            type="password" 
            placeholder="Enter your password" 
            class="input input-bordered w-full" 
            v-model="loginForm.password"
            required
          />
        </div>
        <div class="modal-action">
          <button type="button" class="btn" @click="closeLoginModal">Cancel</button>
          <button type="submit" class="btn btn-primary">Login</button>
        </div>
      </form>
    </div>
  </dialog>
</template>

<style scoped>
/* Component-specific styles if needed */
</style> 