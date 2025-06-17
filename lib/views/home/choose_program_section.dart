import 'package:flutter/material.dart';

// Import gambar yang diperlukan
const _barbellProgramImage = 'assets/images/dumble.png';
const _dumbbellProgramImage = 'assets/images/dumble.png'; // Assuming 'dumble.png' is correct path

class ChooseProgramSection extends StatelessWidget {
  const ChooseProgramSection({super.key});

  // Widget untuk Kartu Program
  Widget _buildProgramCard(
      BuildContext context, String title, String subtitle, String duration, String imagePath) {
    return ClipRRect( // Tambahkan ClipRRect untuk border radius pada card
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45, // Lebar kartu program
        decoration: const BoxDecoration( // Gunakan const BoxDecoration
          color: Color.fromARGB(255, 30, 30, 30), // Warna latar belakang kartu
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4), // Mengurangi sedikit jarak
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70, // Warna putih keabuan untuk "Selengkapnya"
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8), // Jarak ke ikon jam
                  Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        duration,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Program',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 220, // Height for horizontal program list
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildProgramCard(
                  context,
                  'Full Body',
                  'Selengkapnya',
                  '2 - 3 times a week',
                  'assets/images/3.png', // Replace with program image
                ),
                const SizedBox(width: 15),
                _buildProgramCard(
                  context,
                  'Upper and I', // Corrected from 'Upper and l'
                  'Selengkapnya',
                  '4 times',
                  'assets/images/1.png', // Replace with program image
                ),
                const SizedBox(width: 15),
                // Add more cards if needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}
