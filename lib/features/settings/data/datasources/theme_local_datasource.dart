import 'package:flutter/material.dart';

import '../../../../core/database/powersync_config.dart';

class ThemeLocalDataSource {
  static const _settingId = 'theme_mode';

  Future<void> _ensureSettingsTable() async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS app_settings (
        id TEXT PRIMARY KEY,
        value TEXT
      )
    ''');
  }

  Stream<ThemeMode> watchThemeMode() async* {
    await PowerSyncConfig.ensureReady();
    await _ensureSettingsTable();

    yield* db
        .watch("SELECT value FROM app_settings WHERE id = '$_settingId'")
        .map((rows) {
          if (rows.isEmpty) {
            return ThemeMode.light;
          }

          final raw = '${rows.first['value'] ?? 'light'}'.toLowerCase();
          return raw == 'dark' ? ThemeMode.dark : ThemeMode.light;
        })
        .distinct();
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    await PowerSyncConfig.ensureReady();
    await _ensureSettingsTable();

    final value = mode == ThemeMode.dark ? 'dark' : 'light';
    await db.execute(
      'INSERT OR REPLACE INTO app_settings(id, value) VALUES(?, ?)',
      [_settingId, value],
    );
  }
}
