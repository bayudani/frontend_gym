import 'package:flutter/material.dart';
import 'package:gym_app/models/user_models.dart';
// import 'package:gym_app/models/user_profile.dart';

class ProfileHeader extends StatelessWidget {
  final User? userProfile;
  final bool isLoading;

  const ProfileHeader({super.key, this.userProfile, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFC62828),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: const Color(0xFFC62828),
                  ),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userProfile?.name ?? 'Nama Pengguna',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userProfile?.email ?? 'nomor@example.com',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}