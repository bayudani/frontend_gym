import 'package:flutter/material.dart';
import 'package:gym_app/views/membership/membership_card_page.dart'; // Import MembershipCardPage

class MemberCardMenuItem extends StatelessWidget {
  const MemberCardMenuItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.credit_card, color: Colors.white), // Icon Kartu Member
      title: const Text('Kartu Member', style: TextStyle(color: Colors.white, fontSize: 18)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
      onTap: () {
        // PERBAIKAN: Menghapus Navigator.pop(bc)
        // if (Navigator.of(context).canPop()) {
        //   Navigator.pop(context); // Tutup bottom sheet
        // }
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const MembershipCardPage()),
        );
      },
    );
  }
}
