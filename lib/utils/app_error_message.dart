import 'dart:async';
import 'dart:io';

class AppErrorMessage {
  static String from(Object error) {
    if (error is TimeoutException) {
      return 'Koneksi terlalu lama. Periksa internet dan coba lagi.';
    }

    if (error is SocketException || error is HttpException) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
    }

    if (error is FormatException) {
      return 'Format data yang diterima tidak valid. Silakan coba lagi.';
    }

    final message = error.toString();
    final text = message.toLowerCase();

    if (text.contains('row-level security') ||
        text.contains('permission denied') ||
        text.contains('42501')) {
      return 'Akses ditolak. Periksa izin akses database.';
    }

    if (text.contains('23503') || text.contains('foreign key constraint')) {
      return 'Data masih digunakan oleh data lain dan tidak dapat diubah.';
    }

    if (text.contains('23505') || text.contains('duplicate key')) {
      return 'Data tersebut sudah tersedia di database.';
    }

    if (text.contains('pgrst116')) {
      return 'Data tidak ditemukan atau sudah berubah. Muat ulang data.';
    }

    if (text.contains('socketexception') ||
        text.contains('failed host lookup') ||
        text.contains('network is unreachable') ||
        text.contains('connection refused') ||
        text.contains('clientexception')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet.';
    }

    if (text.contains('postgrest') ||
        text.contains('supabase') ||
        text.contains('postgres')) {
      return 'Terjadi masalah saat mengakses database. Silakan coba lagi.';
    }

    if (error is StateError) {
      return message.replaceFirst('Bad state: ', '').trim();
    }

    if (error is ArgumentError) {
      return 'Data yang dikirim tidak valid. Periksa kembali input.';
    }

    if (text.startsWith('exception:')) {
      return message.substring(message.indexOf(':') + 1).trim();
    }

    return 'Terjadi kesalahan yang tidak terduga. Silakan coba lagi.';
  }
}
