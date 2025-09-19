import 'package:isar/isar.dart';
import '../../../../core/db/counters.dart';

class CodeCounterRepo {
  final Isar isar;
  CodeCounterRepo(this.isar);

  Future<String> nextCode(String prefix) async {
    return await isar.writeTxn<String>(() async {
      final existing = await isar.codeCounters.filter().keyEqualTo(prefix).findFirst();
      if (existing == null) {
        final c = CodeCounter()..key = prefix..nextValue = 2;
        final code = '$prefix1';
        await isar.codeCounters.put(c);
        return code;
      } else {
        final code = '$prefix${existing.nextValue}';
        existing.nextValue += 1;
        await isar.codeCounters.put(existing);
        return code;
      }
    });
  }

  Future<String> peekNext(String prefix) async {
    final existing = await isar.codeCounters.filter().keyEqualTo(prefix).findFirst();
    if (existing == null) return '$prefix1';
    return '$prefix${existing.nextValue}';
  }
}
