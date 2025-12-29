import 'package:flutter/material.dart';

class WorkerProfile {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatarUrl;

  WorkerProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
  });
}


class GetWorkerProfile {
  Future<WorkerProfile> execute() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return WorkerProfile(
      name: 'Banu Setya',
      email: 'banu@gmail.com',
      phone: '08543381659',
      address: 'Jl. Raya Banyumas',
      avatarUrl:
          'https://images.unsplash.com/photo-1603415526960-f7e0328c63b1',
    );
  }
}


class ProfileWorkerPage extends StatefulWidget {
  const ProfileWorkerPage({super.key});

  @override
  State<ProfileWorkerPage> createState() => _ProfileWorkerPageState();
}

class _ProfileWorkerPageState extends State<ProfileWorkerPage> {
  final getProfile = GetWorkerProfile();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      backgroundColor: const Color(0xff6ea0ff),
      body: SafeArea(
        child: FutureBuilder<WorkerProfile>(
          future: getProfile.execute(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }

            final profile = snapshot.data!;

            return Column(
              children: [
                const SizedBox(height: 24),


                CircleAvatar(
                  radius: isTablet ? 70 : 50,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                ),
                const SizedBox(height: 12),


                Text(
                  profile.name,
                  style: TextStyle(
                    fontSize: isTablet ? 26 : 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 24),


                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 32 : 20,
                      vertical: 24,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoTile(Icons.location_on, 'Address', profile.address),
                        _infoTile(Icons.email, 'E-mail', profile.email),
                        _infoTile(Icons.phone, 'Phone', profile.phone),
                        const Spacer(),

                        /// EDIT BUTTON
                        _primaryButton(
                          text: 'Edit Profile',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditProfileWorkerPage(profile),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        _outlineButton(
                          text: 'Logout',
                          color: Colors.red,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xff6ea0ff)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff6ea0ff),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }

  Widget _outlineButton({
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          text,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
class EditProfileWorkerPage extends StatelessWidget {
  final WorkerProfile profile;

  const EditProfileWorkerPage(this.profile, {super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final padding = isTablet ? 32.0 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xff6ea0ff),
      ),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            _inputField('Name', profile.name),
            _inputField('E-mail', profile.email),
            _inputField('Phone', profile.phone),
            _inputField('Address', profile.address),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6ea0ff),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
