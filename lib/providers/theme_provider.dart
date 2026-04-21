import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/settings/data/datasources/theme_local_datasource.dart';

final themeDataSourceProvider = Provider<ThemeLocalDataSource>((ref) {
  return ThemeLocalDataSource();
});

final themeModeProvider = StreamProvider<ThemeMode>((ref) {
  return ref.watch(themeDataSourceProvider).watchThemeMode();
});

class ThemeController extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> setThemeMode(ThemeMode mode) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(themeDataSourceProvider).saveThemeMode(mode);
    });
  }
}

final themeControllerProvider = AsyncNotifierProvider<ThemeController, void>(
  ThemeController.new,
);
