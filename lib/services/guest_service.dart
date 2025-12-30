import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/guest.dart';

class GuestService {
  final SupabaseClient _client = Supabase.instance.client;

  // =============================
  // READ – Ambil semua undangan
  // =============================
  Future<List<Guest>> getGuests() async {
    final data = await _client
        .from('guestbook')
        .select()
        .order('created_at', ascending: false, nullsFirst: true);

    return data.map<Guest>((e) => Guest.fromMap(e)).toList();
  }

  // =============================
  // CREATE – Tambah undangan (BELUM HADIR)
  // =============================
  Future<void> addGuest({
    required String name,
    required String asal,
  }) async {
    await _client.from('guestbook').insert({
      'name': name,
      'asal': asal,
      'hadir': false,
      'created_at': null, // belum datang
    });
  }

  // =============================
  // CHECK-IN – Tandai hadir + isi waktu
  // =============================
  Future<void> checkinGuest(String id) async {
    await _client
        .from('guestbook')
        .update({
          'hadir': true,
          'created_at': DateTime.now().toIso8601String(),
        })
        .eq('id', id);
  }

  // =============================
  // UPDATE – Edit data undangan
  // (hanya sebelum check-in)
  // =============================
  Future<void> updateGuest({
    required String id,
    required String name,
    required String asal,
  }) async {
    await _client
        .from('guestbook')
        .update({
          'name': name,
          'asal': asal,
        })
        .eq('id', id);
  }

  // =============================
  // DELETE – Hapus undangan
  // =============================
  Future<void> deleteGuest(String id) async {
    await _client.from('guestbook').delete().eq('id', id);
  }

  // =============================
  // SEARCH – Cari undangan
  // =============================
  Future<List<Guest>> searchGuest(String keyword) async {
    final data = await _client
        .from('guestbook')
        .select()
        .ilike('name', '%$keyword%')
        .order('created_at', ascending: false, nullsFirst: true);

    return data.map<Guest>((e) => Guest.fromMap(e)).toList();
  }

  // =============================
  // DASHBOARD DATA
  // =============================

  // Total tamu hadir
  Future<int> getTotalHadir() async {
    final data = await _client
        .from('guestbook')
        .select('id')
        .eq('hadir', true);

    return data.length;
  }

  // Total undangan
  Future<int> getTotalUndangan() async {
    final data = await _client.from('guestbook').select('id');
    return data.length;
  }

  // Total belum hadir
  Future<int> getTotalBelumHadir() async {
    final data = await _client
        .from('guestbook')
        .select('id')
        .eq('hadir', false);

    return data.length;
  }
}
