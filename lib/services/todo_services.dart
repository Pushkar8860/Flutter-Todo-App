import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  static Future<List?> fetchTodo() async {
    const url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    }
    else {
      return null;
    }
  }

  static Future<bool> addTodo(Map data) async{
    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json'
    });
    return response.statusCode == 201;
  }

  static Future<bool> updateTodo(String id, Map data) async{
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.put(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json'
    });
    return response.statusCode == 200;
  }

  static Future<bool> deleteById(id) async {
    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

}