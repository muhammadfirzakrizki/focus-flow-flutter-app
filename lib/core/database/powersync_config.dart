import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'app_schema.dart';

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
      db = PowerSyncDatabase(schema: appSchema, path: path);

      await db.initialize();
      await _ensureTaskRemainingDurationColumn();
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

  static Future<void> _ensureTaskRemainingDurationColumn() async {
    final columns = await db.getAll('PRAGMA table_info(tasks)');
    final hasRemainingDurationColumn = columns.any(
      (column) => '${column['name']}' == 'remaining_duration_ms',
    );

    if (hasRemainingDurationColumn) {
      return;
    }

    await db.execute(
      'ALTER TABLE tasks ADD COLUMN remaining_duration_ms INTEGER',
    );
    await db.execute(
      '''
      UPDATE tasks
      SET remaining_duration_ms = COALESCE(duration * 1000, 0)
      WHERE remaining_duration_ms IS NULL OR remaining_duration_ms = 0
      ''',
    );
  }
}
