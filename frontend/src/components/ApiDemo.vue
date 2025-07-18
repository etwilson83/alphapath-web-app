<script setup lang="ts">
import { ref, onMounted } from 'vue'

interface ApiResponse {
  message: string
  timestamp: string
  database: string
  server: string
}

const loading = ref(true)
const error = ref<string | null>(null)
const data = ref<ApiResponse | null>(null)

// Use configurable API URL from build-time environment variable
const API_URL = __API_URL__

const fetchHello = async () => {
  try {
    loading.value = true
    error.value = null
    
    const response = await fetch(`${API_URL}/api/hello`)
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`)
    }
    
    const result = await response.json()
    data.value = result
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Unknown error occurred'
  } finally {
    loading.value = false
  }
}

const refreshData = () => {
  fetchHello()
}

// Fetch data when component mounts
onMounted(() => {
  fetchHello()
})
</script>

<template>
  <div class="api-demo">
    <h2>🚀 Full Stack Integration Demo</h2>
    <p class="subtitle">Testing Vue.js ↔ Go Backend ↔ PostgreSQL connection</p>
    <p class="api-info">Backend API: <code>{{ API_URL }}</code></p>

    <div class="demo-container">
      <div class="controls">
        <button @click="refreshData" :disabled="loading" class="refresh-btn">
          {{ loading ? '⏳ Loading...' : '🔄 Refresh Data' }}
        </button>
      </div>

      <div v-if="loading && !data" class="loading">
        <div class="spinner"></div>
        <p>Connecting to backend...</p>
      </div>

      <div v-else-if="error" class="error">
        <h3>❌ Connection Failed</h3>
        <p>{{ error }}</p>
        <p class="hint">Make sure your backend is running and accessible at <code>{{ API_URL }}</code></p>
      </div>

      <div v-else-if="data" class="success">
        <h3>✅ Connection Successful!</h3>
        <div class="data-grid">
          <div class="data-item">
            <strong>🎯 Message:</strong>
            <p>{{ data.message }}</p>
          </div>
          <div class="data-item">
            <strong>⏰ Database Timestamp:</strong>
            <p>{{ new Date(data.timestamp).toLocaleString() }}</p>
          </div>
          <div class="data-item">
            <strong>💾 Database:</strong>
            <p>{{ data.database }}</p>
          </div>
          <div class="data-item">
            <strong>⚡ Server:</strong>
            <p>{{ data.server }}</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.api-demo {
  max-width: 800px;
  margin: 0 auto;
  padding: 2rem;
}

h2 {
  color: #2c3e50;
  text-align: center;
  margin-bottom: 0.5rem;
}

.subtitle {
  text-align: center;
  color: #7f8c8d;
  margin-bottom: 1rem;
}

.api-info {
  text-align: center;
  color: #6c757d;
  margin-bottom: 2rem;
  font-size: 0.9rem;
}

.demo-container {
  background: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 12px;
  padding: 2rem;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.controls {
  text-align: center;
  margin-bottom: 2rem;
}

.refresh-btn {
  background: #007bff;
  color: white;
  border: none;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  cursor: pointer;
  font-size: 1rem;
  transition: background-color 0.2s;
}

.refresh-btn:hover:not(:disabled) {
  background: #0056b3;
}

.refresh-btn:disabled {
  background: #6c757d;
  cursor: not-allowed;
}

.loading {
  text-align: center;
  padding: 2rem;
}

.spinner {
  border: 4px solid #f3f3f3;
  border-top: 4px solid #007bff;
  border-radius: 50%;
  width: 40px;
  height: 40px;
  animation: spin 1s linear infinite;
  margin: 0 auto 1rem;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.error {
  text-align: center;
  color: #dc3545;
  padding: 2rem;
}

.error h3 {
  margin-bottom: 1rem;
}

.hint {
  background: #f8d7da;
  border: 1px solid #f5c6cb;
  border-radius: 4px;
  padding: 0.75rem;
  margin-top: 1rem;
  font-size: 0.9rem;
}

.success {
  color: #155724;
}

.success h3 {
  text-align: center;
  margin-bottom: 2rem;
}

.data-grid {
  display: grid;
  gap: 1.5rem;
}

.data-item {
  background: white;
  padding: 1.5rem;
  border-radius: 8px;
  border: 1px solid #dee2e6;
}

.data-item strong {
  display: block;
  margin-bottom: 0.5rem;
  color: #495057;
}

.data-item p {
  margin: 0;
  color: #212529;
  font-family: 'Courier New', monospace;
  background: #f8f9fa;
  padding: 0.5rem;
  border-radius: 4px;
  word-wrap: break-word;
  overflow-wrap: break-word;
  hyphens: auto;
}

code {
  background: #e9ecef;
  padding: 0.2rem 0.4rem;
  border-radius: 3px;
  font-family: 'Courier New', monospace;
}

@media (min-width: 768px) {
  .data-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}
</style> 