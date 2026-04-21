import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/task/presentation/pages/home_screen.dart';
import 'providers/theme_provider.dart';

class FocusFlowApp extends ConsumerWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.maybeWhen(
      data: (mode) => mode,
      orElse: () => ThemeMode.light,
    );

    return MaterialApp(
      title: 'Focus Flow',
      debugShowCheckedModeBanner: false,

      // 🌗 Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,

      // 🧭 Navigation (future-ready)
      home: const HomeScreen(),
      // Agar scroll terasa natural di semua device
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      // 💡 Optional (biar UX lebih halus)
      themeAnimationDuration: const Duration(milliseconds: 200),
    );
  }
}
