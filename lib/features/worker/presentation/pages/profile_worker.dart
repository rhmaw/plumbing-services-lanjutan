import 'package:flutter/material.dart';

class WorkerEntity {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String avatarUrl;

  WorkerEntity({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.avatarUrl,
  });
}

abstract class WorkerRepository {
  Future<WorkerEntity> getProfile();
}

class WorkerRepositoryImpl implements WorkerRepository {
  @override
  Future<WorkerEntity> getProfile() async {
    // simulasi API / database
    await Future.delayed(const Duration(milliseconds: 500));
    return WorkerEntity(
      name: 'Banu Setya',
      email: 'banu@gmail.com',
      phone: '08543381659',
      address: 'Default Address',
      avatarUrl:
          'https://images.unsplash.com/photo-1603415526960-f7e0328c63b1',
    );
  }
}


class GetWorkerProfile {
  final WorkerRepository repository;
  GetWorkerProfile(this.repository);

  Future<WorkerEntity> execute() {
    return repository.getProfile();
  }
}

class ProfileWorkerPage extends StatefulWidget {
  const ProfileWorkerPage({super.key});

  @override
  State<ProfileWorkerPage> createState() => _ProfileWorkerPageState();
}

class _ProfileWorkerPageState extends State<ProfileWorkerPage> {
  late GetWorkerProfile getWorkerProfile;

  @override
  void initState() {
    super.initState();
    getWorkerProfile = GetWorkerProfile(WorkerRepositoryImpl());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: SafeArea(
        child: FutureBuilder<WorkerEntity>(
          future: getWorkerProfile.execute(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final worker = snapshot.data!;

            return Column(
              children: [
                SizedBox(height: size.height * 0.04),
                CircleAvatar(
                  radius: isTablet ? 70 : 50,
                  backgroundImage: NetworkImage(worker.avatarUrl),
                ),
                const SizedBox(height: 12),
                Text(
                  worker.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 26 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
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
                        _infoTile(Icons.location_on, 'Address', worker.address),
                        _infoTile(Icons.email, 'E-mail', worker.email),
                        _infoTile(Icons.phone, 'Phone', worker.phone),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[400],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditProfileWorkerPage(),
                                ),
                              );
                            },
                            child: const Text('Edit Profile'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}

class EditProfileWorkerPage extends StatelessWidget {
  const EditProfileWorkerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width > 600 ? 32.0 : 20.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile Worker')),
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            _inputField('Name'),
            _inputField('E-mail'),
            _inputField('Phone Number'),
            _inputField('Address'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }
}
