import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Admin/kasir.dart';

Future<void> deleteProduk(int idProduk, BuildContext context) async {
  final supabase = Supabase.instance.client;

  // Menampilkan dialog konfirmasi sebelum menghapus
  bool? confirmDelete = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 20,
        backgroundColor: Colors.blue,
        content: SizedBox(
          height: 60, // Sesuaikan ukuran agar teks tidak terpotong
          child: Center(
            child: Text(
              'Anda yakin ingin menghapus produk ini?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true); // Konfirmasi hapus
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.blue),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, false); // Batal
            },
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.blue),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          ),
        ],
      );
    },
  );

  // Jika user menekan tombol "Hapus", lanjutkan proses penghapusan
  if (confirmDelete == true) {
    try {
      await supabase.from('produk').delete().eq('idProduk', idProduk);

      // Pastikan widget masih aktif sebelum melakukan navigasi
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk berhasil dihapus')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KasirAdminPage()),
      );
    } catch (error) {
      // Tangkap error dan tampilkan di Snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus produk: $error')),
        );
      }
    }
  }
}
