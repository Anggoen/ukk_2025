import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Admin/kasir.dart';

Future<void> deleteUser( int id, BuildContext context) async {
  final supabase = Supabase.instance.client;

  //kode untuk menampilkan dialog konirmasi terlebih dahulu sebelum dihapus
  bool? confirmDelete = await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        elevation: 20,
        backgroundColor: Colors.blue,
        content: Container(
          height: 40,
          width: 50,
          child: Center(
            child: Text(
              'Anda yakin ingin menghapus user ini?',
              style: TextStyle(fontSize: 24.0, color: Colors.white),
            ),
          ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          ),
        ],
      );
    },
  );

  // jika user memilih dihapus, maka lakukan perintah penghapusan ini
  if (confirmDelete == true) {
    final response =
     await supabase.from('user').delete().eq('id', id);

    if (response != null) {
      print('Hapus error : ${response.error!.messsage}');
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => KasirAdminPage()));
    }
  }
}
