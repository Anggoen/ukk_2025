import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/kasir.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  Future<void> _tambahuser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _username.text;
    final password = _password.text;

    //validasi input
    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Semua Harus Diisi Yea')),
      );
      return;
    }
    final response = await Supabase.instance.client.from('user').insert([
      {
        'username': username,
        'password': password,
      }
    ]);

    if (response != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.error!.message}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User berhasil ditambahkan')),
      );

      //setelah form seleasi maka langsung haous kolom input nya
      _username.clear();
      _password.clear();

      Navigator.pop(context, true);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => KasirPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah User',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _username,
                  maxLength: 10,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Masukkan username baru',
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Masukkan username dulu'),
                      ));
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _password,
                    maxLength: 10,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Masukkan Password baru',
                      prefixIcon: Icon(Icons.key),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Masukkan password dulu')),
                        );
                      }
                      return null;
                    }),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) _tambahuser();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text(
                    'Tambah User',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//  validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Masukkan Stok';
//                     } else {
//                       if (double.tryParse(value) == null) {
//                         return "Stok harus berupa angka";
//                       }
//                     }
//                   },
//                 ),