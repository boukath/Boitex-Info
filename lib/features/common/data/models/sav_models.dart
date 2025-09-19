import 'package:isar/isar.dart';

part 'sav_models.g.dart';

@collection
class SavRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String code; // SAV1, ...

  DateTime date = DateTime.now();
  String client = '';
  DateTime arrival = DateTime.now();
  DateTime ret = DateTime.now();
  String diagnostic = '';
  String repairPerformed = '';
  String partChanged = '';
}
