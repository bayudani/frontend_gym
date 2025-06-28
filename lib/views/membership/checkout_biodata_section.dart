import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import image_picker
import 'dart:io'; // Untuk menggunakan kelas File

// Style border input field yang sama dengan halaman login/register
const _outlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(10)),
);

class CheckoutBiodataSection extends StatefulWidget {
  const CheckoutBiodataSection({super.key});

  @override
  State<CheckoutBiodataSection> createState() => _CheckoutBiodataSectionState();
}

class _CheckoutBiodataSectionState extends State<CheckoutBiodataSection> {
  // Controllers untuk input biodata
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Variabel untuk menyimpan gambar yang dipilih
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // Metode untuk memilih gambar dari galeri
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _pickedImage = File(image.path);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil dipilih!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pemilihan gambar dibatalkan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih gambar: $e')),
      );
    }
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
          borderSide: const BorderSide(color: Colors.red), // Fokus border merah
        ),
        filled: true,
        fillColor: Colors.grey[900], // Background field sedikit lebih gelap
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  // Helper Widget untuk Header Bagian (diulang dari MembershipCheckoutPage untuk konsistensi)
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF262626), // Abu-abu gelap
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!), // Border abu-abu tipis
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
          // Dua titik di kanan (dekoratif)
          Row(
            children: [
              Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle)),
              const SizedBox(width: 5),
              Container(width: 5, height: 5, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), shape: BoxShape.circle)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, 'Biodata'),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFF262626), // Abu-abu gelap
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[800]!), // Border abu-abu tipis
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Mohon isi data dengan\nlengkap dan valid',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _nameController,
                hintText: 'Nama lengkap',
                icon: Icons.person,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _phoneController,
                hintText: 'NO HP',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: _addressController,
                hintText: 'Alamat',
                icon: Icons.location_on,
                maxLines: 2, // Izinkan lebih dari satu baris
              ),
              const SizedBox(height: 20), // Jarak ke tombol baru

              // Tombol "Upload Bukti Transaksi"
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _pickImage, // Memanggil _pickImage
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // Latar belakang putih
                    foregroundColor: Colors.black, // Teks hitam
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Upload Bukti Transaksi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              // Opsional: Tampilkan pratinjau gambar yang dipilih
              if (_pickedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    'File dipilih: ${_pickedImage!.path.split('/').last}',
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
