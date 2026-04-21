import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import '../../features/task/data/datasources/task_schema.dart';

late final PowerSyncDatabase db;
Completer<void>? _dbInitCompleter;

class PowerSyncConfig {
  static Future<void> init() async {
    if (_dbInitCompleter != null) {
      return _dbInitCompleter!.future;
    }

    _dbInitCompleter = Completer<void>();

    try {
      // 1. Ambil folder dokumen resmi di Android/iOS
      final dir = await getApplicationDocumentsDirectory();
      final path = join(dir.path, 'focus_flow.db');

      // 2. Inisialisasi Database dengan path absolut
      db = PowerSyncDatabase(schema: mySchema, path: path);

      await db.initialize();
      _dbInitCompleter!.complete();
    } catch (e) {
      _dbInitCompleter!.completeError(e);
      rethrow;
    }
  }

  static Future<void> ensureReady() async {
    if (_dbInitCompleter == null) {
      await init();
      return;
    }

    await _dbInitCompleter!.future;
  }
}
