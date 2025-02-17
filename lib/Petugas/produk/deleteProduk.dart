import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Petugas/kasir.dart';

Future<void> deleteProduk(int idProduk, BuildContext anggun) async {
  final supabase = Supabase.instance.client;

  //kode untuk menampilkan dialog konfirmasi terlebih dahulu sebelum dihapus dengan alert dialog
  bool? confirmDelete = await showDialog(
    context: anggun,
    builder: (anggun) {
      return AlertDialog(
        elevation: 20,
        backgroundColor: Colors.blue,
        content: Container(
          height: 40,
          width: 50,
          child: Center(
            child: Text(
              'Anda yakin ingin menghapus produk ini?',
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(anggun, true);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.blue),
            ),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(anggun).pop(false);
            },
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.blue),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          )
        ],
      );
    },
  );

  //jika user memilih dihapus, maka lakukan perintah pengahpusan ini
  if(confirmDelete == true) {
    final response = await supabase.from('produk').delete().eq('idProduk', idProduk);

    if (response != null) {
      print('Hapus error : ${response.error!.message}');
    } else {
      Navigator.pushReplacement(anggun, MaterialPageRoute(builder: (anggun) => KasirPetugasPage()));
    }
  }
}
