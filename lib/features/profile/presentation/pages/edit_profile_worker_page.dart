import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

class EditProfileWorkerPage extends StatefulWidget {
  final Map<String, dynamic> currentData;

  const EditProfileWorkerPage({super.key, required this.currentData});

  @override
  State<EditProfileWorkerPage> createState() => _EditProfileWorkerPageState();
}

class _EditProfileWorkerPageState extends State<EditProfileWorkerPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentData['username'] ?? '');
    _emailController = TextEditingController(text: widget.currentData['email'] ?? '');
    
    String phone = widget.currentData['phone_number'] ?? widget.currentData['phone'] ?? '';
    _phoneController = TextEditingController(text: phone);
    _addressController = TextEditingController(text: widget.currentData['address'] ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }
    if (Platform.isAndroid) {
      return 'http://10.126.120.69:8080/api'; 
    }
    return 'http://127.0.0.1:8080/api';
  }

  Future<void> _saveChanges() async {
    setState(() => _isLoading = true);

    final url = Uri.parse('${getBaseUrl()}/user/update');
    
    Map<String, dynamic> requestBody = {
      'id': widget.currentData['id'],
      'username': _nameController.text,
      'email': _emailController.text,
      'phone_number': _phoneController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
    };

    try {
      print("Sending request to: $url");
      
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", 
          "Accept": "application/json"
        },
        body: jsonEncode(requestBody),
      );

      print("Response Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userData = responseData['data'];

        Map<String, dynamic> updatedLocalData = Map.from(widget.currentData);
        updatedLocalData['username'] = userData['username'];
        updatedLocalData['email'] = userData['email'];
        updatedLocalData['phone'] = userData['phone_number'];
        updatedLocalData['phone_number'] = userData['phone_number'];
        updatedLocalData['address'] = userData['address'];

        if (!mounted) return;
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile berhasil diperbarui!"), backgroundColor: Colors.green),
        );

        Navigator.pop(context, updatedLocalData);

      } else {
        throw Exception("Gagal Update: ${response.body}");
      }
    } catch (e) {
      if (!mounted) return;
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error koneksi: $e"), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFD0E3FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.chevron_left, color: Color(0xFF2979FF), size: 30),
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text("Edit Profile worker", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2979FF))),
                ],
              ),
              const SizedBox(height: 40),

              _buildInputLabel("Name"),
              _buildUnderlineTextField(_nameController),
              const SizedBox(height: 25),

              _buildInputLabel("E-mail"),
              _buildUnderlineTextField(_emailController),
              const SizedBox(height: 25),

              _buildInputLabel("Phone Number"),
              _buildUnderlineTextField(_phoneController, isNumber: true),
              const SizedBox(height: 25),

              _buildInputLabel("Address"),
              _buildUnderlineTextField(_addressController),
              const SizedBox(height: 50),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6495ED),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Changes", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500));
  }

  Widget _buildUnderlineTextField(TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF6495ED), width: 2)),
      ),
    );
  }
}