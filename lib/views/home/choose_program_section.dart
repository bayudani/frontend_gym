// lib/views/home/choose_program_section.dart

import 'package:flutter/material.dart';
import 'package:gym_app/controllers/program_controller.dart';
import 'package:gym_app/models/program_models.dart';
import 'package:provider/provider.dart';

class ChooseProgramSection extends StatelessWidget {
  const ChooseProgramSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Choose Program',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // TextButton(
              //   onPressed: () {
              //     // TODO: Buat halaman untuk menampilkan semua program
              //   },
              //   child: const Text(
              //     'See all',
              //     style: TextStyle(color: Colors.red, fontSize: 16),
              //   ),
              // ),
            ],
          ),
          const SizedBox(height: 15),
          // Gunakan Consumer untuk listen ke ProgramController
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

              // Tampilkan list program secara horizontal
              return SizedBox(
                height: 220, // Tentukan tinggi untuk list horizontal
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

  // Widget untuk kartu program
  // Widget untuk kartu program dengan gambar sebagai background
  Widget _buildProgramCard(BuildContext context, Program program) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          image: AssetImage(
              'assets/images/1.png'), // Placeholder image as background
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.name, // Nama program dari API
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                const Text(
                  '30 Hari Program', // Subtitle statis
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}