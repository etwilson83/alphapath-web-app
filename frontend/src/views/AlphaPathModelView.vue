<script setup lang="ts">
// AlphaPath Model Information functionality will be implemented here
</script>

<template>
  <div class="alphapath-model">
    <div class="mb-6">
      <h1 class="text-3xl font-bold text-base-content mb-2">AlphaPath Model Information</h1>
      <p class="text-base-content/70">Learn about our AI diagnostic model and its capabilities</p>
    </div>
    
    <div class="grid gap-6">
      <!-- Model Overview -->
      <div class="card bg-base-200 shadow-lg">
        <div class="card-body">
          <h2 class="card-title text-xl">Model Overview</h2>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
            <div class="text-center p-4 bg-base-100 rounded-lg">
              <div class="text-3xl font-bold text-primary">99.2%</div>
              <div class="text-sm text-base-content/70">Accuracy Rate</div>
            </div>
            <div class="text-center p-4 bg-base-100 rounded-lg">
              <div class="text-3xl font-bold text-secondary">50+</div>
              <div class="text-sm text-base-content/70">Diagnostic Categories</div>
            </div>
            <div class="text-center p-4 bg-base-100 rounded-lg">
              <div class="text-3xl font-bold text-accent">24/7</div>
              <div class="text-sm text-base-content/70">Availability</div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Model Details -->
      <div class="card bg-base-200 shadow-lg">
        <div class="card-body">
          <h2 class="card-title text-xl">Model Details</h2>
          <div class="space-y-4 mt-4">
            <div>
              <h3 class="font-semibold text-base-content mb-2">Technology Stack</h3>
              <p class="text-base-content/70">
                AlphaPath utilizes advanced machine learning algorithms including deep neural networks, 
                computer vision, and natural language processing to provide accurate diagnostic insights.
              </p>
            </div>
            <div>
              <h3 class="font-semibold text-base-content mb-2">Training Data</h3>
              <p class="text-base-content/70">
                Trained on millions of anonymized medical records and diagnostic images, 
                ensuring comprehensive coverage across various medical conditions and demographics.
              </p>
            </div>
            <div>
              <h3 class="font-semibold text-base-content mb-2">Validation & Testing</h3>
              <p class="text-base-content/70">
                Rigorously validated through clinical trials and peer-reviewed studies, 
                with continuous monitoring and improvement protocols in place.
              </p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Capabilities -->
      <div class="card bg-base-200 shadow-lg">
        <div class="card-body">
          <h2 class="card-title text-xl">Model Capabilities</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
            <div class="p-4 bg-base-100 rounded-lg">
              <h3 class="font-semibold mb-2">Image Analysis</h3>
              <p class="text-sm text-base-content/70">Advanced computer vision for medical imaging</p>
            </div>
            <div class="p-4 bg-base-100 rounded-lg">
              <h3 class="font-semibold mb-2">Text Processing</h3>
              <p class="text-sm text-base-content/70">NLP for medical report analysis</p>
            </div>
            <div class="p-4 bg-base-100 rounded-lg">
              <h3 class="font-semibold mb-2">Pattern Recognition</h3>
              <p class="text-sm text-base-content/70">Identifying complex diagnostic patterns</p>
            </div>
            <div class="p-4 bg-base-100 rounded-lg">
              <h3 class="font-semibold mb-2">Risk Assessment</h3>
              <p class="text-sm text-base-content/70">Predictive analytics for patient outcomes</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.alphapath-model {
  min-height: 100%;
}
</style> 