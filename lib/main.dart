import 'package:flutter/material.dart';

void main() => runApp(const TaskManagerApp());

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

enum TaskStatus { pending, done }

class Task {
  Task({required this.title, required this.description});

  final String title;
  final String description;
  TaskStatus status = TaskStatus.pending;
}

enum TaskFilter { all, pending, done }

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  List<Task> get _visibleTasks {
    switch (_filter) {
      case TaskFilter.pending:
        return _tasks.where((t) => t.status == TaskStatus.pending).toList();
      case TaskFilter.done:
        return _tasks.where((t) => t.status == TaskStatus.done).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova tarefa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Título'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );

    if (result != true) return;

    final title = titleController.text.trim();
    final description = descriptionController.text.trim();

    if (title.isEmpty || description.isEmpty) {
      _showMessage('Preencha o título e a descrição para adicionar a tarefa.');
      return;
    }

    setState(() {
      _tasks.add(Task(title: title, description: description));
    });
  }

  void _toggleStatus(Task task) {
    setState(() {
      task.status =
          task.status == TaskStatus.pending ? TaskStatus.done : TaskStatus.pending;
    });
  }

  Future<void> _confirmDelete(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir tarefa'),
        content: Text('Deseja excluir "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _tasks.remove(task));
      _showMessage('Tarefa excluída.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _tasks.where((t) => t.status == TaskStatus.pending).length;
    final doneCount = _tasks.length - pendingCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Pendentes: $pendingCount  •  Concluídas: $doneCount'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: SegmentedButton<TaskFilter>(
              segments: const [
                ButtonSegment(value: TaskFilter.all, label: Text('Todas')),
                ButtonSegment(value: TaskFilter.pending, label: Text('Pendentes')),
                ButtonSegment(value: TaskFilter.done, label: Text('Concluídas')),
              ],
              selected: {_filter},
              onSelectionChanged: (selection) =>
                  setState(() => _filter = selection.first),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _visibleTasks.isEmpty
                ? const Center(child: Text('Nenhuma tarefa por aqui.'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _visibleTasks.length,
                    itemBuilder: (context, index) {
                      final task = _visibleTasks[index];
                      final isDone = task.status == TaskStatus.done;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        child: ListTile(
                          leading: Checkbox(
                            value: isDone,
                            onChanged: (_) => _toggleStatus(task),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              decoration:
                                  isDone ? TextDecoration.lineThrough : null,
                              color: isDone ? Colors.grey : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            task.description,
                            style: TextStyle(
                              decoration:
                                  isDone ? TextDecoration.lineThrough : null,
                              color: isDone ? Colors.grey : null,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _confirmDelete(task),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('Nova tarefa'),
      ),
    );
  }
}
