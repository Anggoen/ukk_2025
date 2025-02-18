import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Petugas/pelanggan/deletePelanggan.dart';
import 'package:ukk_2025/Petugas/pelanggan/editPelanggan.dart';
import 'package:ukk_2025/Petugas/pelanggan/insertPelanggan.dart';
import 'package:ukk_2025/Petugas/penjualan/insertPenjualan.dart';
import 'package:ukk_2025/Petugas/produk/deleteProduk.dart';
import 'package:ukk_2025/Petugas/produk/editProduk.dart';
import 'package:ukk_2025/Petugas/produk/insertProduk.dart';
import 'package:ukk_2025/login.dart';

void main() {
  runApp(KasirPetugasPage());
}

class KasirPetugasPage extends StatelessWidget {
  const KasirPetugasPage({super.key});

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
    PenjualanPetugasPage(),
    DetailPenjualanPetugasPage(),
    ProfilePetugasAd(),
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
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Pelanggan'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), label: 'Penjualan'),
            BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Detail'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2), label: 'Profile')
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

  @override
  void initState() {
    super.initState();
    fetchproduk();
  }

  Future<void> fetchproduk() async {
    final anggoen = await Supabase.instance.client.from('produk').select();

    setState(() {
      produkAnggun = List<Map<String, dynamic>>.from(anggoen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman Produk',
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
      body: produkAnggun.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: produkAnggun.length,
              itemBuilder: (context, index) {
                final book = produkAnggun[index];
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
                          'Rp. ${book['harga']}',
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

            // jika result true maka refresh halaman prduk dengan kode berikut
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
  // TextEditingController _search = TextEditingController();
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
class PenjualanPetugasPage extends StatefulWidget {
  const PenjualanPetugasPage({super.key});

  @override
  State<PenjualanPetugasPage> createState() => _PenjualanPetugasPageState();
}

class _PenjualanPetugasPageState extends State<PenjualanPetugasPage> {
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
        SnackBar(content: Text('Gagal memuat data pelanggan: $error')),
      );
    }
  }

  //fungsi untuk menghapus data penjualan berdasarkan id
  Future<void> _deletePenjualann(int id) async {
    try {
      final supabase = Supabase.instance.client;
      await supabase.from('detailPenjualan').delete().eq('idPenjualan', id);
      await supabase.from('penjualan').delete().eq('idPenjualan', id);
      fetchPenjualand();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat penjualan: $error')),
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
            splashColor: Colors.yellow,
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
                      'Total Harga: Rp ${penjualans['totalHarga'] ?? 'Total Harga tidak ditemukan'}',
                      style: TextStyle(fontSize: 14),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Nama: ${penjualans['pelanggan']['namaPelanggan']}'),
                        SizedBox(
                            height:
                                5), // Tambahkan jarak agar teks tidak menempel
                        Text(
                          'Tanggal: ${penjualans['tanggalPenjualan'] ?? 'Tanggal tidak tersedia'}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () =>
                                _deletePenjualann(penjualans['idPenjualan']),
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
                MaterialPageRoute(builder: (context) => PenjualanPetugas()));

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
class DetailPenjualanPetugasPage extends StatefulWidget {
  const DetailPenjualanPetugasPage({super.key});

  @override
  State<DetailPenjualanPetugasPage> createState() =>
      _DetailPenjualanPetugasPage();
}

class _DetailPenjualanPetugasPage extends State<DetailPenjualanPetugasPage> {
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
        title: Text('Halaman Detail Penjualan',
            style: TextStyle(color: Colors.white)),
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
                      'Nama: ${detail_penjualans['penjualan']['pelanggan']['namaPelanggan']}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                          'Subtotal : Rp ${detail_penjualans['subtotal'] ?? 'Subtotal tidak tersedia'}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _deletePenjualan(
                              detail_penjualans['idPenjualan']),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// Halaman untuk Profile
class ProfilePetugasAd extends StatelessWidget {
  const ProfilePetugasAd({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Profile (Petugas)',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
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
                                height: 250,
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
