import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/database/powersync_config.dart'; // Import config baru

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Beri timeout 5 detik agar tidak stuck selamanya
  await PowerSyncConfig.init();

  runApp(const ProviderScope(child: FocusFlowApp()));
}
