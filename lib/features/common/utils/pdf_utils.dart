import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

Uint8List? fromB64(String? s) {
  if (s == null || s.isEmpty) return null;
  try {
    return base64Decode(s);
  } catch (_) {
    return null;
  }
}

String? toB64(Uint8List? bytes) {
  if (bytes == null) return null;
  return base64Encode(bytes);
}

Future<String> saveTempPdf(Uint8List bytes, String filename) async {
  final dir = await getTemporaryDirectory();
  final path = '${dir.path}/$filename';
  final file = File(path);
  await file.writeAsBytes(bytes, flush: true);
  return path;
}

Future<void> sharePdfBytes(Uint8List bytes, String filename, {String? text}) async {
  final path = await saveTempPdf(bytes, filename);
  await Share.shareXFiles([XFile(path)], text: text);
}
