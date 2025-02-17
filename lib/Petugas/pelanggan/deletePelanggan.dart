import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Petugas/kasir.dart';

Future<void> deletePelanggan(int idPelanggan, BuildContext context) async {
  final supabase = Supabase.instance.client;

  // Kode untuk menampilkan dialog konfirmasi terlebih dahulu sebelum benar-benar dihapus
  bool? confirmDelete = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 20,
        backgroundColor: Colors.blue,
        content: Text(
          'Anda yakin ingin menghapus produk ini?',
          style: TextStyle(fontSize: 15.0, color: Colors.white),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.blue),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false);
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

  // Jika user memilih untuk dihapus, maka lakukan perintah penghapusan ini
  if(confirmDelete == true) {
    final response = await supabase.from('pelanggan').delete().eq('idPelanggan', idPelanggan);

    if (response != null) {
      print('Hapus error : ${response.error!.message}');
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => KasirPetugasPage()));
    }
  }
}
