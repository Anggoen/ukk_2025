import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Admin/kasir.dart';
import 'package:ukk_2025/Petugas/kasir.dart';

void main() {
  runApp(LoginPage());
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController Username = TextEditingController();
  final TextEditingController Password = TextEditingController();
  final TextEditingController Role = TextEditingController();

  // Login function
  Login() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        // Query Supabase to check if the username and password match any entry in the database
        var result = await Supabase.instance.client
            .from('user')
            .select()
            .eq('username', Username.text)
            .eq('password', Password.text)
            .eq('role', Role.text)
            .single();

        if (result != null) {
          String role = result['role'];

          if (role == 'Admin') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KasirAdminPage(), // Navigate to Admin's home page
              ),
            );
          } else if (role == 'Petugas') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => KasirPetugasPage(), // Navigate to Petugas's home page
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Username atau password salah'),
              backgroundColor: Colors.pinkAccent,
            ),
          );
        }
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan, silakan coba lagi.'),
          backgroundColor: Colors.pinkAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Halaman Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(160.0),
                  child: Image.asset(
                    'assets/images/login2.png',
                    height: 300,
                    width: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      width: 600,
                      height: 350,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          )
                        ],
                        borderRadius: BorderRadius.circular(30.0),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              'Login',
                              style: TextStyle(fontSize: 30.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                SizedBox(height: 20.0),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: Username,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          labelText: 'Username',
                                          hintText: 'Masukkan Username kamu',
                                          prefixIcon: Icon(Icons.people),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Username Kosong";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10.0),
                                      TextFormField(
                                        obscureText: true,
                                        controller: Password,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          hintText: 'Masukkan Password kamu',
                                          prefixIcon: Icon(Icons.key),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Password Kosong";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10.0),
                                      TextFormField(
                                        controller: Role,
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                          labelText: 'Role',
                                          hintText: 'Masukkan Role kamu',
                                          prefixIcon: Icon(Icons.key),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Role Kosong";
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Cek validitas form sebelum memanggil Login
                                          if (_formKey.currentState?.validate() ?? false) {
                                            Login(); // Panggil fungsi login jika valid
                                          }
                                        },
                                        child: Text(
                                          'Login',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
