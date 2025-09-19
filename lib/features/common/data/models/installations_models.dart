import 'dart:typed_data';
import 'package:isar/isar.dart';

part 'installations_models.g.dart';

@collection
class InstallationRequest {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String code; // INS1, INS2, ...

  late String clientName;
  late DateTime date;
  String phone = '';
  String modelType = '';
  String config = '';
  String accessories = '';
  String level = 'Green';
  String comment = '';
}

@collection
class InstallationCompletion {
  Id id = Isar.autoIncrement;

  @Index()
  late String code; // links to InstallationRequest.code

  DateTime date = DateTime.now();
  String technicianName = '';
  String managerName = '';
  String modelType = '';
  int quantity = 0;
  String accessories = '';
  String comment = '';

  // PNG signature bytes (optional)
  List<int>? managerSignaturePng;
}
