import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gym_app/controllers/ai_form_checker_controller.dart';
import 'package:gym_app/models/form_check_result_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AiFormCheckerPage extends StatefulWidget {
  const AiFormCheckerPage({super.key});

  @override
  State<AiFormCheckerPage> createState() => _AiFormCheckerPageState();
}

class _AiFormCheckerPageState extends State<AiFormCheckerPage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  
  // --- PERUBAHAN 1: Ganti state String dengan TextEditingController ---
  final TextEditingController _exerciseController = TextEditingController(text: 'Squat');

  @override
  void dispose() {
    // Jangan lupa dispose controller untuk mencegah memory leak
    _exerciseController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    Provider.of<AiFormCheckerController>(context, listen: false).clearResult();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Fungsi untuk memulai analisis
  void _analyze() {
    final exerciseName = _exerciseController.text.trim();
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih gambar terlebih dahulu!')));
      return;
    }
    if (exerciseName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama latihan tidak boleh kosong!')));
      return;
    }
    
    // --- PERUBAHAN 2: Ambil nama latihan dari controller ---
    Provider.of<AiFormCheckerController>(context, listen: false)
        .analyzeForm(imageFile: _image!, exerciseName: exerciseName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('AI Form Checker', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1c1c1e),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- PERUBAHAN 3: Ganti Dropdown dengan TextField ---
            _buildExerciseInputField(),
            const SizedBox(height: 20),

            _buildImagePicker(),
            const SizedBox(height: 30),

            Consumer<AiFormCheckerController>(
              builder: (context, controller, child) {
                return ElevatedButton(
                  onPressed: controller.isLoading ? null : _analyze,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: controller.isLoading
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Cek Form Saya', style: TextStyle(fontSize: 18, color: Colors.white)),
                );
              },
            ),
            const SizedBox(height: 30),

            // Area untuk menampilkan hasil (tidak ada perubahan di sini)
            Consumer<AiFormCheckerController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: Text("Menganalisis gambar...", style: TextStyle(color: Colors.white70)));
                }
                if (controller.errorMessage != null) {
                  return Center(child: Text(controller.errorMessage!, style: const TextStyle(color: Colors.red)));
                }
                if (controller.result != null) {
                  return _buildResultCard(controller.result!);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget baru untuk TextField ---
  Widget _buildExerciseInputField() {
    return TextField(
      controller: _exerciseController,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: 'Nama Latihan',
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF2c2c2e),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  // Widget-widget helper lainnya (tidak ada perubahan)
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 250,
        decoration: BoxDecoration(
          color: const Color(0xFF2c2c2e),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(_image!, fit: BoxFit.cover),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined, color: Colors.white70, size: 50),
                    SizedBox(height: 10),
                    Text('Ketuk untuk memilih gambar', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildResultCard(FormCheckResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2c2c2e),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hasil Analisis (Skor: ${result.score}/100)', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(color: Colors.grey),
          const SizedBox(height: 10),
          ...result.feedbackPoints.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  point.type == 'good' ? Icons.check_circle_outline : Icons.error_outline,
                  color: point.type == 'good' ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(point.point, style: const TextStyle(color: Colors.white, fontSize: 15))),
              ],
            ),
          )).toList(),
          const SizedBox(height: 10),
          const Text('Ringkasan:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Text(result.summary, style: const TextStyle(color: Colors.white70, fontSize: 15)),
        ],
      ),
    );
  }
}
