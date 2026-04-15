import 'package:flutter/material.dart';
import 'package:focus_flow/presentation/screens/add_task_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import ini
import 'package:google_fonts/google_fonts.dart'; // Import ini

void main() {
  runApp(const FocusFlowApp());
}

class FocusFlowApp extends StatelessWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple, // Warna ungu lebih terkesan "Focus"
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Inisialisasi list tugas yang bisa berubah
  List<String> _tasks = ["Belajar Flutter Dasar"];

  @override
  void initState() {
    super.initState();
    _loadTasks(); // Ambil data saat aplikasi pertama kali dibuka
  }

  // Memuat data dari memori HP
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tasks = prefs.getStringList('saved_tasks') ?? ["Belajar Flutter Dasar"];
    });
  }

  // Menyimpan data ke memori HP
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('saved_tasks', _tasks);
  }

  // Modifikasi fungsi tambah
  void _addTask(String task) {
    setState(() {
      _tasks.add(task);
    });
    _saveTasks(); // Simpan setiap ada perubahan
  }

  // Modifikasi fungsi hapus
  void _deleteTask(int index) {
    final deletedTask = _tasks[index];
    setState(() {
      _tasks.removeAt(index);
    });
    _saveTasks(); // Simpan setiap ada perubahan
    // Munculkan notifikasi
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("'$deletedTask' dihapus"),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: "OK", onPressed: () {}),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FocusFlow',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: _tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gunakan Opacity widget untuk mengatur transparansi
                  Opacity(
                    opacity: 0.3,
                    child: const Icon(
                      Icons.task_outlined, // Ikon yang pasti ada di Flutter
                      size: 80,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Opacity(
                    opacity: 0.5,
                    child: const Text(
                      "Belum ada fokus hari ini.",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(
                    _tasks[index] + index.toString(),
                  ), // Key unik untuk Flutter
                  direction:
                      DismissDirection.endToStart, // Geser dari kanan ke kiri
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.redAccent,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteTask(
                      index,
                    ); // Panggil fungsi hapus yang sudah kita buat
                  },
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: Icon(
                        Icons.check_circle_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        _tasks[index],
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: const Text(
                        "Ketuk untuk melihat detail",
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_sweep_outlined,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _deleteTask(index),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
          // 3. addTask hanya dipanggil jika result tidak null dan bertipe String
          if (result != null && result is String) {
            _addTask(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
