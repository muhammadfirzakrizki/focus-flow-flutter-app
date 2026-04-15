import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskModel? task; // Tambahkan parameter opsional

  const AddTaskScreen({super.key, this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _timerController;

  @override
  void initState() {
    super.initState();
    // Jika sedang edit, isi controller dengan data yang ada
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descController = TextEditingController(
      text: widget.task?.description ?? "",
    );
    _timerController = TextEditingController(
      text: widget.task?.duration.toString() ?? "25",
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  void _submitData() {
    final String enteredTitle = _titleController.text;
    final String enteredDesc = _descController.text;
    final int? enteredDuration = int.tryParse(_timerController.text);

    if (enteredTitle.isEmpty ||
        enteredDesc.isEmpty ||
        enteredDuration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Isi semua data dengan benar!")),
      );
      return;
    }

    final updatedTask = TaskModel(
      // Jika edit, pakai ID lama. Jika baru, pakai timestamp baru.
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch,
      title: enteredTitle,
      description: enteredDesc,
      duration: enteredDuration,
      isDone: widget.task?.isDone ?? false,
    );

    Navigator.pop(context, updatedTask);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Fokus' : 'Tambah Fokus Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Apa fokus utamamu?"),
            TextField(
              controller: _titleController,
              decoration: _inputStyle('Judul Tugas', Icons.title),
            ),
            const SizedBox(height: 20),
            _buildLabel("Detail singkat"),
            TextField(
              controller: _descController,
              decoration: _inputStyle('Deskripsi', Icons.description_outlined),
              maxLines: 2,
            ),
            const SizedBox(height: 20),
            _buildLabel("Durasi Fokus (Detik)"),
            TextField(
              controller: _timerController,
              keyboardType: TextInputType.number, // Memunculkan keyboard angka
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly, // Hanya boleh angka
              ],
              decoration: _inputStyle('Contoh: 30', Icons.timer_outlined),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: _submitData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEdit
                      ? Colors.orange
                      : Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: Icon(isEdit ? Icons.edit : Icons.save),
                label: Text(isEdit ? 'SIMPAN PERUBAHAN' : 'SIMPAN & MULAI'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
