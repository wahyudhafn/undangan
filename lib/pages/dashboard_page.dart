import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/guest.dart';
import '../services/guest_service.dart';
import 'guest_list_page.dart';
import 'add_guest_page.dart';
import 'auth/login_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final service = GuestService();
  Future<List<Guest>>? futureGuests;

  static const Color cream = Color(0xFFFFF8EE);
  static const Color gold = Color(0xFFC9A24D);
  static const Color darkGold = Color(0xFF9E7C19);

  @override
  void initState() {
    super.initState();
    _checkSessionAndLoad();
  }

  // =====================
  // CEK SESSION LOGIN
  // =====================
  void _checkSessionAndLoad() {
    final session = Supabase.instance.client.auth.currentSession;

    if (session == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      });
      return;
    }

    setState(() {
      futureGuests = service.getGuests();
    });
  }

  void refresh() {
    setState(() {
      futureGuests = service.getGuests();
    });
  }

  // =====================
  // LOGOUT
  // =====================
  Future<void> logout() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,

      appBar: AppBar(
        backgroundColor: cream,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Dashboard Buku Tamu",
          style: TextStyle(
            color: darkGold,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: darkGold),
            onPressed: logout,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: gold,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddGuestPage()),
          );
          refresh();
        },
      ),

      body: futureGuests == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Guest>>(
              future: futureGuests,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text("Gagal mengambil data"));
                }

                final guests = snapshot.data!;
                final totalUndangan = guests.length;
                final totalHadir = guests.where((g) => g.hadir).length;
                final progress = totalUndangan == 0
                    ? 0.0
                    : totalHadir / totalUndangan;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [darkGold, gold],
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Text(
                          "Selamat Datang di Acara Kami",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      dashboardCard(
                        "Tamu Hadir",
                        "$totalHadir Orang",
                        Icons.check_circle,
                        gold,
                      ),

                      dashboardCard(
                        "Total Undangan",
                        "$totalUndangan Undangan",
                        Icons.people,
                        darkGold,
                      ),

                      const SizedBox(height: 24),

                      // PROGRESS
                      const Text(
                        "Progress Kehadiran",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkGold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 14,
                          backgroundColor: Colors.grey.shade300,
                          valueColor:
                              const AlwaysStoppedAnimation(gold),
                        ),
                      ),

                      const SizedBox(height: 6),
                      Text(
                        "$totalHadir dari $totalUndangan undangan",
                        style: const TextStyle(color: darkGold),
                      ),

                      const SizedBox(height: 30),

                      // GRAFIK
                      const Text(
                        "Grafik Jam Kedatangan",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: darkGold,
                        ),
                      ),
                      const SizedBox(height: 12),

                      grafikJamKedatangan(guests),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gold,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Lihat Buku Tamu",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GuestListPage(),
                              ),
                            );

                            if (result == true) {
                              refresh();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// =====================
// CARD DASHBOARD
// =====================
Widget dashboardCard(
  String title,
  String value,
  IconData icon,
  Color color,
) {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

// =====================
// GRAFIK JAM KEDATANGAN
// =====================
Widget grafikJamKedatangan(List<Guest> guests) {
  final Map<int, int> dataJam = {};

  for (var g in guests) {
    if (g.hadir && g.createdAt != null) {
      final jam = g.createdAt!.hour;
      dataJam[jam] = (dataJam[jam] ?? 0) + 1;
    }
  }

  if (dataJam.isEmpty) {
    return const Text(
      "Belum ada tamu hadir",
      style: TextStyle(color: Color(0xFF9E7C19)),
    );
  }

  final sortedKeys = dataJam.keys.toList()..sort();

  return SizedBox(
    height: 250,
    child: BarChart(
      BarChartData(
        barGroups: sortedKeys.map((jam) {
          return BarChartGroupData(
            x: jam,
            barRods: [
              BarChartRodData(
                toY: dataJam[jam]!.toDouble(),
                width: 18,
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFC9A24D),
              ),
            ],
          );
        }).toList(),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) => Text(
                "${value.toInt()}:00",
                style:
                    const TextStyle(color: Color(0xFF9E7C19)),
              ),
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
      ),
    ),
  );
}
