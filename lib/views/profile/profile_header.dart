import 'package:flutter/material.dart';
import 'package:gym_app/models/user_models.dart';

class ProfileHeader extends StatelessWidget {
  final User? userProfile;
  final bool isLoading;

  const ProfileHeader({super.key, this.userProfile, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    String initials = '';
    if (userProfile?.name != null && userProfile!.name!.trim().isNotEmpty) {
      // Pisahkan nama berdasarkan spasi untuk dapat kata pertama dan kedua
      List<String> words = userProfile!.name!.trim().split(' ');
      // Ambil huruf pertama dari kata pertama
      initials = words[0][0];
      // Jika ada kata kedua, ambil juga huruf pertamanya
      if (words.length > 1) {
        initials += words[1][0];
      }
    }

    initials = initials.toUpperCase();

    return Container(
      color: const Color(0xFFC62828),
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      child:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
              : Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child:
                        initials.isNotEmpty
                            ? Text(
                              initials,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFC62828),
                              ),
                            )
                            : const Icon(
                              Icons.person,
                              size: 40,
                              color: Color(0xFFC62828),
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
                        userProfile?.email ?? 'pengguna@gmail.com',
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
