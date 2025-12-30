import 'package:flutter/material.dart';
import '../services/guest_service.dart';

class AddGuestPage extends StatefulWidget {
  const AddGuestPage({super.key});

  @override
  State<AddGuestPage> createState() => _AddGuestPageState();
}

class _AddGuestPageState extends State<AddGuestPage> {
  final service = GuestService();

  final nameController = TextEditingController();
  final asalController = TextEditingController();

  bool isLoading = false;

  static const Color cream = Color(0xFFFFF8EE);
  static const Color gold = Color(0xFFC9A24D);
  static const Color darkGold = Color(0xFF9E7C19);

  Future<void> saveGuest() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tamu wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    await service.addGuest(
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
          "Tambah Undangan",
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
                  // NAMA TAMU
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
                      prefixIcon: const Icon(
                        Icons.location_city,
                        color: gold,
                      ),
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
                onPressed: isLoading ? null : saveGuest,
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
                        "Simpan Undangan",
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
