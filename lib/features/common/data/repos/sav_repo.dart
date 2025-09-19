import 'package:isar/isar.dart';
import '../models/sav_models.dart';
import '_code_counter_repo.dart';

class SavRepo {
  final Isar isar;
  final CodeCounterRepo _counters;
  SavRepo(this.isar) : _counters = CodeCounterRepo(isar);

  Future<String> peekNextCode() => _counters.peekNext('SAV');
  Future<String> nextCode() => _counters.nextCode('SAV');

  Future<void> add(SavRecord r) async {
    await isar.writeTxn(() async {
      await isar.savRecords.put(r);
    });
  }

  Future<List<SavRecord>> filtered({String? clientSub}) async {
    var q = isar.savRecords.filter();
    if (clientSub != null && clientSub.trim().isNotEmpty) {
      q = q.clientContains(clientSub, caseSensitive: false);
    }
    return q.sortByDateDesc().findAll();
  }

  Future<List<SavRecord>> all() => isar.savRecords.where().sortByDateDesc().findAll();
}
