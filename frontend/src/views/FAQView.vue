<script setup lang="ts">
import { ref, computed } from 'vue'

// FAQ data structure
const faqs = ref([
  {
    id: 1,
    question: "What is AlphaPath?",
    answer: "AlphaPath is an advanced AI-powered diagnostic system that helps healthcare providers make more accurate and timely diagnoses using machine learning and medical imaging analysis.",
    category: "General"
  },
  {
    id: 2,
    question: "How accurate is the AlphaPath model?",
    answer: "The AlphaPath model achieves 99.2% accuracy across multiple diagnostic categories, with continuous validation and improvement protocols in place.",
    category: "Technical"
  },
  {
    id: 3,
    question: "What types of tests can AlphaPath analyze?",
    answer: "AlphaPath can analyze various medical imaging tests including X-rays, MRIs, CT scans, and other diagnostic images across 50+ diagnostic categories.",
    category: "Technical"
  },
  {
    id: 4,
    question: "How do I schedule a test?",
    answer: "You can schedule tests through your healthcare provider who has access to the AlphaPath system. Contact your doctor to learn more about available testing options.",
    category: "Patient"
  },
  {
    id: 5,
    question: "Is my medical data secure?",
    answer: "Yes, all patient data is encrypted and handled in compliance with HIPAA regulations. We use industry-standard security measures to protect your privacy.",
    category: "Privacy"
  },
  {
    id: 6,
    question: "How long does it take to get results?",
    answer: "AlphaPath provides rapid analysis, typically delivering results within minutes for most diagnostic tests, though final reports may take 24-48 hours.",
    category: "Patient"
  }
])

const selectedCategory = ref('All')
const categories = ['All', 'General', 'Technical', 'Patient', 'Privacy']

const filteredFaqs = computed(() => {
  if (selectedCategory.value === 'All') {
    return faqs.value
  }
  return faqs.value.filter(faq => faq.category === selectedCategory.value)
})
</script>

<template>
  <div class="faq">
    <div class="mb-6">
      <h1 class="text-3xl font-bold text-base-content mb-2">Frequently Asked Questions</h1>
      <p class="text-base-content/70">Find answers to common questions about AlphaPath</p>
    </div>
    
    <div class="grid gap-6">
      <!-- Category Filter -->
      <div class="card bg-base-200 shadow-lg">
        <div class="card-body">
          <h2 class="card-title text-xl">Filter by Category</h2>
          <div class="flex flex-wrap gap-2 mt-4">
            <button
              v-for="category in categories"
              :key="category"
              @click="selectedCategory = category"
              :class="[
                'btn btn-sm',
                selectedCategory === category ? 'btn-primary' : 'btn-outline'
              ]"
            >
              {{ category }}
            </button>
          </div>
        </div>
      </div>
      
      <!-- FAQ List -->
      <div class="space-y-4">
        <div
          v-for="faq in filteredFaqs"
          :key="faq.id"
          class="card bg-base-200 shadow-lg"
        >
          <div class="card-body">
            <div class="flex items-start justify-between">
              <div class="flex-1">
                <h3 class="text-lg font-semibold text-base-content mb-2">
                  {{ faq.question }}
                </h3>
                <p class="text-base-content/70">{{ faq.answer }}</p>
              </div>
              <div class="badge badge-secondary ml-4">{{ faq.category }}</div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Contact Support -->
      <div class="card bg-base-200 shadow-lg">
        <div class="card-body text-center">
          <h2 class="card-title text-xl justify-center">Still Have Questions?</h2>
          <p class="text-base-content/70 mb-4">
            Can't find what you're looking for? Contact our support team for assistance.
          </p>
          <div class="flex gap-2 justify-center">
            <button class="btn btn-primary">Contact Support</button>
            <button class="btn btn-secondary">Live Chat</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.faq {
  min-height: 100%;
}
</style> 