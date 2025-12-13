import 'package:flutter/material.dart';

class FormulirWorker extends StatefulWidget {
  const FormulirWorker({super.key});

  @override
  State<FormulirWorker> createState() => _FormulirWorkerState();
}

class _FormulirWorkerState extends State<FormulirWorker> {
  final _formKey = GlobalKey<FormState>();

  String gender = 'Male';

  bool instalasiPipa = true;
  bool perbaikanPipa = true;
  bool pembersihan = false;
  bool sanitasi = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Formulir Pendaftaran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: isTablet ? 520 : double.infinity,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Silahkan diisi",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  _buildTextField("Username"),
                  _buildTextField("Phone number"),
                  _buildTextField("Email"),
                  _buildTextField("Password", isPassword: true),
                  _buildTextField("Address", maxLines: 3),

                  const SizedBox(height: 20),
                  const Text(
                    "Gender",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(children: [_buildRadio("Male"), _buildRadio("Female")]),

                  const SizedBox(height: 20),
                  const Text(
                    "Skill :",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  _buildCheckbox(
                    "Instalasi pipa",
                    instalasiPipa,
                    (val) => setState(() => instalasiPipa = val!),
                  ),
                  _buildCheckbox(
                    "Perbaikan & pemeliharaan pipa",
                    perbaikanPipa,
                    (val) => setState(() => perbaikanPipa = val!),
                  ),
                  _buildCheckbox(
                    "Pembersihan & Penyumbatan",
                    pembersihan,
                    (val) => setState(() => pembersihan = val!),
                  ),
                  _buildCheckbox(
                    "Instalasi perangkat sanitasi",
                    sanitasi,
                    (val) => setState(() => sanitasi = val!),
                  ),

                  const SizedBox(height: 20),
                  _buildTextField("Other Skills"),
                  _buildTextField("Link Portfolio"),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text("Order Now"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label, {
    bool isPassword = false,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        obscureText: isPassword,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        validator:
            (value) =>
                value == null || value.isEmpty ? "$label wajib diisi" : null,
      ),
    );
  }

  Widget _buildRadio(String value) {
    return Expanded(
      child: RadioListTile<String>(
        value: value,
        groupValue: gender,
        onChanged: (val) {
          setState(() => gender = val!);
        },
        title: Text(value),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildCheckbox(String title, bool value, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      debugPrint("Form berhasil dikirim");
    }
  }
}
