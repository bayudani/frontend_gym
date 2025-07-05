// lib/views/home/choose_program_section.dart

import 'package:flutter/material.dart';
import 'package:gym_app/controllers/program_controller.dart';
import 'package:gym_app/models/program_models.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/views/program/program_detail_page.dart';

class ChooseProgramSection extends StatelessWidget {
  const ChooseProgramSection({super.key});

  // --- FUNGSI DIUBAH: Menghasilkan gradasi tema Gelap & Elegan ---
  List<Color> _generateGradientColors(String programName) {
    // Daftar palet gradasi gelap yang premium dan modern
    const List<List<Color>> darkGradients = [
      [Color(0xFF434343), Color(0xFF000000)], // Graphite ke Hitam
      [Color(0xFF2c1a1a), Color(0xFF1a1a1a)], // Merah Sangat Tua ke Abu Tua
      [Color(0xFF414345), Color(0xFF232526)], // Abu-abu Metalik
      [Color(0xFF333333), Color(0xFF1E1E1E)], // Klasik Dark
      [Color(0xFF28313B), Color(0xFF485461)], // Abu Kebiruan
    ];

    // Pilih gradasi berdasarkan nama program biar variatif tapi tetap satu tema
    final int index = programName.hashCode % darkGradients.length;
    return darkGradients[index];
  }

  // --- FUNGSI UNTUK PILIH IKON OTOMATIS (TETAP SAMA) ---
  IconData _getIconForProgram(String programName) {
    // Daftar ikon yang bisa kita pakai
    const List<IconData> icons = [
      Icons.fitness_center,       // Dumbbell
      Icons.local_fire_department,  // Api (untuk HIIT)
      Icons.directions_run,       // Lari (untuk Cardio)
      Icons.self_improvement,     // Yoga/Meditasi
      Icons.pool,                 // Renang
      Icons.shield_outlined,      // Defense/Martial Arts
    ];
    // Pilih ikon berdasarkan nama program biar konsisten
    return icons[programName.hashCode % icons.length];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Program',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Consumer<ProgramController>(
            builder: (context, controller, child) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator(color: Colors.white));
              }
              if (controller.errorMessage != null) {
                return Center(child: Text(controller.errorMessage!, style: const TextStyle(color: Colors.red)));
              }
              if (controller.programs.isEmpty) {
                return const Center(child: Text('Tidak ada program tersedia.', style: TextStyle(color: Colors.white70)));
              }
              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.programs.length,
                  itemBuilder: (context, index) {
                    final program = controller.programs[index];
                    return _buildProgramCard(context, program);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- WIDGET KARTU PROGRAM (TIDAK ADA PERUBAHAN, OTOMATIS PAKAI WARNA BARU) ---
  Widget _buildProgramCard(BuildContext context, Program program) {
    // Panggil fungsi helper kita yang sudah diubah
    final gradientColors = _generateGradientColors(program.name);
    final iconData = _getIconForProgram(program.name);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgramDetailPage(id: program.id),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          // Gunakan gradient yang sudah kita buat
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Stack(
          children: [
            // Ikon besar sebagai background pattern
            Positioned(
              top: -20,
              right: -20,
              child: Icon(
                iconData,
                size: 140,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Gradient hitam di bawah untuk memperjelas teks
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.6]
                ),
              ),
            ),
            // Teks informasi program
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(blurRadius: 2, color: Colors.black87)]
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '30 Hari Program',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
