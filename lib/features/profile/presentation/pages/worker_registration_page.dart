import 'package:flutter/material.dart';
import '../../../../core/api/auth_service.dart';

class WorkerRegistrationPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const WorkerRegistrationPage({super.key, required this.userData});

  @override
  State<WorkerRegistrationPage> createState() => _WorkerRegistrationPageState();
}

class _WorkerRegistrationPageState extends State<WorkerRegistrationPage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  late TextEditingController _addressController;
  final TextEditingController _otherSkillController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  String _gender = "Male";
  bool _skillInstalasi = false;
  bool _skillPerbaikan = false;
  bool _skillPembersihan = false;
  bool _skillSanitasi = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userData['username']);
    _phoneController = TextEditingController(
      text: widget.userData['phone_number'],
    );
    _emailController = TextEditingController(text: widget.userData['email']);
    _addressController = TextEditingController(
      text: widget.userData['address'],
    );
  }

  void _handleSubmit() async {
    setState(() => _isLoading = true);

    List<String> selectedSkills = [];
    if (_skillInstalasi) selectedSkills.add("Instalasi pipa");
    if (_skillPerbaikan) selectedSkills.add("Perbaikan & pemeliharaan pipa");
    if (_skillPembersihan) selectedSkills.add("Pembersihan & Penyumbatan");
    if (_skillSanitasi) selectedSkills.add("Instalasi perangkat sanitasi");
    if (_otherSkillController.text.isNotEmpty)
      selectedSkills.add(_otherSkillController.text);

    String skillsString = selectedSkills.join(", ");

    int userId = int.parse(widget.userData['id'].toString());

    bool success = await _authService.submitApplication(
      userId: userId,
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      address: _addressController.text,
      gender: _gender,
      skills: skillsString,
      portfolio: _portfolioController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pendaftaran Berhasil Dikirim!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengirim pendaftaran."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6395F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Formulir Pendaftaran",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Text(
                  "Silahkan diisi",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(width: 5),
                Icon(Icons.tag_faces, color: Color(0xFF6395F8), size: 20),
              ],
            ),
            const SizedBox(height: 15),

            _buildTextField("Username", _nameController),
            const SizedBox(height: 15),
            _buildTextField("Phone number", _phoneController),
            const SizedBox(height: 15),
            _buildTextField("Email", _emailController),
            const SizedBox(height: 15),
            _buildTextField("Password", _passwordController, isObscure: true),
            const SizedBox(height: 15),
            _buildTextField("Address", _addressController, maxLines: 4),

            const SizedBox(height: 20),

            const Text(
              "Gender",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _buildGenderRadio("Male")),
                const SizedBox(width: 15),
                Expanded(child: _buildGenderRadio("Female")),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              "Skill :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            _buildSkillBox(
              "Instalasi pipa",
              _skillInstalasi,
              (val) => setState(() => _skillInstalasi = val!),
            ),
            _buildSkillBox(
              "Perbaikan & pemeliharaan pipa",
              _skillPerbaikan,
              (val) => setState(() => _skillPerbaikan = val!),
            ),
            _buildSkillBox(
              "Pembersihan & Penyumbatan",
              _skillPembersihan,
              (val) => setState(() => _skillPembersihan = val!),
            ),
            _buildSkillBox(
              "Instalasi perangkat sanitasi",
              _skillSanitasi,
              (val) => setState(() => _skillSanitasi = val!),
            ),

            const SizedBox(height: 20),

            const Text(
              "Other Skills",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              "Manajemen air ke dalam pipa",
              _otherSkillController,
            ),

            const SizedBox(height: 20),

            const Text(
              "Link Portfolio",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: TextField(
                controller: _portfolioController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.link),
                  hintText: "s.id/portfolio_r",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6395F8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isObscure = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildGenderRadio(String value) {
    return GestureDetector(
      onTap: () => setState(() => _gender = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: _gender == value ? const Color(0xFFE0E0E0) : Colors.white,
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _gender == value
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: Colors.black,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillBox(String title, bool value, Function(bool?) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6395F8),
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
        dense: true,
      ),
    );
  }
}
