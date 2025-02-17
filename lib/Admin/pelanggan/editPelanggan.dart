import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Admin/kasir.dart';

class EditPelangganPage extends StatefulWidget {
  final Map<String, dynamic> pelanggan;

  const EditPelangganPage({required this.pelanggan});

  @override
  State<EditPelangganPage> createState() => _EditPelangganPageState();
}

class _EditPelangganPageState extends State<EditPelangganPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _namaPelanggan = TextEditingController();
  final TextEditingController _alamatPelanggan = TextEditingController();
  final TextEditingController _nomorTelepon = TextEditingController();

  @override
  void initState() {
    super.initState();
    //kode untuk memunculkan data lama yang nanti akan diperbarui
    _namaPelanggan.text = widget.pelanggan['namaPelanggan'];
    _alamatPelanggan.text = widget.pelanggan['alamat'];
    _nomorTelepon.text = widget.pelanggan['nomorTelepon'];
  }

  //fungsi untuk mmeperbarui pelangga disupabaase
  Future<void> editPelanggan() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final response = await Supabase.instance.client
        .from('pelanggan')
        .update({
          'namaPelanggan': _namaPelanggan.text,
          'alamat': _alamatPelanggan.text,
          'nomorTelepon': _nomorTelepon.text,
        })
        .eq('idPelanggan', widget.pelanggan['idPelanggan'])
        .select();

    //jika kode diatas ,emgalami error maka akan muncul pesan
    if (response.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data gagal diperbarui')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil diperbarui')),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => KasirAdminPage()));
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
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _namaPelanggan,
                            decoration: InputDecoration(
                                labelText: 'Nama Pelanggan',
                                hintText: 'Masukkan nama pelanggan baru',
                                prefixIcon: Icon(Icons.abc),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan nama pelanggan dulu';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _alamatPelanggan,
                            decoration: InputDecoration(
                                labelText: 'Alamat Pelanggan',
                                hintText: 'Masukkan alamat pelanggan',
                                prefixIcon: Icon(Icons.home),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan alamat pelanggan dulu';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _nomorTelepon,
                            decoration: InputDecoration(
                                labelText: 'Nomor Telepon',
                                hintText: 'Masukkan nomor telepon',
                                prefixIcon: Icon(Icons.circle),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Masukkan nomor telepon';
                              } return null;
                            },
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: editPelanggan,
                            child: Text(
                              'Perbarui',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue),
                          )
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
