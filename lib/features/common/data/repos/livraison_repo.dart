import 'package:isar/isar.dart';
import '../models/livraison_models.dart';
import '_code_counter_repo.dart';

class LivraisonRepo {
  final Isar isar;
  final CodeCounterRepo _counters;
  LivraisonRepo(this.isar) : _counters = CodeCounterRepo(isar);

  Future<String> peekNextCode() => _counters.peekNext('BL');
  Future<String> nextCode() => _counters.nextCode('BL');

  Future<void> add(LivraisonRecord r) async {
    await isar.writeTxn(() async {
      await isar.livraisonRecords.put(r);
    });
  }

  Future<List<LivraisonRecord>> all() =>
      isar.livraisonRecords.where().sortByDateDesc().findAll();
}
