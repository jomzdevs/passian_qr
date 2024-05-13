import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentQRCode extends StatefulWidget {
  const StudentQRCode({Key? key}) : super(key: key);

  @override
  State<StudentQRCode> createState() => _StudentQRCodeState();
}

class _StudentQRCodeState extends State<StudentQRCode> {
  String qrData = ""; // Variable to store formatted data for QR code
  String documentId = ""; // Variable to store document ID (user input)

  // Function to fetch student data and generate QR code
  Future<void> getStudentDataAndGenerateQRCode() async {
    if (documentId.isEmpty) {
      print("Please enter a document ID");
      return; // Handle missing document ID
    }

    try {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(documentId);
      final snapshot = await docRef.get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final name = data['name'];
        final course = data['course'];
        final year = data['year'];

        // Format data for QR code (replace with your desired format)
        qrData =
            '{"documentId": "$documentId", "name": "$name", "course": "$course", "year": "$year"}';
      } else {
        print("Document with ID $documentId not found");
        qrData = ""; // Clear QR data if document not found
      }
    } catch (e) {
      print("Error fetching student data: $e");
      qrData = ""; // Clear QR data on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generate your QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Document ID'),
              onChanged: (value) => documentId = value,
            ),
            ElevatedButton(
              onPressed: getStudentDataAndGenerateQRCode,
              child: const Text('Generate QR Code'),
            ),
            if (qrData.isNotEmpty)
              QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 200.0,
              ),
          ],
        ),
      ),
    );
  }
}
