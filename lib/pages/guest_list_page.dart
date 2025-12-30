import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/guest.dart';
import '../services/guest_service.dart';
import 'add_guest_page.dart';
import 'edit_guest_page.dart';

class GuestListPage extends StatefulWidget {
  const GuestListPage({super.key});

  @override
  State<GuestListPage> createState() => _GuestListPageState();
}

class _GuestListPageState extends State<GuestListPage> {
  final service = GuestService();
  List<Guest> guests = [];
  List<Guest> filteredGuests = [];

  static const Color cream = Color(0xFFFFF8EE);
  static const Color gold = Color(0xFFC9A24D);
  static const Color darkGold = Color(0xFF9E7C19);

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await service.getGuests();
    setState(() {
      guests = data;
      filteredGuests = data;
    });
  }

  void searchGuest(String query) {
    setState(() {
      filteredGuests = guests
          .where((g) =>
              g.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> deleteGuest(Guest g) async {
    await service.deleteGuest(g.id);
    loadData();
  }

  Future<void> checkinGuest(Guest g) async {
    await service.checkinGuest(g.id);
    loadData();
  }

  Future<void> editGuest(Guest g) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditGuestPage(guest: g)),
    );
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ⬅️ HANDLE BACK BUTTON / GESTURE
      onWillPop: () async {
        Navigator.pop(context, true);
        return false;
      },
      child: Scaffold(
        backgroundColor: cream,

        appBar: AppBar(
          backgroundColor: cream,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: darkGold),
            // ⬅️ KIRIM SIGNAL KE DASHBOARD
            onPressed: () => Navigator.pop(context, true),
          ),
          title: const Text(
            "Daftar Tamu Undangan",
            style: TextStyle(
              color: darkGold,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: gold,
          child: const Icon(Icons.add, color: Colors.white),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AddGuestPage()),
            );
            loadData();
          },
        ),

        body: Column(
          children: [
            // SEARCH
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: searchGuest,
                decoration: InputDecoration(
                  hintText: "Cari nama tamu...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // LIST
            Expanded(
              child: filteredGuests.isEmpty
                  ? const Center(
                      child: Text(
                        "Belum ada tamu",
                        style: TextStyle(color: darkGold),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredGuests.length,
                      itemBuilder: (context, index) {
                        final g = filteredGuests[index];

                        return Dismissible(
                          key: ValueKey(g.id),
                          direction: DismissDirection.horizontal,

                          // SWIPE KANAN – EDIT
                          background: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.only(left: 20),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.edit,
                                color: Colors.white),
                          ),

                          // SWIPE KIRI – DELETE
                          secondaryBackground: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            decoration: BoxDecoration(
                              color: Colors.red.shade400,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: const Icon(Icons.delete,
                                color: Colors.white),
                          ),

                          confirmDismiss: (direction) async {
                            if (direction ==
                                DismissDirection.startToEnd) {
                              await editGuest(g);
                              return false;
                            }

                            if (direction ==
                                DismissDirection.endToStart) {
                              return await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title:
                                      const Text("Hapus Undangan"),
                                  content: Text(
                                      "Yakin hapus ${g.name}?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(
                                              context, false),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(
                                              context, true),
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(
                                            color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return false;
                          },

                          onDismissed: (_) => deleteGuest(g),

                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(18),
                            onTap: g.hadir
                                ? null
                                : () async {
                                    await checkinGuest(g);
                                  },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: g.hadir
                                        ? gold
                                        : Colors.grey.shade300,
                                    child: Icon(
                                      g.hadir
                                          ? Icons.check
                                          : Icons.person,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          g.name,
                                          style: const TextStyle(
                                            fontWeight:
                                                FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          g.asal,
                                          style: TextStyle(
                                            color: Colors
                                                .grey.shade700,
                                          ),
                                        ),
                                        if (g.hadir &&
                                            g.createdAt != null)
                                          Text(
                                            "Datang: ${DateFormat('HH:mm').format(g.createdAt!)}",
                                            style: const TextStyle(
                                              color: darkGold,
                                              fontSize: 12,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6),
                                    decoration: BoxDecoration(
                                      color: g.hadir
                                          ? gold
                                          : Colors.grey.shade300,
                                      borderRadius:
                                          BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      g.hadir ? "HADIR" : "BELUM",
                                      style: TextStyle(
                                        color: g.hadir
                                            ? Colors.white
                                            : Colors.black54,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
