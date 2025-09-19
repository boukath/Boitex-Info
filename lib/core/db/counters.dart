import 'package:isar/isar.dart';

part 'counters.g.dart';

@collection
class CodeCounter {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key; // e.g. 'INT', 'INS', 'SAV', 'BL'

  int nextValue = 1;
}
