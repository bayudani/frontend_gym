class Member {
  final String id;
  final String fullName;
  final String? address;
  final String? phone;
  final bool? isActive;
  final String? start_date;
  final String? end_date;
  final int? point;
  final String? membership_status;

  Member({
    required this.id,
    required this.fullName,
    this.address,
    this.phone,
    this.isActive,
    this.start_date,
    this.end_date,
    this.point,
    this.membership_status,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? 'Nama Tidak Ditemukan',
      address: json['addres'],
      phone: json['phone'],
      isActive: json['is_active'] ?? false,
      start_date: json['start_date'],
      end_date: json['end_date'],
      point: json['point'] != null ? int.tryParse(json['point'].toString()) : 0,
      membership_status: json['membership_status'] ?? 'Tidak Diketahui',
    );
  }
}
