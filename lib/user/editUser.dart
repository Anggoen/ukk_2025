import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/kasir.dart';

class EditUserPage extends StatefulWidget {
  final Map<String, dynamic> user;

  EditUserPage({required this.user});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  // final GlobalKey _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //kode untuk memunculkan data lama yang nanti akan diperbarui
    _usernameController.text = widget.user['username'];
    _passwordController.text = widget.user['password'];
  }

  // fungsi untuk memperbarui user di supabase
  Future<void> edituser() async {
    final response = await Supabase.instance.client
        .from('user')
        .update({
          'username': _usernameController.text,
          'password': _passwordController.text,
        })
        .eq('id', widget.user['id'])
        .select();

    //jika kode diatas mengalamai error maka muncu7lkan pesan
    if (response.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data Gagal Diperbarui')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data Berhasil Diperbarui')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => KasirPage()),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
                child: Form(
                    child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  maxLength: 20,
                  decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Masukkan username baru anda',
                      prefixIcon: Icon(Icons.people)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Masukkan username dulu";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10.0),
                TextFormField(
                  controller: _passwordController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password baru anda',
                    prefixIcon: Icon(Icons.key),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Masukkan password dulu";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: edituser,
                  child: Text('Perbarui User'),
                ),
              ],
            ))),
          ],
        ),
      ),
    );
  }
}
