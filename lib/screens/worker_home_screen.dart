import 'package:flutter/material.dart';
// import 'take_services_screen.dart';
// import 'job_history_screen.dart';
// import 'user/user_profile_screen.dart';

class WorkerHomeScreen extends StatelessWidget {
  final int currentIndex;
  const WorkerHomeScreen({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> jobs = [
      {
        'name': 'Jumbo',
        'image': 'https://randomuser.me/api/portraits/women/1.jpg',
        'time': '09:00 AM - 03:00 PM',
        'address': 'Baturaden',
        'phone': '085443187349'
      },
      {
        'name': 'Kiko Done',
        'image': 'https://randomuser.me/api/portraits/men/1.jpg',
        'time': '09:00 AM - 03:00 PM',
        'address': 'Baturaden',
        'phone': '085443187349'
      },
    ];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Halo selamat datang\nJane Smit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 30),
            const Text(
              'Today Job',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(job['image']!),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                job['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text('Time : ${job['time']}'),
                              Text('Address : ${job['address']}'),
                              Text('No. Phone : ${job['phone']}'),
                              const SizedBox(height: 8),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => const TakeServicesScreen(),
                                    //   ),
                                    // );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                  child: const Text('Take Services'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WorkerHomeScreen()),
            );
          } else if (index == 1) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (_) => const JobHistoryScreen()),
            // );
          } else if (index == 2) {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (_) => const ProfileScreen()),
            // );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
