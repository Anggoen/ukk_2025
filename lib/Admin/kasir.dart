import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Admin/pelanggan/deletePelanggan.dart';
import 'package:ukk_2025/Admin/pelanggan/editPelanggan.dart';
import 'package:ukk_2025/Admin/pelanggan/insertPelanggan.dart';
import 'package:ukk_2025/Admin/penjualan/insertPennjualan.dart';
import 'package:ukk_2025/Admin/produk/deleteProduk.dart';
import 'package:ukk_2025/Admin/produk/editProduk.dart';
import 'package:ukk_2025/Admin/produk/insertProduk.dart';
import 'package:ukk_2025/Admin/user/deleteUser.dart';
import 'package:ukk_2025/Admin/user/editUser.dart';
import 'package:ukk_2025/Admin/user/insertUser.dart';
import 'package:ukk_2025/login.dart';
import 'package:intl/intl.dart';
import 'package:ukk_2025/Admin/penjualan/strukPrinter.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(KasirAdminPage());
}

class KasirAdminPage extends StatelessWidget {
  const KasirAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Kasir',
      debugShowCheckedModeBanner: false,
      home: KasirFlutter(),
    );
  }
}

class KasirFlutter extends StatefulWidget {
  const KasirFlutter({super.key});

  @override
  State<KasirFlutter> createState() => _KasirFlutterState();
}

class _KasirFlutterState extends State<KasirFlutter> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    ProdukPage(),
    PelangganPage(),
    PenjualanAdminPage(),
    DetailPenjualanAdminPage(),
    UserPage(),
    ProfileAdmin(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[
          _selectedIndex], // menampilkan halaman sesuai dengan index yang dipilih
      bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          currentIndex: _selectedIndex, // menunjukkn index yang dipilih
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.blue,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.check_box_outline_blank), label: 'Produk'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Pelanggan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Penjualan'),
            BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Detail'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
            BottomNavigationBarItem(
                icon: Icon(Icons.animation), label: 'Profile'),
          ]),
    );
  }
}

// halaman produk

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  List<Map<String, dynamic>> produkAnggun = [];
  List<Map<String, dynamic>> filteredProduk = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchproduk();
    searchController.addListener(_filterProduk);
  }

  Future<void> fetchproduk() async {
    final anggoen = await Supabase.instance.client.from('produk').select();

    setState(() {
      produkAnggun = List<Map<String, dynamic>>.from(anggoen);
      filteredProduk = produkAnggun;
    });
  }

  void _filterProduk() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredProduk = produkAnggun
          .where((produk) =>
              produk['namaProduk'].toString().toLowerCase().contains(query))
          .toList();
    });
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(amount).replaceAll(',', '.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Cari Produk...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: fetchproduk,
              icon: Icon(Icons.refresh),
              color: Colors.white),
        ],
      ),
      body: filteredProduk.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredProduk.length,
              itemBuilder: (context, index) {
                final book = filteredProduk[index];
                return Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: ListTile(
                    title: Text(
                      book['namaProduk'] ?? 'No namaProduk',
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp. ${formatCurrency(book['harga'])}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Stok: ${book['stok']}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditProdukPage(produk: book)));
                            },
                            icon: Icon(Icons.edit, color: Colors.blue)),
                        IconButton(
                            onPressed: () {
                              deleteProduk(book['idProduk'], context);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                );
              }),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => InsertProduk()));

            // jika result true maka refresh halaman produk dengan kode berikut
            if (result == true) {
              fetchproduk();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// halaman pelanggan
class PelangganPage extends StatefulWidget {
  const PelangganPage({super.key});

  @override
  State<PelangganPage> createState() => _PelangganPageState();
}

class _PelangganPageState extends State<PelangganPage> {
  List<Map<String, dynamic>> pelangganAnggun = [];

  @override
  void initState() {
    super.initState();
    fetchpelanggan();
  }

  Future<void> fetchpelanggan() async {
    final anggun = await Supabase.instance.client.from('pelanggan').select();

    setState(() {
      pelangganAnggun = List<Map<String, dynamic>>.from(anggun);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman Pelanggan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: fetchpelanggan,
            icon: Icon(Icons.refresh),
            color: Colors.white,
          ),
        ],
      ),
      body: pelangganAnggun.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: pelangganAnggun.length,
              itemBuilder: (context, index) {
                final kasir = pelangganAnggun[index];
                return Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ]),
                  child: ListTile(
                    title: Text(
                      kasir['namaPelanggan'] ?? 'No namaPelanggan',
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          kasir['alamat'] ?? 'No alamat',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          kasir['nomorTelepon'] ?? 'No nomorTelepon',
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditPelangganPage(pelanggan: kasir)));
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.blue,
                            )),
                        IconButton(
                            onPressed: () {
                              deletePelanggan(kasir['idPelanggan'], context);
                            },
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => InsertPelanggan()));

            //jika result true maka refresh halaman produk dengan kode berikut
            if (result == true) {
              fetchpelanggan();
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

//halaman penjualan
class PenjualanAdminPage extends StatefulWidget {
  const PenjualanAdminPage({super.key});

  @override
  State<PenjualanAdminPage> createState() => _PenjualanAdminPageState();
}

class _PenjualanAdminPageState extends State<PenjualanAdminPage> {
  List<Map<String, dynamic>> penjualand = [];

  @override
  void initState() {
    super.initState();
    fetchPenjualand();
  }

  Future<void> fetchPenjualand() async {
    try {
      final response = await Supabase.instance.client
          .from('penjualan')
          .select('*,pelanggan(*)');
      setState(() {
        penjualand = List<Map<String, dynamic>>.from(response ?? []);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data penjualan: $error')),
      );
    }
  }

  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(amount).replaceAll(',', '.');
  }

  //fungsi untuk menghapus data penjualan berdasarkan id
  Future<void> _deletePenjualand(int id) async {
    try {
      final supabase = Supabase.instance.client;

      await supabase.from('detailPenjualan').delete().eq('idPenjualan', id);

      await supabase.from('penjualan').delete().eq('idPenjualan', id);

      fetchPenjualand();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus penjualan: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman Penjualan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: fetchPenjualand,
            icon: Icon(Icons.refresh),
            color: Colors.white,
          )
        ],
      ),
      body: penjualand.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: penjualand.length,
              itemBuilder: (context, index) {
                final penjualans = penjualand[index];

                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      'Total Harga: Rp ${penjualans['totalHarga'] != null ? formatCurrency(penjualans['totalHarga']) : 'Total harga tidak ditemukan'}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Nama: ${penjualans['pelanggan']['namaPelanggan']}'),
                        Text(
                          'Tanggal: ${penjualans['tanggalPenjualan'] ?? 'Tanggal Tidak ditemukan'}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () =>
                                _deletePenjualand(penjualans['idPenjualan']),
                            icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => PenjualanAdmin()));

            if (result == true) {
              fetchPenjualand();
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(
              Icons.add,
              color: Colors.white,
            )
          ]),
        ),
      ),
    );
  }
}

// halaman detail
class DetailPenjualanAdminPage extends StatefulWidget {
  const DetailPenjualanAdminPage({super.key});

  @override
  State<DetailPenjualanAdminPage> createState() =>
      _DetailPenjualanAdminPageState();
}

class _DetailPenjualanAdminPageState extends State<DetailPenjualanAdminPage> {
  List<Map<String, dynamic>> detail_penjualan = [];
  List<Map<String, dynamic>> penjualans = [];

  @override
  void initState() {
    super.initState();
    fetchDetailPenjualan();
  }

  Future<void> fetchDetailPenjualan() async {
    try {
      final response = await Supabase.instance.client
          .from('detailPenjualan')
          .select('*,penjualan(*,pelanggan(*)),produk(*)');

      setState(() {
        detail_penjualan = List<Map<String, dynamic>>.from(response);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data penjualan: $error'),
        ),
      );
    }
  }

  Future<void> _deletePenjualan(int id) async {
    try {
      await Supabase.instance.client
          .from('detailPenjualan')
          .delete()
          .eq('idDetail', id);

      fetchDetailPenjualan();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus penjualan: $error'),
        ),
      );
    }
  }

// ini kode untuk membuat harga otomatis ada titik nya contoh Rp. 40.000.000 tidak polosan seperti Rp.40000
  String formatCurrency(int amount) {
    final formatter = NumberFormat('#,###', 'id_ID');
    return formatter.format(amount).replaceAll(',', '.');
  }

  Future<String> _getnamaproduk(int Produkid) async {
    try {
      final response = await Supabase.instance.client
          .from('produk')
          .select('namaProduk')
          .eq('idProduk', Produkid)
          .maybeSingle();

      if (response != null && response['namaProduk'] != null) {
        return response['namaProduk'];
      }
      return 'Nama Produk tidak ditemukan';
    } catch (error) {
      return 'Error: $error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Penjualan',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: fetchDetailPenjualan,
            icon: Icon(Icons.refresh),
            color: Colors.white,
          )
        ],
      ),
      body: detail_penjualan.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: detail_penjualan.length,
              itemBuilder: (context, index) {
                final detail_penjualans = detail_penjualan[index];
                return Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: ListTile(
                    title: Text(
                      'Subtotal : Rp ${detail_penjualans['subtotal'] != null ? formatCurrency(detail_penjualans['subtotal']) : 'Subtotal tidak tersedia'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nama Produk: ${detail_penjualans['produk']['namaProduk']}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Jumlah Produk: ${detail_penjualans['jumlahProduk'] ?? 'Jumlah Produk tidak tersedia'}',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Nama: ${detail_penjualans['penjualan']['pelanggan']['namaPelanggan']}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                      ),
                  trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: ()  {
                            Navigator.push(context, MaterialPageRoute(builder: (contex) => StrukPenjualan(idPenjualan: ['idPenjualan'].toString())));
                          },
                            child: Text('Cetak Struk'))
                        // IconButton(onPressed: () => StrukPenjualan(penjualanID: 'id',), icon: Icon(Icons.print)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// halaman user
class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<Map<String, dynamic>> user = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await Supabase.instance.client.from('user').select();

    setState(() {
      user = List<Map<String, dynamic>>.from(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman User',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: fetchUsers,
            icon: Icon(Icons.refresh, color: Colors.white),
          ),
        ],
        backgroundColor: Colors.blue,
      ),
      body: user.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                final book = user[index];
                return Container(
                  margin: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: ListTile(
                      title: Text(
                        book['username'] ?? 'No username',
                        style: TextStyle(fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book['password'] ?? 'No password',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            book['role'] ?? 'No role',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditUserPage(user: book)));
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.blue,
                              )),
                          IconButton(
                              onPressed: () {
                                deleteUser(book['id'], context);
                              },
                              icon: Icon(Icons.delete)),
                        ],
                      )),
                );
              }),
      floatingActionButton: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()),
            );

            //jika result true maka refresh halaman user dengan kode berikut
            if (result == true) {
              fetchUsers();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

// Halaman untuk Profile
class ProfileAdmin extends StatelessWidget {
  const ProfileAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              'Profile (Admin)',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.blue),
        body: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 50.0),
                    child: Card(
                      elevation: 9,
                      shadowColor: Colors.grey,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(1, -7))
                          ],
                          color: Colors.white,
                          // color: Color.fromARGB(255, 154, 134, 208),
                        ),
                        height: 350.0,
                        width: 250.0,
                        child: Column(
                          children: [
                            SizedBox(height: 30.0),
                            ClipPath(
                              child: Image.asset(
                                'assets/images/logout.png',
                                width: 200,
                                height: 300,
                                fit: BoxFit.cover,
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
            SizedBox(height: 30.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: Text(
                'LogOut',
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ));
  }
}
