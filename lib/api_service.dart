import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';

class ApiService {
  static final String _apiUrl = dotenv.get('API_URL');

  // Obtener todas las tareas
  static Future<List<Map<String, dynamic>>> getTasks(BuildContext context) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.get(
      Uri.parse('$_apiUrl/api/tareas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar las tareas: ${response.statusCode}');
    }
  }

  // Obtener una tarea por ID
  static Future<Map<String, dynamic>> getTaskById(BuildContext context, int id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.get(
      Uri.parse('$_apiUrl/api/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al cargar la tarea: ${response.statusCode}');
    }
  }

  // Crear una nueva tarea
  static Future<Map<String, dynamic>> createTask(BuildContext context, Map<String, dynamic> task) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('$_apiUrl/api/tareas'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(task),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al crear la tarea: ${response.statusCode}');
    }
  }

  // Actualizar una tarea
  static Future<Map<String, dynamic>> updateTask(BuildContext context, int id, Map<String, dynamic> task) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.put(
      Uri.parse('$_apiUrl/api/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(task),
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la tarea: ${response.statusCode}');
    }
  }

  // Marcar una tarea como completada
  static Future<Map<String, dynamic>> toggleTaskCompletion(BuildContext context, int id, bool completed) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.patch(
      Uri.parse('$_apiUrl/api/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'completada': completed}),
    );
    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar la tarea: ${response.statusCode}');
    }
  }

  // Eliminar una tarea
  static Future<void> deleteTask(BuildContext context, int id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.delete(
      Uri.parse('$_apiUrl/api/tareas/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode != 204 && response.statusCode != 200) {
      throw Exception('Error al eliminar la tarea: ${response.statusCode}');
    }
  }
}