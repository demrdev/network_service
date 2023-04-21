import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../services/network_service.dart';

class TodoList extends StatelessWidget {
  final networkService = NetworkService.getInstance();

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await networkService.dio.get('/todos');
      if (response.statusCode == 200) {
        List<Todo> todos = (response.data as List).map((todoJson) => Todo.fromJson(todoJson)).toList();
        return todos;
      } else {
        throw Exception('Error fetching todos: ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _showTodoDetails(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(todo.title),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ID: ${todo.id}'),
            Text('User ID: ${todo.userId}'),
            Text('Completed: ${todo.completed}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: FutureBuilder<List<Todo>>(
        future: fetchTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final todos = snapshot.data!;
            return ListView.builder(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text('Completed: ${todo.completed}'),
                  onTap: () => _showTodoDetails(context, todo),
                );
              },
            );
          }
        },
      ),
    );
  }
}