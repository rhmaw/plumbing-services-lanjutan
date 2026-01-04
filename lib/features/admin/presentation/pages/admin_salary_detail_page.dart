import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:sqflite/sqflite.dart';
import 'package:universal_html/html.dart' as html;

class AdminSalaryDetailPage extends StatefulWidget {
  final Map<String, dynamic> workerData;

  const AdminSalaryDetailPage({super.key, required this.workerData});

  @override
  State<AdminSalaryDetailPage> createState() => _AdminSalaryDetailPageState();
}

class _AdminSalaryDetailPageState extends State<AdminSalaryDetailPage> {
  
  String formatRp(double value) {
    return "Rp. ${value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}";
  }

  // --- SQLITE ---
  Future<void> _saveToLocalDB(String name, double amount, String date) async {
    if (kIsWeb) return; 

    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, 'salary_history.db');

      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE history(id INTEGER PRIMARY KEY, name TEXT, amount REAL, date TEXT)',
          );
        },
      );

      await database.insert(
        'history',
        {
          'name': name,
          'amount': amount,
          'date': date,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      
      print("Data berhasil disimpan ke SQLite Lokal");
    } catch (e) {
      print("Gagal menyimpan ke SQLite: $e");
    }
  }

  // --- EXPORT PDF ---
  Future<void> _exportToPdf() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Dialog(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Exporting PDF..."),
            ],
          ),
        ),
      ),
    );

    try {
      final doc = pw.Document();
      
      String name = widget.workerData['username'] ?? 'User';
      String email = widget.workerData['email'] ?? '-';
      String idWorker = widget.workerData['id'].toString();
      String phone = widget.workerData['phone_number'] ?? '-';
      
      double totalGaji = double.tryParse(widget.workerData['total_earnings'].toString()) ?? 0.0;
      double potongan = totalGaji * 0.10;
      double totalDiterima = totalGaji - potongan;

      doc.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(level: 0, child: pw.Text("SLIP GAJI PEKERJA", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold))),
                pw.SizedBox(height: 20),
                pw.Text("Nama: $name"),
                pw.Text("Email: $email"),
                pw.Text("ID Worker: $idWorker"),
                pw.Text("Telepon: $phone"),
                pw.Divider(),
                pw.SizedBox(height: 10),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Total Gaji Awal"), pw.Text(formatRp(totalGaji))]),
                pw.SizedBox(height: 5),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("Potongan Admin (10%)"), pw.Text("- ${formatRp(potongan)}", style: const pw.TextStyle(color: PdfColors.red))]),
                pw.Divider(),
                pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [pw.Text("TOTAL DITERIMA", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)), pw.Text(formatRp(totalDiterima), style: pw.TextStyle(fontWeight: pw.FontWeight.bold))]),
              ],
            );
          },
        ),
      );

      final Uint8List pdfBytes = await doc.save();

      if (kIsWeb) {
        final blob = html.Blob([pdfBytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement()
          ..href = url
          ..style.display = 'none'
          ..download = 'Slip_Gaji_$name.pdf';
        html.document.body?.children.add(anchor);
        anchor.click();
        html.document.body?.children.remove(anchor);
        html.Url.revokeObjectUrl(url);
      } else {
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdfBytes,
          name: 'Slip_Gaji_$name.pdf',
        );
      }

      await _saveToLocalDB(name, totalDiterima, DateTime.now().toString());

      if (mounted) {
        Navigator.pop(context);
        _showSuccessDialog();
      }

    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal Export: $e"), backgroundColor: Colors.red));
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Column(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("Berhasil!", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text("Slip gaji berhasil diexport dan disimpan ke riwayat lokal.", textAlign: TextAlign.center),
          actions: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6395F8)),
                child: const Text("OK", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text("Detail Gaji Pekerja", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF6395F8),
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(50)),
            child: const Icon(Icons.arrow_back_ios_new, size: 18, color: Color(0xFF6395F8)),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }
  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildDetailCard(isDesktop: false),
          
          const SizedBox(height: 30),
          
          _buildExportButton(),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // --- DESKTOP ---
  Widget _buildDesktopLayout() {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 900),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildDetailCard(isDesktop: true),
            ),
            const SizedBox(height: 20),
            _buildExportButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- REUSABLE DETAIL CARD ---
  Widget _buildDetailCard({required bool isDesktop}) {
    String name = widget.workerData['username'] ?? 'User';
    String email = widget.workerData['email'] ?? '-';
    String idWorker = widget.workerData['id'].toString();
    String phone = widget.workerData['phone_number'] ?? '-';
    String address = widget.workerData['address'] ?? '-';
    String photoUrl = widget.workerData['photo_url'] ?? "https://i.pravatar.cc/150?u=$name";

    double totalGaji = double.tryParse(widget.workerData['total_earnings'].toString()) ?? 0.0;
    double potongan = totalGaji * 0.10;
    double totalDiterima = totalGaji - potongan;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          if (isDesktop) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(photoUrl),
                  onBackgroundImageError: (_, __) {}, 
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    Text(email, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                )
              ],
            ),
          ] else ...[
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(photoUrl),
                    onBackgroundImageError: (_, __) {}, 
                  ),
                  const SizedBox(height: 10),
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            )
          ],

          const SizedBox(height: 40),

          _buildResponsiveRow("Username", name),
          _buildResponsiveRow("Email", email),
          _buildResponsiveRow("ID Worker", idWorker),
          _buildResponsiveRow("No. Telepon", phone),
          _buildResponsiveRow("Alamat", address),
          _buildResponsiveRow("Periode", "N/A"),
          _buildResponsiveRow("Total Gaji", formatRp(totalGaji)),
          _buildResponsiveRow("Potongan Admin (10%)", formatRp(potongan)),

          const SizedBox(height: 15),
          const Divider(color: Colors.grey),
          const SizedBox(height: 15),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 140,
                child: Text(
                  "Total Diterima", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                )
              ),
              const Text(":  ", style: TextStyle(fontWeight: FontWeight.bold)),
              
              Expanded(
                child: Text(
                  formatRp(totalDiterima), 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          const Text(":  ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              overflow: TextOverflow.visible, 
              softWrap: true,
            )
          ),
        ],
      ),
    );
  }

  // --- EXPORT ---
  Widget _buildExportButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _exportToPdf, 
        icon: const Icon(Icons.print, size: 22),
        label: const Text("Export", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6395F8),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
    );
  }
}