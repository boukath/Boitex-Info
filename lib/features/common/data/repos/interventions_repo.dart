import 'package:isar/isar.dart';
import '../models/interventions_models.dart';
import '_code_counter_repo.dart';

class InterventionsRepo {
  final Isar isar;
  final CodeCounterRepo _counters;
  InterventionsRepo(this.isar) : _counters = CodeCounterRepo(isar);

  Future<String> peekNextCode() => _counters.peekNext('INT');
  Future<String> nextCode() => _counters.nextCode('INT');

  Future<void> addRequest(InterventionRequest r) async {
    await isar.writeTxn(() async {
      await isar.interventionRequests.put(r);
    });
  }

  Future<void> addReport(TechnicianReport rep) async {
    await isar.writeTxn(() async {
      await isar.technicianReports.put(rep);
    });
  }

  Future<TechnicianReport?> reportFor(String code) {
    return isar.technicianReports.filter().codeEqualTo(code).findFirst();
  }

  Future<List<InterventionRequest>> all() =>
      isar.interventionRequests.where().sortByDateDesc().findAll();

  Future<List<InterventionRequest>> filtered({String? clientSub, DateTime? from, DateTime? to}) async {
    var q = isar.interventionRequests.filter();
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
}
