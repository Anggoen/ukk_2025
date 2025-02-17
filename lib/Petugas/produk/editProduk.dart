import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Petugas/kasir.dart';

class EditProdukPage extends StatefulWidget {
  final Map<String, dynamic> produk;

  EditProdukPage({required this.produk});

  @override
  State<EditProdukPage> createState() => _EditProdukPageState();
}

class _EditProdukPageState extends State<EditProdukPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaProduk = TextEditingController();
  final TextEditingController _hargaProduk = TextEditingController();
  final TextEditingController _stok = TextEditingController();

  @override
  void initState() {
    super.initState();
    //kode untu memunculkan data lama yang nanti akan diperbarui
    _namaProduk.text = widget.produk['namaProduk'];
    _hargaProduk.text = '${widget.produk['harga']}';
    _stok.text = '${widget.produk['stok']}';
  }

  //fungsi untuk memperbarui produk di supabase
  Future<void> editProduk() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await Supabase.instance.client
        .from('produk')
        .update({
          'namaProduk': _namaProduk.text,
          'harga': int.tryParse(_hargaProduk.text),
          'stok': int.tryParse(_stok.text),
        })
        .eq('idProduk', widget.produk['idProduk'])
        .select();

    //jika kode diatas mengalami eror maka munculkan pesan
    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data gagal diperbarui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil diperbarui')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KasirPetugasPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman Edit',
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
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 3))
                    ]),
                width: 300,
                height: 350,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 10, left: 10, right: 10),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _namaProduk,
                            decoration: InputDecoration(
                                labelText: 'Nama Produk',
                                hintText: 'Masukkan nama produk baru',
                                prefixIcon: Icon(Icons.abc),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan Nama Produk dulu';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _hargaProduk,
                            decoration: InputDecoration(
                                labelText: 'Harga Produk',
                                hintText: 'Masukkan harga produk baru',
                                prefixIcon: Icon(Icons.money),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan Harga Produk dulu';
                              } else {
                                if (double.tryParse(value) == null) {
                                  return 'Harga harus berupa angka';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _stok,
                            decoration: InputDecoration(
                                labelText: 'Stok',
                                hintText: 'Masukkan stok baru',
                                prefixIcon: Icon(Icons.circle),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan Stok dulu';
                              } else {
                                if (double.tryParse(value) == null) {
                                  return 'Stok harus berupa angka';
                                }
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          ElevatedButton(
                            onPressed: editProduk,
                            child: Text(
                              'Perbarui',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          ),
                        ],
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
