import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Pastikan kamu sudah menginisialisasi Supabase

class StrukPenjualan extends StatelessWidget {
  final String idPenjualan;

  const StrukPenjualan({Key? key, required this.idPenjualan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cetak Struk")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => generateAndPrintPDF(idPenjualan),
          child: Text("Cetak Struk"),
        ),
      ),
    );
  }

  // Fungsi untuk generate dan print PDF
  Future<void> generateAndPrintPDF(String idPenjualan) async {
    final pdf = pw.Document();

    try {
      // Ambil data penjualan dari database Supabase
      var responsePenjualan = await getPenjualanData(idPenjualan);
      var responseDetailPenjualan = await getDetailPenjualanData(idPenjualan);

      // Format tanggal
      String tanggalPenjualan = responsePenjualan['tanggalPenjualan'];
      String formattedDate = DateFormat('dd-MMMM-yyyy').format(DateTime.parse(tanggalPenjualan));

      // Menyusun konten struk
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text("Anggoen", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                ),
                pw.SizedBox(height: 10),
                pw.Text("Pelanggan: ${responsePenjualan['pelanggan']['namaPelanggan']}"),
                pw.Text("Tanggal: $formattedDate"),
                pw.SizedBox(height: 10),
                pw.Text("Produk    Jumlah    Subtotal"),
                pw.Divider(),
                // Menambahkan detail produk
                ...responseDetailPenjualan.map((detail) {
                  return pw.Text(
                    "${detail['produk']['namaProduk']}    ${detail['jumlahProduk']}    Rp ${detail['subtotal']}",
                  );
                }).toList(),
                pw.Divider(),
                pw.Text("Total Harga: Rp ${responsePenjualan['totalHarga']}", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            );
          },
        ),
      );

      // Cetak PDF atau tampilkan preview untuk cetak
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fungsi untuk mengambil data penjualan dari Supabase
  Future<Map<String, dynamic>> getPenjualanData(String idPenjualan) async {
    final response = await Supabase.instance.client
        .from('penjualan')
        .select('*, pelanggan(*)') // Mengambil data penjualan beserta data pelanggan
        .eq('idPenjualan', idPenjualan)
        .single(); // Ambil satu record karena idPenjualan unik

    if (response != null || response.isEmpty) {
      throw Exception('Failed to load penjualan data: ${response}');
    }

    return response; // Mengembalikan data penjualan
  }

  // Fungsi untuk mengambil detail penjualan dari Supabase
  Future<List<Map<String, dynamic>>> getDetailPenjualanData(String idPenjualan) async {
    final response = await Supabase.instance.client
        .from('detailPenjualan')
        .select('*, produk(*)') // Mengambil detail penjualan beserta data produk
        .eq('idPenjualan', idPenjualan);

    if (response != null || response.isEmpty) {
      throw Exception('Failed to load detail penjualan data: ${response}');
    }

    return List<Map<String, dynamic>>.from(response); // Mengembalikan list detail penjualan
  }
}
