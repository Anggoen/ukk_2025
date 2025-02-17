import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Admin/kasir.dart';

class InsertProduk extends StatefulWidget {
  const InsertProduk({super.key});

  @override
  State<InsertProduk> createState() => _InsertProdukState();
}

class _InsertProdukState extends State<InsertProduk> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaProduk = TextEditingController();
  final TextEditingController _hargaProduk = TextEditingController();
  final TextEditingController _stokProduk = TextEditingController();

  // Fungsi untuk memeriksa apakah produk sudah ada di database
  Future<bool> hhh(String namaBarang) async {
    final response = await Supabase.instance.client
        .from('produk')
        .select()
        .eq('namaProduk', namaBarang)
        .maybeSingle();
    return response != null;
  }

  // Fungsi untuk menambah produk
  Future<void> _tambahProduk() async {
    final namaProduk = _namaProduk.text;
    final harga = _hargaProduk.text;
    final stok = _stokProduk.text;

    // Validasi input sebelum lanjut ke proses database
    if (namaProduk.isEmpty || harga.isEmpty || stok.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua Data Harus Diisi')),
      );
      return;
    }

    // Cek apakah produk sudah ada
    bool exis = await hhh(namaProduk);
    if (exis) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk sudah dimasukkan')),
      );
      return;
    }

    // Menyimpan produk baru jika tidak ada duplikasi
    final anggun = await Supabase.instance.client.from('produk').insert([
      {
        'namaProduk': namaProduk,
        'harga': harga,
        'stok': stok,
      }
    ]);

    if (anggun.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${anggun.error!.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk Berhasil Ditambahkan')),
      );

      // Mengosongkan kolom input setelah sukses
      _namaProduk.clear();
      _hargaProduk.clear();
      _stokProduk.clear();

      // Navigasi kembali ke halaman KasirAdminPage
      Navigator.pop(context, true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KasirAdminPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Produk',
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
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey, blurRadius: 7, offset: Offset(0, 3))
                    ]),
                width: 300,
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 10, left: 10, right: 10),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _namaProduk,
                              decoration: InputDecoration(
                                labelText: 'Nama Produk',
                                hintText: 'Masukkan Produk',
                                prefixIcon: Icon(Icons.abc),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukkan Nama Produk';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _hargaProduk,
                              decoration: InputDecoration(
                                labelText: 'Harga Produk',
                                hintText: 'Masukkan Harga Produk',
                                prefixIcon: Icon(Icons.money),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Masukkan Harga Produk";
                                } else {
                                  if (double.tryParse(value) == null) {
                                    return "Harga harus berupa angka";
                                  }
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _stokProduk,
                              decoration: InputDecoration(
                                labelText: 'Stok',
                                hintText: 'Masukkan Stok Produk',
                                prefixIcon: Icon(Icons.circle),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Masukkan Stok Produk";
                                } else {
                                  if (double.tryParse(value) == null) {
                                    return "Stok Harus berupa angka";
                                  }
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 20.0),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _tambahProduk();
                                }
                              },
                              child: Text(
                                'Tambah',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
