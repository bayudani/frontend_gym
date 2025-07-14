// lib/views/profile/attendance_history_page.dart (atau di mana pun file ini berada)

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/controllers/attends_controller.dart';
import 'package:gym_app/models/attends_models.dart';

class AttendanceHistoryPage extends StatefulWidget {
  const AttendanceHistoryPage({super.key});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AttendanceController>(
        context,
        listen: false,
      ).fetchAttendanceHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Riwayat Absen',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Consumer<AttendanceController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (controller.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Oops! ${controller.errorMessage}',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (controller.records.isEmpty) {
            return const Center(
              child: Text(
                'Kamu belum pernah absen.',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => controller.fetchAttendanceHistory(),
            color: Colors.white,
            backgroundColor: Colors.grey[800],
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20.0,
              ),
              itemCount: controller.records.length,
              itemBuilder: (context, index) {
                final AttendanceRecord record = controller.records[index];
                return _buildAttendanceCard(record.formattedScanDateTime, true);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttendanceCard(String date, bool present) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Icon(
            present ? Icons.check_circle : Icons.cancel,
            color: present ? const Color(0xFF4CAF50) : const Color(0xFFF44336),
            size: 28,
          ),
        ],
      ),
    );
  }
}
