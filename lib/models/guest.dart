class Guest {
  final String id;
  final String name;
  final String asal;
  final bool hadir;
  final DateTime? createdAt;

  Guest({
    required this.id,
    required this.name,
    required this.asal,
    required this.hadir,
    required this.createdAt,
  });

  factory Guest.fromMap(Map<String, dynamic> map) {
    return Guest(
      id: map['id'],
      name: map['name'],
      asal: map['asal'] ?? '',
      hadir: map['hadir'] ?? false,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }
}
