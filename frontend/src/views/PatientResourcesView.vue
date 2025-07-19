<script setup lang="ts">
// Patient Resources functionality will be implemented here
</script>

<template>
  <div class="patient-resources">
    <div class="mb-6">
      <h1 class="text-3xl font-bold text-base-content mb-2">Patient Resources</h1>
      <p class="text-base-content/70">Helpful resources and information for patients</p>
    </div>
    
    <div class="grid gap-6">
      <!-- Quick Access -->
      <div class="card bg-base-200 shadow-lg">
        <div class="card-body">
          <h2 class="card-title text-xl">Quick Access</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mt-4">
            <div class="p-4 bg-base-100 rounded-lg text-center hover:bg-base-300 transition-colors cursor-pointer">
              <div class="text-2xl mb-2">📋</div>
              <h3 class="font-semibold">Test Results</h3>
              <p class="text-sm text-base-content/70">View your test results</p>
            </div>
            <div class="p-4 bg-base-100 rounded-lg text-center hover:bg-base-300 transition-colors cursor-pointer">
              <div class="text-2xl mb-2">📅</div>
              <h3 class="font-semibold">Appointments</h3>
              <p class="text-sm text-base-content/70">Schedule and manage appointments</p>
            </div>
            <div class="p-4 bg-base-100 rounded-lg text-center hover:bg-base-300 transition-colors cursor-pointer">
              <div class="text-2xl mb-2">📊</div>
              <h3 class="font-semibold">Health Records</h3>
              <p class="text-sm text-base-content/70">Access your health records</p>
            </div>
            <div class="p-4 bg-base-100 rounded-lg text-center hover:bg-base-300 transition-colors cursor-pointer">
              <div class="text-2xl mb-2">💊</div>
              <h3 class="font-semibold">Medications</h3>
              <p class="text-sm text-base-content/70">View medication information</p>
            </div>
            <div class="p-4 bg-base-100 rounded-lg text-center hover:bg-base-300 transition-colors cursor-pointer">
              <div class="text-2xl mb-2">📞</div>
              <h3 class="font-semibold">Contact</h3>
              <p class="text-sm text-base-content/70">Contact your healthcare team</p>
            </div>
            <div class="p-4 bg-base-100 rounded-lg text-center hover:bg-base-300 transition-colors cursor-pointer">
              <div class="text-2xl mb-2">❓</div>
              <h3 class="font-semibold">FAQ</h3>
              <p class="text-sm text-base-content/70">Frequently asked questions</p>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Educational Resources -->
      <div class="card bg-base-200 shadow-lg">
        <div class="card-body">
          <h2 class="card-title text-xl">Educational Resources</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mt-4">
            <div class="space-y-4">
              <div class="p-4 bg-base-100 rounded-lg">
                <h3 class="font-semibold mb-2">Understanding Your Results</h3>
                <p class="text-sm text-base-content/70 mb-3">
                  Learn how to interpret your diagnostic test results and what they mean for your health.
                </p>
                <button class="btn btn-sm btn-primary">Learn More</button>
              </div>
              <div class="p-4 bg-base-100 rounded-lg">
                <h3 class="font-semibold mb-2">Preparing for Tests</h3>
                <p class="text-sm text-base-content/70 mb-3">
                  Guidelines and tips for preparing for various diagnostic tests and procedures.
                </p>
                <button class="btn btn-sm btn-primary">Learn More</button>
              </div>
            </div>
            <div class="space-y-4">
              <div class="p-4 bg-base-100 rounded-lg">
                <h3 class="font-semibold mb-2">Health & Wellness</h3>
                <p class="text-sm text-base-content/70 mb-3">
                  Resources for maintaining good health and preventing illness.
                </p>
                <button class="btn btn-sm btn-primary">Learn More</button>
              </div>
              <div class="p-4 bg-base-100 rounded-lg">
                <h3 class="font-semibold mb-2">Support Groups</h3>
                <p class="text-sm text-base-content/70 mb-3">
                  Connect with others who may be going through similar health experiences.
                </p>
                <button class="btn btn-sm btn-primary">Learn More</button>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Forms & Documents -->
      <div class="card bg-base-200 shadow-lg">
        <div class="card-body">
          <h2 class="card-title text-xl">Forms & Documents</h2>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
            <div class="p-4 bg-base-100 rounded-lg">
              <h3 class="font-semibold mb-2">Consent Forms</h3>
              <p class="text-sm text-base-content/70 mb-3">Download and complete required consent forms</p>
              <button class="btn btn-sm btn-outline">Download</button>
            </div>
            <div class="p-4 bg-base-100 rounded-lg">
              <h3 class="font-semibold mb-2">Medical History</h3>
              <p class="text-sm text-base-content/70 mb-3">Update your medical history and information</p>
              <button class="btn btn-sm btn-outline">Update</button>
            </div>
            <div class="p-4 bg-base-100 rounded-lg">
              <h3 class="font-semibold mb-2">Insurance Info</h3>
              <p class="text-sm text-base-content/70 mb-3">Manage your insurance information</p>
              <button class="btn btn-sm btn-outline">Manage</button>
            </div>
            <div class="p-4 bg-base-100 rounded-lg">
              <h3 class="font-semibold mb-2">Privacy Policy</h3>
              <p class="text-sm text-base-content/70 mb-3">Review our privacy and data protection policies</p>
              <button class="btn btn-sm btn-outline">Review</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.patient-resources {
  min-height: 100%;
}
</style> 