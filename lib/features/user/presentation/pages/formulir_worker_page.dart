import 'package:flutter/material.dart';
import 'package:plumbing_services_pml_kel4/features/user/domain/widgets/custom_text_field.dart';
import 'package:plumbing_services_pml_kel4/features/user/domain/widgets/gender_radio.dart';
import 'package:plumbing_services_pml_kel4/features/user/domain/widgets/skill_checkbox.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gender_radio.dart';
import '../widgets/skill_checkbox.dart';

class FormulirWorkerPage extends StatefulWidget {
  const FormulirWorkerPage({super.key});

  @override
  State<FormulirWorkerPage> createState() => _FormulirWorkerPageState();
}

class _FormulirWorkerPageState extends State<FormulirWorkerPage> {
  final _formKey = GlobalKey<FormState>();

  String gender = 'Male';

  final Map<String, bool> skills = {
    'Instalasi pipa': true,
    'Perbaikan & pemeliharaan pipa': true,
    'Pembersihan & Penyumbatan': false,
    'Instalasi perangkat sanitasi': false,
  };

  List<String> getSelectedSkills() {
    return skills.entries.where((e) => e.value).map((e) => e.key).toList();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isTablet = width > 600;

    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Pendaftaran')),
      body: Center(
        child: Container(
          width: isTablet ? 520 : double.infinity,
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Silahkan diisi',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),

                  const SizedBox(height: 16),
                  const CustomTextField(label: 'Username'),
                  const CustomTextField(label: 'Phone Number'),
                  const CustomTextField(label: 'Email'),
                  const CustomTextField(label: 'Password', isPassword: true),
                  const CustomTextField(label: 'Address', maxLines: 3),

                  const SizedBox(height: 20),
                  const Text(
                    'Gender',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      GenderRadio(
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        },
                      ),
                      GenderRadio(
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (val) {
                          setState(() {
                            gender = val;
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    'Skill',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ...skills.entries.map(
                    (e) => SkillCheckbox(
                      title: e.key,
                      value: e.value,
                      onChanged: (val) {
                        setState(() {
                          skills[e.key] = val;
                        });
                      },
                    ),
                  ),

                  const CustomTextField(label: 'Other Skills'),
                  const CustomTextField(label: 'Link Portfolio'),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          debugPrint('Gender: $gender');
                          debugPrint(
                            'Skills: ${getSelectedSkills().join(', ')}',
                          );
                        }
                      },
                      child: const Text('Order Now'),
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
}
