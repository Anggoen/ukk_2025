import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ukk_2025/Admin/kasir.dart';

class PenjualanAdmin extends StatefulWidget {
  const PenjualanAdmin({super.key});

  @override
  State<PenjualanAdmin> createState() => PenjualanAdminState();
}

class PenjualanAdminState extends State<PenjualanAdmin> {
  final supabase = Supabase.instance.client;
  DateTime currentDate = DateTime.now();

  List<Map<String, dynamic>> pelanggan = [];
  List<Map<String, dynamic>> produk = [];
  Map<String, dynamic>? selectedCustomer;
  Map<String, dynamic>? selectedProduct;

  TextEditingController quantityController = TextEditingController();
  double subtotal = 0;
  double totalPrice = 0;
  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    fetchPelanggan();
    fetchProduk();
  }

  // Mengambil data pelanggan dari Supabase
  Future<void> fetchPelanggan() async {
    final response = await supabase.from('pelanggan').select();
    setState(() {
      pelanggan = List<Map<String, dynamic>>.from(response);
    });
  }

  // Mengambil data produk dari Supabase
  Future<void> fetchProduk() async {
    final response = await supabase.from('produk').select();
    setState(() {
      produk = List<Map<String, dynamic>>.from(response);
    });
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(amount).replaceAll(',', '.');
  }

  // Menambahkan produk ke keranjang
  void addToCart() {
    if (selectedProduct != null && quantityController.text.isNotEmpty) {
      int quantity = int.parse(quantityController.text);
      double price = selectedProduct!['harga'];
      double itemSubtotal = price * quantity;

      setState(() {
        cart.add({
          'idProduk': selectedProduct!['idProduk'],
          'namaProduk': selectedProduct!['namaProduk'],
          'jumlahProduk': quantity,
          'subtotal': itemSubtotal,
        });
        totalPrice += itemSubtotal;
        selectedProduct!['stok'] -= quantity;
      });
    }
  }

  // Mengirim transaksi penjualan ke database
  Future<void> submitPenjualan() async {
    try {
      final penjualanResponse = await supabase
          .from('penjualan')
          .insert({
            'tanggalPenjualan': DateFormat('dd MMMM yyyy').format(currentDate),
            'totalHarga': totalPrice,
            'idPelanggan': selectedCustomer!['idPelanggan'],
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
          'stok': selectedProduct!['stok'],
        }).eq('idProduk', item['idProduk']);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaksi berhasil disimpan')),
      );
      setState(() {
        cart.clear();
        totalPrice = 0;
      });
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $error')));
    }

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => KasirAdminPage()));
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
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown untuk memilih pelanggan
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                        labelText: 'Pilih Pelanggan',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    items: pelanggan.map((customer) {
                      return DropdownMenuItem(
                        value: customer,
                        child: Text(customer['namaPelanggan']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCustomer = value as Map<String, dynamic>;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  // Dropdown untuk memilih produk
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
                        selectedProduct = value as Map<String, dynamic>;
                        subtotal = selectedProduct!['harga'] *
                            (quantityController.text.isEmpty
                                ? 0
                                : int.parse(quantityController.text));
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  // Input jumlah produk
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(
                        labelText: 'Jumlah Produk',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        subtotal = selectedProduct != null
                            ? selectedProduct!['harga'] * int.parse(value)
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
                  Text('Total Harga: Rp ${formatCurrency(totalPrice.toInt())}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: submitPenjualan,
                    child: Text(
                      'Simpan Transaksi',
                      style: TextStyle(color: Colors.white),
                    ),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
