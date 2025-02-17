import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Petugas/kasir.dart';

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


  Future<void> _tambahProduk() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final namaProduk = _namaProduk.text;
    final harga = _hargaProduk.text;
    final stok = _stokProduk.text;

    //validasi input
    if (namaProduk.isEmpty || harga.isEmpty || stok.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua Data Harus Diisi')),
      );
      return;
    }
    final anggun = await Supabase.instance.client.from('produk').insert([
      {
        'namaProduk': namaProduk,
        'harga': harga,
        'stok': stok,
      }
    ]);

    if (anggun != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${anggun.error!.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Produk Berhasil Ditambahkan')),
      );

      //setelah form selesai maka langsung hapus kolom inputnya
      _namaProduk.clear();
      _hargaProduk.clear();
      _stokProduk.clear();

      Navigator.pop(context, true);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => KasirPetugasPage()));
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
                                        borderRadius: BorderRadius.circular(10))),
                                        validator: (value) {
                                          if(value == null || value.isEmpty) {
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
                                        borderRadius: BorderRadius.circular(10))),
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
                                        borderRadius: BorderRadius.circular(10))),
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
                                  if (_formKey.currentState!.validate())
                                    _tambahProduk();
                                },
                                child: Text(
                                  'Tambah',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                              )
                            ],
                          ))
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
