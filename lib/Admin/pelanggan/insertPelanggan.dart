import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Admin/kasir.dart';

class InsertPelanggan extends StatefulWidget {
  const InsertPelanggan({super.key});

  @override
  State<InsertPelanggan> createState() => _InsertPelangganState();
}

class _InsertPelangganState extends State<InsertPelanggan> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaPelanggan = TextEditingController();
  final TextEditingController _alamatPelanggan = TextEditingController();
  final TextEditingController _nomorTelepon = TextEditingController();

  Future<bool> hhhh(String namaBarang) async {
    final response = await Supabase.instance.client
        .from('pelanggan')
        .select()
        .eq('namaPelanggan ', namaBarang)
        .maybeSingle();
    return response != null;
  }

  // cek apakah produk  sudah ada
  
  Future<void> _tambahPelanggan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final namaPelanggan = _namaPelanggan.text;
    final alamat = _alamatPelanggan.text;
    final nomorTelepon = _nomorTelepon.text;

    //validasi input
    if (namaPelanggan.isEmpty || alamat.isEmpty || nomorTelepon.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Semua Data Harus Diisi')));
      return;
    }
    final anggun = await Supabase.instance.client.from('pelanggan').insert([
      {
        'namaPelanggan': _namaPelanggan.text,
        'alamat': _alamatPelanggan.text,
        'nomorTelepon': _nomorTelepon.text,
      }
    ]);

    if (anggun != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${anggun.error!.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pelanggan Berhasil Ditambahkan')),
      );

      _namaPelanggan.clear();
      _alamatPelanggan.clear();
      _nomorTelepon.clear();

      Navigator.pop(context, true);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => KasirAdminPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Pelanggan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ]),
                width: 300,
                height: 350,
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 40, bottom: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _namaPelanggan,
                              decoration: InputDecoration(
                                  labelText: 'Nama Pelanggan',
                                  hintText: 'Masukkan Nama Pelanggan',
                                  prefixIcon: Icon(Icons.abc),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (anggun) {
                                if (anggun == null || anggun.isEmpty) {
                                  return 'Masukkan Nama Pelanggan';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _alamatPelanggan,
                              decoration: InputDecoration(
                                  labelText: 'Alamat Pelanggan',
                                  hintText: 'Masukkan Alamat Pelanggan',
                                  prefixIcon: Icon(Icons.home),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (anggun) {
                                if (anggun == null || anggun.isEmpty) {
                                  return 'Masukkan Alamat Pelanggan';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _nomorTelepon,
                              decoration: InputDecoration(
                                  labelText: 'Nomor Telepon',
                                  hintText: 'Masukkan Nomor Telepon',
                                  prefixIcon: Icon(Icons.circle),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              validator: (anggun) {
                                if (anggun == null || anggun.isEmpty) {
                                  return 'Masukkan Nomor Telepon';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate())
                                  _tambahPelanggan();
                              },
                              child: Text(
                                'Tambah',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
