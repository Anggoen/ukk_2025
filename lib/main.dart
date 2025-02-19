import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ukk_2025/Admin/kasir.dart';
import 'package:ukk_2025/login.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kvykossopgzuvrdwgazx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt2eWtvc3NvcGd6dXZyZHdnYXp4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MDg5MDAsImV4cCI6MjA1NDk4NDkwMH0.K1X3NGXc5guwVZCn4xBqH4cssRwarBeSLTBFYDwuPes',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'kasir',
      debugShowCheckedModeBanner: false,
      // home: InsertProduk(),
      // home: HalamanAwal(),
      // home: KasirPetugasPage()

      home: KasirAdminPage(),
    );
  }
}

class HalamanAwal extends StatefulWidget {
  const HalamanAwal({super.key});

  @override
  State<HalamanAwal> createState() => _LoginPageState();
}

class _LoginPageState extends State<HalamanAwal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // backgroundColor: Color.fromARGB(255, 183, 161, 236),
        title: Text(
          'Selamat Datang!',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(160.0),
              child: Image.asset(
                'assets/images/login.png',
                height: 300,
                width: 300,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 50.0),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text(
                    'Masuk',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
