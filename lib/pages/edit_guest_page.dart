import 'package:flutter/material.dart';
import '../models/guest.dart';
import '../services/guest_service.dart';

class EditGuestPage extends StatefulWidget {
  final Guest guest;
  const EditGuestPage({super.key, required this.guest});

  @override
  State<EditGuestPage> createState() => _EditGuestPageState();
}

class _EditGuestPageState extends State<EditGuestPage> {
  final service = GuestService();

  late TextEditingController nameController;
  late TextEditingController asalController;

  bool isLoading = false;

  static const Color cream = Color(0xFFFFF8EE);
  static const Color gold = Color(0xFFC9A24D);
  static const Color darkGold = Color(0xFF9E7C19);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.guest.name);
    asalController = TextEditingController(text: widget.guest.asal);
  }

  Future<void> updateGuest() async {
    if (nameController.text.trim().isEmpty) return;

    setState(() => isLoading = true);

    await service.updateGuest(
      id: widget.guest.id,
      name: nameController.text.trim(),
      asal: asalController.text.trim(),
    );

    setState(() => isLoading = false);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkGold),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Undangan",
          style: TextStyle(
            color: darkGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ===== CARD FORM =====
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // NAMA
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nama Tamu",
                      labelStyle:
                          const TextStyle(color: darkGold),
                      prefixIcon:
                          const Icon(Icons.person, color: gold),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ASAL / INSTANSI
                  TextField(
                    controller: asalController,
                    decoration: InputDecoration(
                      labelText: "Asal / Instansi",
                      labelStyle:
                          const TextStyle(color: darkGold),
                      prefixIcon:
                          const Icon(Icons.location_city, color: gold),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ===== BUTTON SIMPAN =====
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateGuest,
                style: ElevatedButton.styleFrom(
                  backgroundColor: gold,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Simpan Perubahan",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
