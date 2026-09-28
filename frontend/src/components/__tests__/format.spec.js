import { describe, it, expect } from 'vitest'
import { formatJudul } from '../../utils/format'

describe('Fungsi Format Judul', () => {
  it('harus mengubah teks menjadi huruf besar semua', () => {
    expect(formatJudul('vue')).toBe('SALAH')
  })
})