<script setup>
import { ref, onMounted } from 'vue'

const daftarTugas = ref([])

onMounted(async () => {
  // Menggunakan VITE_API_URL, bukan ditulis langsung
  const response = await fetch(`${import.meta.env.VITE_API_URL}/api/tugas`)
  daftarTugas.value = await response.json()
})
</script>

<template>
  <main>
    <h1>Daftar Tugas dari Laravel:</h1>
    <ul>
      <li v-for="tugas in daftarTugas" :key="tugas.id">
        {{ tugas.nama_tugas }}
      </li>
    </ul>
  </main>
</template>