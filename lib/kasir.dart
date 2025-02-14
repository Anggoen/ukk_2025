import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/user/deleteUser.dart';
import 'package:ukk_2025/user/editUser.dart';
import 'package:ukk_2025/user/insertUser.dart';

void main() {
  runApp(KasirPage());
}

class KasirPage extends StatelessWidget {
  const KasirPage({super.key});

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
    PenjualanPage(),
    DetailPenjualan(),
    UserPage(),
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
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'User'),
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
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

//halaman penjualan
class PenjualanPage extends StatefulWidget {
  const PenjualanPage({super.key});

  @override
  State<PenjualanPage> createState() => _PenjualanPageState();
}

class _PenjualanPageState extends State<PenjualanPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// halaman detail
class DetailPenjualan extends StatefulWidget {
  const DetailPenjualan({super.key});

  @override
  State<DetailPenjualan> createState() => _DetailPenjualanState();
}

class _DetailPenjualanState extends State<DetailPenjualan> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
                              icon: Icon(Icons.edit, color: Colors.blue)),
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
