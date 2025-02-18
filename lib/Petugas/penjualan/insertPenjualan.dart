import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ukk_2025/Petugas/kasir.dart';

class PenjualanPetugas extends StatefulWidget {
  const PenjualanPetugas({super.key});

  @override
  State<PenjualanPetugas> createState() => _PenjualanPetugasState();
}

class _PenjualanPetugasState extends State<PenjualanPetugas> {
  final supabase = Supabase.instance.client;
  DateTime currentDate = DateTime.now();

  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> produk = [];
  Map<String, dynamic>? pilihPelanggan;
  Map<String, dynamic>? pilihProduk;

  TextEditingController quantityController = TextEditingController();
    double subtotal = 0;
    double totalHarga = 0;
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    fetchProduk();
  }

  //mengambil data pelanggan dari supabase
  Future<void> fetchPelanggan() async {
    final response = await supabase.from('pelanggan').select();
    setState(() {
      pelanggan = List<Map<String, dynamic>>.from(response);
    });
  }

  //mengambil data produk dari supabase
  Future<void> fetchProduk() async {
    final response = await supabase.from('produk').select();
    setState(() {
      produk = List<Map<String, dynamic>>.from(response);
    });
  }

  //menambahkan produk ke keranjang
  void addToCart() {
    if (pilihProduk != null && quantityController.text.isNotEmpty) {
      int quantity = int.parse(quantityController.text);
      double price = pilihProduk!['harga'];
      double itemSubtotal = price * quantity;

      setState(() {
        cart.add({
          'idProduk': pilihProduk!['idProduk'],
          'namaProduk': pilihProduk!['namaProduk'],
          'jumlahProduk': quantity,
          'subtotal': itemSubtotal
        });
        totalHarga += itemSubtotal;
        pilihProduk!['stok'] -= quantity;
      });
    }
  }

  //mengirim transaksi penjualan ke database
  Future<void> submitPenjualan() async {
    try {
      final penjualanResponse = await supabase
          .from('penjualan')
          .insert({
            'tanggalPenjualan': DateFormat('yyyy-MM-dd').format(currentDate),
          })
          .select()
          .single();

      final penjualanId = penjualanResponse['idPenjualan'];

      for (var item in cart) {
        await supabase.from('detailPenjualan').insert({
          'idPenjualan': penjualanId,
          'idProduk': item['idProduk'],
          'jumlahProduk': item['jumlahProduk'],
          'subtotal': item['subtotal'],
        });

        await supabase.from('produk').update({
          'stok': pilihProduk!['stok'],
        }).eq('idProduk', item['idProduk']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi berhasil disimpan')),
      );

      //jadi ketika sudah selesai , maka jalankan perintah cart.clean yg artinya bersihkan data yang baru saja selesai diinput
      setState(() {
        cart.clear();
        totalHarga = 0;
      });
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $error')));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => KasirPetugasPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Transaksi Penjualan',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 7, offset: Offset(0, 3))
                ]),
            width: 320,
            height: 430,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: 'Pilih Pelanggan',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    items: pelanggan.map((customer) {
                      return DropdownMenuItem(
                          value: customer,
                          child: Text(customer['namaPelanggan']));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        pilihPelanggan = value as Map<String, dynamic>;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: 'Pilih Produk',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    items: produk.map((product) {
                      return DropdownMenuItem(
                        value: product,
                        child: Text(product['namaProduk']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        pilihProduk = value as Map<String, dynamic>;
                        subtotal = pilihProduk!['harga'] *
                            (quantityController.text.isEmpty
                                ? 0
                                : int.parse(quantityController.text));
                      });
                    },
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextFormField(
                    controller: quantityController,
                    decoration: InputDecoration(
                        labelText: 'Jumlah Produk',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        subtotal = pilihProduk != null
                            ? pilihProduk!['harga'] * int.parse(value)
                            : 0;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: addToCart,
                    child: Text(
                      'Tambahkan ke Keranjang',
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                  Divider(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final item = cart[index];
                        return ListTile(
                          title: Text(item['namaProduk']),
                          subtitle: Text(
                              'Jumlah: ${item['jumlahProduk']} - Subtotal: Rp ${item['subtotal']}'),
                        );
                      },
                    ),
                  ),
                  Divider(),
                  Text(
                    'Total Harga: Rp $totalHarga',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: submitPenjualan,
                    child: Text(
                      'Simpan Transaksi',
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
