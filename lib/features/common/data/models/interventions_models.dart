import 'dart:typed_data';
import 'package:isar/isar.dart';

part 'interventions_models.g.dart';

@collection
class InterventionRequest {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String code; // INT1, INT2, ...

  late String clientName;
  late DateTime date;
  String phone = '';
  String location = '';
  String issue = '';
  String level = 'Green';
}

@collection
class TechnicianReport {
  Id id = Isar.autoIncrement;

  @Index()
  late String code; // links to InterventionRequest.code

  String technician = '';
  String manager = '';
  DateTime arrive = DateTime.now();
  DateTime depart = DateTime.now();
  String modelType = '';
  String diagnosis = '';
  String reparation = '';

  // PNG signature bytes (optional)
  List<int>? signaturePng;
}
