// lib/models/member.dart

class Member {
  final String id;
  final String fullName;
  final String? address;
  final String? phone;
  // TODO: Tambahkan properti untuk tanggal berakhir jika nanti ada di API
  // final DateTime? expiryDate;

  Member({
    required this.id,
    required this.fullName,
    this.address,
    this.phone,
    // this.expiryDate,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? 'Nama Tidak Ditemukan',
      address: json['addres'], // 'addres' sesuai dari API-mu
      phone: json['phone'],
      // expiryDate: DateTime.tryParse(json['expiry_date'] ?? ''),
    );
  }
}