import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'api_service.dart';
import 'auth_provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // Cargar variables de entorno
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginScreen(), // Pantalla inicial es el login
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Cargar tareas desde la API
  Future<void> _loadTasks() async {
    try {
      final tasksFromApi = await ApiService.getTasks(context);
      setState(() {
        tasks = tasksFromApi;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Navegar a la pantalla de tarea
  void _navigateToTaskScreen({int? index}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskScreen(
          task: index != null ? tasks[index] : null,
        ),
      ),
    );

    if (result != null) {
      try {
        if (index != null) {
          // Actualizar tarea existente
          await ApiService.updateTask(context, tasks[index]['id'], result);
        } else {
          // Crear nueva tarea
          await ApiService.createTask(context, result);
        }
        _loadTasks(); // Recargar tareas
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  // Eliminar una tarea
  void _deleteTask(int index) async {
    try {
      await ApiService.deleteTask(context, tasks[index]['id']);
      _loadTasks(); // Recargar tareas
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Marcar una tarea como completada
  void _toggleTaskCompletion(int index) async {
    try {
      await ApiService.toggleTaskCompletion(
        context,
        tasks[index]['id'],
        !tasks[index]['completada'],
      );
      _loadTasks(); // Recargar tareas
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: tasks.isEmpty
          ? const Center(
        child: Text(
          'No hay tareas pendientes',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(
                task['titulo'],
                style: TextStyle(
                  decoration: task['completada']
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text(task['descripcion']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _navigateToTaskScreen(index: index); // Editar tarea
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      task['completada']
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                    ),
                    onPressed: () {
                      _toggleTaskCompletion(index);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteTask(index);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToTaskScreen(); // Agregar nueva tarea
        },
        tooltip: 'Agregar tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TaskScreen extends StatefulWidget {
  final Map<String, dynamic>? task;

  const TaskScreen({super.key, this.task});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!['titulo'];
      _descriptionController.text = widget.task!['descripcion'];
      _isCompleted = widget.task!['completada'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Agregar tarea' : 'Editar tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ingresa el título de la tarea',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ingresa la descripción de la tarea',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            CheckboxListTile(
              title: const Text('Completada'),
              value: _isCompleted,
              onChanged: (value) {
                setState(() {
                  _isCompleted = value ?? false;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('El título es obligatorio'),
                    ),
                  );
                } else {
                  Navigator.pop(context, {
                    'titulo': _titleController.text,
                    'descripcion': _descriptionController.text,
                    'completada': _isCompleted,
                  });
                }
              },
              child: Text(widget.task == null ? 'Guardar' : 'Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}