// lib/views/membership/checkout_biodata_section.dart

import 'dart:io'; // Untuk menggunakan kelas File

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker

const _outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class CheckoutBiodataSection extends StatefulWidget {
  // Tambahkan key di constructor agar bisa diakses oleh parent
  const CheckoutBiodataSection({super.key});

  @override
  // State class sekarang jadi public agar bisa diakses via GlobalKey
  CheckoutBiodataSectionState createState() => CheckoutBiodataSectionState();
}

// State class sekarang jadi public (tanpa underscore)
class CheckoutBiodataSectionState extends State<CheckoutBiodataSection> {
  // Controllers dan variabel gambar sekarang jadi public (tanpa underscore)
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  File? pickedImage; // Variabel untuk menyimpan gambar yang dipilih

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          pickedImage = File(image.path); // Menggunakan pickedImage (public)
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gambar berhasil dipilih!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Menangkap PlatformException dan error lainnya
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memilih gambar: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  // Metode untuk menghapus gambar yang dipilih
  void _clearPickedImage() {
    setState(() {
      pickedImage = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gambar berhasil dihapus!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Helper Widget untuk TextField
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        enabledBorder: _outlineInputBorder,
        focusedBorder: _outlineInputBorder.copyWith(
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: Colors.grey[900],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  // Helper Widget untuk Header Bagian
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Biodata & Bukti Transfer'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF262626), // Abu-abu gelap
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey[800]!,
            ), // Border abu-abu tipis
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mohon isi data dengan lengkap dan valid',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: nameController, // pakai controller public
                hintText: 'Nama lengkap',
                icon: Icons.person,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: phoneController, // pakai controller public
                hintText: 'NO HP',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: addressController, // pakai controller public
                hintText: 'Alamat',
                icon: Icons.location_on,
                maxLines: 2,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Colors.white70,
                  ),
                  label: const Text(
                    'Upload Bukti Transaksi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF757575)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              // PERBAIKAN: Tampilkan pratinjau gambar yang dipilih dengan tombol hapus
              if (pickedImage != null) // Menggunakan pickedImage (public)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Stack(
                    // Menggunakan Stack untuk menempatkan tombol hapus di atas gambar
                    alignment:
                        Alignment.topRight, // Menempatkan di sudut kanan atas
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          pickedImage!, // Menggunakan pickedImage (public)
                          height: 150, // Sesuaikan tinggi sesuai kebutuhan
                          width: double.infinity, // Ambil lebar penuh
                          fit:
                              BoxFit
                                  .cover, // Gunakan BoxFit.cover agar gambar mengisi ruang
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
                        child: GestureDetector(
                          onTap:
                              _clearPickedImage, // Memanggil fungsi untuk menghapus gambar
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(
                                0.6,
                              ), // Latar belakang tombol hapus
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close, // Ikon silang
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
