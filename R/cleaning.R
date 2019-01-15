library(tidyverse)
library(magrittr)

bandung <- read_csv("extdata/Kopi Darat useR! Bandung (Responses) - Form Responses 1.csv", na = c("", "NA", "-", "--"))

bandung %<>%
  janitor::clean_names() %>%
  rename(
    lama_penggunaan = berapa_lama_anda_menggunakan_r,
    alasan_penggunaan = jika_anda_telah_menggunakan_r_apa_alasan_anda_menggunakan_r,
    aplikasi_penggunaan = jika_anda_telah_menggunakan_r_bagaimana_anda_mengaplikasikan_r_dalam_bidang_pekerjaan_anda,
    paket = jika_anda_telah_menggunakan_r_package_paket_apa_yang_paling_membantu_bidang_pekerjaan_anda_jika_lebih_dari_satu_pisahkan_nama_paket_dengan_koma,
    mengetahui_shinyapps = apakah_anda_mengetahui_atau_pernah_mendengar_mengenai_shinyapps,
    membuat_shinyapps = apakah_anda_pernah_membuat_atau_mengembangkan_shinyapps,
    alamat_shinyapps = jika_berkenan_silakan_tuliskan_tautan_shinyapps_yang_anda_buat_atau_kembangkan,
    kritik_grup = kritik_dan_saran_untuk_grup_belajar_gnu_r_indonesia,
    saran_kopdar = ide_dan_saran_untuk_kopdar_use_r_bandung
  )
glimpse(bandung)

jakarta <- read_csv("extdata/Kopi Darat useR! Jakarta (Responses) - Form Responses 1.csv", na = c("", "NA", "-", "--"))

jakarta %<>%
  janitor::clean_names() %>%
  rename(
    lama_penggunaan = berapa_lama_anda_menggunakan_r,
    alasan_penggunaan = jika_anda_telah_menggunakan_r_apa_alasan_anda_menggunakan_r,
    aplikasi_penggunaan = jika_anda_telah_menggunakan_r_bagaimana_anda_mengaplikasikan_r_dalam_bidang_pekerjaan_anda,
    paket = jika_anda_telah_menggunakan_r_package_paket_apa_yang_paling_membantu_bidang_pekerjaan_anda_jika_lebih_dari_satu_pisahkan_nama_paket_dengan_koma,
    mengetahui_shinyapps = apakah_anda_mengetahui_atau_pernah_mendengar_mengenai_shinyapps,
    membuat_shinyapps = apakah_anda_pernah_membuat_atau_mengembangkan_shinyapps,
    alamat_shinyapps = jika_berkenan_silakan_tuliskan_tautan_shinyapps_yang_anda_buat_atau_kembangkan,
    kritik_grup = kritik_dan_saran_untuk_grup_belajar_gnu_r_indonesia,
    saran_kopdar = ide_dan_saran_untuk_kopdar_use_r_jakarta
  )

glimpse(jakarta)

cln_all <-
  bind_rows(
    bandung = bandung,
    jakarta = jakarta,
    .id = "lokasi_kopdar"
  ) %>%
  select(-timestamp, -nomor_hp) %>%
  mutate_if(is.character, str_to_lower) %>%
  mutate(
    alamat_shinyapps = str_remove_all(alamat_shinyapps, "htt(p|ps)://")
  )
glimpse(cln_all)
write_csv(cln_all, "input/db_user_indonesia.csv")
