import 'package:isar/isar.dart';
import 'package:isar_flutter_libs/isar_flutter_libs.dart'; // keep, ensures native libs bundled
import 'dart:async';

import '../../features/common/data/models/interventions_models.dart';
import '../../features/common/data/models/installations_models.dart';
import '../../features/common/data/models/sav_models.dart';
import '../../features/common/data/models/livraison_models.dart';
import 'counters.dart';

class IsarService {
  IsarService._();
  static final IsarService i = IsarService._();

  late Isar _isar;
  bool _initialized = false;

  Isar get isar {
    if (!_initialized) {
      throw StateError('IsarService not initialized. Call await IsarService.i.init() in main() before runApp.');
    }
    return _isar;
  }

  Future<void> init() async {
    if (_initialized) return;
    _isar = await Isar.open(
      [
        CodeCounterSchema,
        InterventionRequestSchema,
        TechnicianReportSchema,
        InstallationRequestSchema,
        InstallationCompletionSchema,
        SavRecordSchema,
        LivraisonRecordSchema,
        SaleItemSchema,
      ],
      name: 'boitex_info_isar',
      inspector: false,
    );
    _initialized = true;
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }
}
