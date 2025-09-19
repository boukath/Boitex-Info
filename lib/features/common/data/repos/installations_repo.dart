import 'package:isar/isar.dart';
import '../models/installations_models.dart';
import '_code_counter_repo.dart';

class InstallationsRepo {
  final Isar isar;
  final CodeCounterRepo _counters;
  InstallationsRepo(this.isar) : _counters = CodeCounterRepo(isar);

  Future<String> peekNextCode() => _counters.peekNext('INS');
  Future<String> nextCode() => _counters.nextCode('INS');

  Future<void> addRequest(InstallationRequest r) async {
    await isar.writeTxn(() async {
      await isar.installationRequests.put(r);
    });
  }

  Future<void> addCompletion(InstallationCompletion c) async {
    await isar.writeTxn(() async {
      await isar.installationCompletions.put(c);
    });
  }

  Future<InstallationCompletion?> completionFor(String code) {
    return isar.installationCompletions.filter().codeEqualTo(code).findFirst();
  }

  Future<List<InstallationRequest>> filtered({String? clientSub, DateTime? from, DateTime? to}) async {
    var q = isar.installationRequests.filter();
    if (clientSub != null && clientSub.trim().isNotEmpty) {
      q = q.clientNameContains(clientSub, caseSensitive: false);
    }
    if (from != null) {
      q = q.dateGreaterThan(DateTime(from.year, from.month, from.day).subtract(const Duration(milliseconds: 1)));
    }
    if (to != null) {
      q = q.dateLessThan(DateTime(to.year, to.month, to.day, 23, 59, 59, 999));
    }
    return q.sortByDateDesc().findAll();
  }

  Future<List<InstallationRequest>> all() =>
      isar.installationRequests.where().sortByDateDesc().findAll();
}
