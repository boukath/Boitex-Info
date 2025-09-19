import 'package:isar/isar.dart';

part 'livraison_models.g.dart';

@embedded
class SaleItem {
  String article = '';
  int qty = 0;
  double? price;
}

@collection
class LivraisonRecord {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String code; // BL1, ...

  DateTime date = DateTime.now();
  String client = '';
  String phone = '';
  String location = '';

  List<SaleItem> items = [];
}
