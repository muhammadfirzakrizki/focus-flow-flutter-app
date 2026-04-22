import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task_entity.dart';
import '../providers/task_providers.dart';
import '../widgets/timer_display.dart';
import 'package:focus_flow/core/ui_kit/app_button.dart';
import 'package:focus_flow/core/ui_kit/app_sheet.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final TaskEntity task;
  const TimerScreen({super.key, required this.task});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  late final int _initialDurationMs;
  late int _remainingDurationMs;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _initialDurationMs = widget.task.duration * 1000;
    _remainingDurationMs = widget.task.remainingDurationMs <= 0
        ? _initialDurationMs
        : widget.task.remainingDurationMs;
  }

  Future<void> _toggleTimer() async {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
      await _saveProgress();
      return;
    } else {
      if (_remainingDurationMs <= 0) {
        await _finishTask();
        return;
      }

      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_remainingDurationMs > 0) {
          setState(() {
            _remainingDurationMs = _remainingDurationMs > 100
                ? _remainingDurationMs - 100
                : 0;
          });
          if (_remainingDurationMs == 0) {
            timer.cancel();
            _finishTask();
          }
        } else {
          timer.cancel();
          _finishTask();
        }
      });
      setState(() => _isRunning = true);
    }
  }

  Future<void> _saveProgress() async {
    final updatedTask = widget.task.copyWith(
      remainingDurationMs: _remainingDurationMs,
      isDone: false,
    );

    try {
      await ref.read(taskControllerProvider).saveTask(updatedTask);
    } catch (_) {
      if (!mounted) return;
      await AppSheet.showConfirmation(
        context: context,
        title: "Penyimpanan Gagal",
        description: "Progress belum tersimpan ke database.",
        icon: Icons.error_outline_rounded,
        confirmLabel: "OK",
        confirmColor: Colors.redAccent,
        onConfirm: () {},
      );
    }
  }

  Future<void> _finishTask() async {
    _timer?.cancel();
    setState(() => _isRunning = false);

    final completedTask = widget.task.copyWith(
      isDone: true,
      remainingDurationMs: 0,
    );

    try {
      await ref.read(taskControllerProvider).completeTask(completedTask);
    } catch (_) {
      if (!mounted) return;
      await AppSheet.showConfirmation(
        context: context,
        title: "Koneksi Database Gagal",
        description: "Gagal terhubung ke database. Coba lagi sebentar.",
        icon: Icons.wifi_off_rounded,
        confirmLabel: "OK",
        confirmColor: Colors.redAccent,
        onConfirm: () {},
      );
      return;
    }

    _showFinishedDialog(completedTask);
  }

  void _showFinishedDialog(TaskEntity completedTask) {
    AppSheet.showConfirmation(
      context: context,
      title: "Luar Biasa!",
      description:
          "Sesi fokus '${completedTask.title}' telah selesai. Kamu selangkah lebih dekat dengan tujuanmu.",
      icon: Icons.stars_rounded,
      confirmLabel: "KEMBALI KE BERANDA",
      confirmColor: Colors.amber.shade700,
      onConfirm: () {
        // Cukup pop sekali untuk kembali ke Home
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sesi Fokus"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildHeader(colorScheme),
            const Spacer(),
            TimerDisplay(
              progress: _initialDurationMs == 0
                  ? 0
                  : _remainingDurationMs / _initialDurationMs,
              formattedTime: _formatTime(_remainingDurationMs),
              isRunning: _isRunning,
            ),
            const Spacer(),
            _buildActionControls(colorScheme),
            const SizedBox(height: 12),
            _buildSkipButton(colorScheme),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Column(
      children: [
        Text(
          widget.task.title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          widget.task.description,
          textAlign: TextAlign.center,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildActionControls(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: _isRunning ? "PAUSE" : "MULAI",
            icon: _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
            backgroundColor: _isRunning ? Colors.orange : colorScheme.primary,
            onPressed: _toggleTimer,
          ),
        ),
        if (!_isRunning && _remainingDurationMs < _initialDurationMs) ...[
          const SizedBox(width: 12),
          IconButton.filledTonal(
            onPressed: _confirmReset,
            icon: const Icon(Icons.refresh_rounded),
            padding: const EdgeInsets.all(16),
          ),
        ],
      ],
    );
  }

  Widget _buildSkipButton(ColorScheme colorScheme) {
    return TextButton(
      onPressed: _finishTask,
      child: Text(
        "Selesaikan Sekarang",
        style: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _resetTimer() async {
    _timer?.cancel();

    setState(() {
      _remainingDurationMs = _initialDurationMs;
      _isRunning = false;
    });

    // Sekarang baru aman untuk save
    await _saveProgress();
  }

  void _confirmReset() {
    AppSheet.showConfirmation(
      context: context,
      title: "Reset Timer?",
      description:
          "Timer akan kembali ke durasi awal dan progres berjalan saat ini akan hilang.",
      icon: Icons.refresh_rounded,
      confirmLabel: "YA, RESET",
      confirmColor: Theme.of(context).colorScheme.secondary,
      onConfirm: _resetTimer,
    );
  }

  String _formatTime(int ms) {
    final d = Duration(milliseconds: ms);
    final hms = d.toString().split('.').first.padLeft(8, '0');
    final msStr = (ms % 1000 ~/ 10).toString().padLeft(2, '0');

    return '$hms.$msStr';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
