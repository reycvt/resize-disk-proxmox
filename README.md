# 🔧 Resize Disk Otomatis di VM Ubuntu (LVM) setelah Penambahan Disk di Proxmox

Script ini digunakan untuk memperbesar kapasitas disk di dalam virtual machine (VM) berbasis Ubuntu yang menggunakan LVM, setelah ukuran disk ditambah melalui Proxmox.

---

## 🧾 Prasyarat

- VM menggunakan **GPT partition table**.
- Disk menggunakan **LVM**.
- Tambahan kapasitas disk sudah diberikan melalui Proxmox UI (Hardware → Hard Disk → Resize disk).
- Jalankan script ini **di dalam VM guest** (bukan di Proxmox host).
- Harus dijalankan sebagai `root` atau menggunakan `sudo`.

---

## 📥 Instalasi

1. SSH ke dalam VM.
2. Buat file script:
   ```bash
   nano resize-disk.sh
