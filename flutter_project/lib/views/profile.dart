import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/configs/controllers/session_controller.dart';
import 'package:flutter_application_1/services/rental_api_service.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = Get.find<SessionController>();
    final userId = sessionController.userId;

    if (userId == null) {
      return const Scaffold(
        body: Center(child: Text('Please login to view your profile.')),
      );
    }

    return Scaffold(
      backgroundColor: appBackgroundColor,
      body: FutureBuilder<Map<String, dynamic>>(
        future: RentalApiService.fetchProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  snapshot.error.toString().replaceFirst('Exception: ', ''),
                ),
              ),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 18),
                const CircleAvatar(
                  radius: 38,
                  backgroundColor: secondaryColor,
                  child: Icon(Icons.person, size: 42, color: inverseTextColor),
                ),
                const SizedBox(height: 14),
                Text(
                  user['Fullname'] as String,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['email'] as String,
                  style: const TextStyle(color: mutedTextColor),
                ),
                const SizedBox(height: 24),
                _ProfileTile(
                  icon: Icons.badge_outlined,
                  title: 'User ID',
                  subtitle: '${user['id']}',
                ),
                const _ProfileTile(
                  icon: Icons.credit_card_outlined,
                  title: 'Preferred Payment',
                  subtitle: 'M-Pesa',
                ),
                _ProfileTile(
                  icon: Icons.calendar_month_outlined,
                  title: 'Joined',
                  subtitle: '${user['created-at']}',
                ),
                const _ProfileTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Account Status',
                  subtitle: 'Verified rider',
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      sessionController.clear();
                      Get.offAllNamed('/login');
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: secondaryColor,
                      side: const BorderSide(color: secondaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text('Logout'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: accentSurfaceColor,
            child: Icon(icon, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: mutedTextColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
