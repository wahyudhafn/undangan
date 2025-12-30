import 'package:flutter/material.dart';
import '../models/guest.dart';

class GuestCard extends StatelessWidget {
  final Guest guest;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onCheckin;

  const GuestCard({
    super.key,
    required this.guest,
    required this.onEdit,
    required this.onDelete,
    required this.onCheckin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(guest.name),
        subtitle: Text(guest.asal),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!guest.hadir)
              IconButton(
                icon: const Icon(Icons.login, color: Colors.green),
                onPressed: onCheckin,
              ),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
