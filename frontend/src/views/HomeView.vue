<script setup lang="ts">
import { ref, onMounted } from 'vue'

// 1. Definisikan bentuk data tugas dari Laravel
interface Tugas {
  id: number
  nama_tugas: string
}

// 2. Berikan tipe data <Tugas[]> pada ref
const daftarTugas = ref<Tugas[]>([])

onMounted(async () => {
  const response = await fetch(`${import.meta.env.VITE_API_URL}/api/tugas`)
  daftarTugas.value = await response.json()
})
</script>

<template>
  <main style="padding: 2rem; font-family: sans-serif;">
    <h1>Daftar Tugas dari Laravel:</h1>
    <ul>
      <li v-for="tugas in daftarTugas" :key="tugas.id">
        {{ tugas.nama_tugas }}
      </li>
    </ul>
  </main>
</template>