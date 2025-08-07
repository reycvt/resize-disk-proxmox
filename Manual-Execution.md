🛠️ Manual Resize Disk Ubuntu (LVM + GPT) Setelah Tambah Kapasitas di Proxmox
==============================================================================

Dokumentasi ini menjelaskan langkah-langkah **manual tanpa script** untuk melakukan resize disk di dalam VM **Ubuntu dengan LVM** setelah ukuran disk ditambahkan melalui Proxmox.

🧾 Prasyarat
------------
- VM menggunakan **GPT partition table**
- Menggunakan **LVM (Logical Volume Management)**
- Tambahan kapasitas disk sudah dilakukan di Proxmox (Hardware → Hard Disk → Resize Disk)
- Jalankan semua perintah sebagai `root` atau menggunakan `sudo`
- Perintah dijalankan di **dalam VM Ubuntu**, bukan di Proxmox host

🧭 Langkah-langkah Manual
--------------------------

1. Cek apakah disk sudah bertambah ukurannya
   ```bash
   lsblk
   ```

2. Masuk ke parted
   ```bash
   parted /dev/sda
   ```
   Lalu:
   ```bash
   print
   ```

   Jika muncul:
   ```
   Warning: Not all of the space available to /dev/sda appears to be used...
   Fix/Ignore?
   ```
   Ketik:
   ```
   Fix
   ```

   Resize partisi ketiga (`/dev/sda3`):
   ```bash
   resizepart 3 100%
   Yes
   ```

   Keluar dari parted:
   ```bash
   quit
   ```

3. Resize Physical Volume (PV)
   ```bash
   pvresize /dev/sda3
   ```

4. Temukan Path Logical Volume (LV)
   ```bash
   lvdisplay | grep "LV Path"
   ```

   Contoh output:
   ```
   LV Path                /dev/ubuntu-vg/lv-0
   ```

5. Perbesar Logical Volume dan Filesystem
   ```bash
   lvextend -r -l +100%FREE /dev/ubuntu-vg/lv-0
   ```

6. Verifikasi Hasil
   ```bash
   df -hT /
   ```

   Contoh:
   ```
   Filesystem                    Type  Size  Used Avail Use% Mounted on
   /dev/mapper/ubuntu--vg-lv--0 ext4  170G  116G   48G   71% /
   ```

📌 Catatan
-----------
- Backup penting sebelum resize disk
- Langkah ini diasumsikan partisi utama ada di `/dev/sda3`
- Jika partisi LVM bukan di `/dev/sda3`, sesuaikan langkah-langkahnya
- Jangan dilakukan sembarangan di lingkungan production tanpa uji coba

📎 Lisensi
----------
MIT License. Bebas digunakan untuk keperluan administrasi sistem.
