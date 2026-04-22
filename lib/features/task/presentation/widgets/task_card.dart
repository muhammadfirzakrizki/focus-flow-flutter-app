import 'package:flutter/material.dart';
import '../../domain/entities/task_entity.dart';
import 'package:focus_flow/core/ui_kit/app_sheet.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final Function(String) onDelete;
  final Function(String, TaskEntity) onEditStatus;
  final VoidCallback onTap;
  final VoidCallback onEditPressed;

  const TaskCard({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onEditStatus,
    required this.onTap,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color statusColor = task.isDone ? Colors.green : colorScheme.primary;

    // Hitung progress (0.0 sampai 1.0)
    final double totalDurationSeconds = task.duration.toDouble();
    final double remainingSeconds = (task.remainingDurationMs / 1000)
        .toDouble();

    // Guard agar tidak pembagian nol
    double progress = 0.0;
    if (totalDurationSeconds > 0) {
      progress =
          ((totalDurationSeconds - remainingSeconds) / totalDurationSeconds)
              .clamp(0.0, 1.0);
    }

    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        bool shouldDelete = false;
        await AppSheet.showConfirmation(
          context: context,
          title: "Hapus Fokus?",
          description: "Tugas '${task.title}' akan dihapus secara permanen.",
          icon: Icons.delete_sweep_rounded,
          confirmLabel: "YA, HAPUS",
          confirmColor: colorScheme.error,
          onConfirm: () => shouldDelete = true,
        );
        return shouldDelete;
      },
      onDismissed: (_) => onDelete(task.id),
      background: _buildDeleteBackground(colorScheme),
      child: Opacity(
        opacity: task.isDone ? 0.6 : 1.0,
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: statusColor.withAlpha(task.isDone ? 100 : 40),
              width: task.isDone ? 2 : 1,
            ),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => task.isDone ? _showResetDialog(context) : onTap(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status Icon
                      _buildStatusIndicator(statusColor),
                      const SizedBox(width: 12),

                      // Title & Description
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isDone
                                    ? colorScheme.onSurfaceVariant
                                    : colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              task.description.isEmpty
                                  ? "Tidak ada deskripsi"
                                  : task.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onSurfaceVariant.withAlpha(
                                  200,
                                ),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Action Button
                      if (!task.isDone)
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: Icon(
                            Icons.edit_note_rounded,
                            color: colorScheme.primary,
                          ),
                          onPressed: onEditPressed,
                        ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Progress Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoTag(
                        context,
                        Icons.av_timer_rounded,
                        "${task.duration} m",
                        colorScheme,
                      ),
                      Text(
                        task.isDone
                            ? "SELESAI"
                            : "${(progress * 100).toInt()}%",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: task.isDone ? 1.0 : progress,
                      minHeight: 8,
                      backgroundColor: statusColor.withAlpha(30),
                      valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        task.isDone ? Icons.check_circle_rounded : Icons.bolt_rounded,
        color: color,
        size: 22,
      ),
    );
  }

  Widget _buildInfoTag(
    BuildContext context,
    IconData icon,
    String label,
    ColorScheme colorScheme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withAlpha(100),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteBackground(ColorScheme colorScheme) {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.delete_sweep_rounded,
        color: colorScheme.onErrorContainer,
        size: 32,
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    AppSheet.showConfirmation(
      context: context,
      title: "Kerjakan Lagi?",
      description:
          "Tugas '${task.title}' sudah selesai. Mau diulang dari awal?",
      icon: Icons.refresh_rounded,
      confirmLabel: "YA, ULANGI",
      confirmColor: Theme.of(context).colorScheme.secondary,
      onConfirm: () {
        final unDoneTask = task.copyWith(
          isDone: false,
          remainingDurationMs: task.duration * 1000,
        );
        onEditStatus(task.id, unDoneTask);
      },
    );
  }
}
