// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';

// class StrukPrinter {
//   // Fungsi untuk mencetak struk dalam bentuk PDF
//   Future<void> generatePDF(Map<String, dynamic> penjualanDetail, String petugasName) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page(
//         build: (pw.Context context) {
//           return pw.Column(
//             children: [
//               pw.Text(
//                 'Struk Penjualan',
//                 style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Text(
//                 'Nama Pelanggan: ${penjualanDetail['penjualan']['pelanggan']['namaPelanggan']}',
//                 style: pw.TextStyle(fontSize: 18),
//               ),
//               pw.SizedBox(height: 10),
//               pw.Text(
//                 'Nama Produk: ${penjualanDetail['produk']['namaProduk']}',
//                 style: pw.TextStyle(fontSize: 16),
//               ),
//               pw.Text(
//                 'Jumlah Produk: ${penjualanDetail['jumlahProduk']}',
//                 style: pw.TextStyle(fontSize: 14),
//               ),
//               pw.Text(
//                 'Subtotal: Rp ${penjualanDetail['subtotal']}',
//                 style: pw.TextStyle(fontSize: 14),
//               ),
//               pw.SizedBox(height: 20),
//               pw.Divider(),
//               pw.Text(
//                 'Dibuat oleh: $petugasName',
//                 style: pw.TextStyle(fontSize: 14, fontStyle: pw.FontStyle.italic),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     // Menampilkan atau mencetak PDF
//     await Printing.layoutPdf(onLayout: (PdfPageFormat format) async {
//       return pdf.save();
//     });
//   }
// }

// import 'package:pdf/widgets.dart' as pw;
// import 'package:pdf/pdf.dart';
// import 'package:printing/printing.dart';

// class StrukPrinter {
//   Future<void> generate(Map<String, dynamic> penjualanDetail) async {
//     final pdf = pw.Document();

//     pdf.addPage(
//       pw.Page{
//         build: (pw.Context context) {
//           return pw.Column(children: [
//             pw.text(context)
//           ])
//         }
//       }
//     );
//   }
// }