import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_page.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {

  bool isLoading = false;
  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
      ),
      body:Visibility(
        visible: isLoading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
          itemCount: items.length, itemBuilder: (context, index){
           final item = items[index];
           final id = item['_id'];
           return ListTile(
             leading: CircleAvatar(child: Text('${index +1}'),),
             title: Text(item['title']),
             subtitle: Text(item['description']),
             trailing: PopupMenuButton(
               onSelected: (value){
                 if(value =='edit'){
                  navigateToEditPage(item);
                 }else if(value =='delete'){
                   deleteById(id);
                 }
               },
               itemBuilder: (context){
                 return [
                   PopupMenuItem(child: Text('Edit'), value: 'edit'),
                   PopupMenuItem(child: Text('Delete'), value: 'delete',),
                 ];
               }
             ),
           );
        }),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: const Text('Add Todo'),
      ),
    );
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
        builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }
  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
        builder: (context) => const AddTodoPage(todo: item));
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }


  Future<void> fetchTodo() async {

    setState(() {
      isLoading = true;
    });
    final url = 'http://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
      setState(() {
      isLoading = false;
      });
    }
  }

  Future<void> deleteById(id) async {

    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if(response.statusCode == 200){
      showMessage('Deletion Success', false);
    final filtered =  items.where((element) => element['_id'] != id).toList();
    setState(() {
      items = filtered;
    });
    }else{
      showMessage('Deletion failed', true);
    }
  }

  void showMessage(String message, bool type){
    final snackBar = SnackBar(content: Text(message),
        backgroundColor: type?Colors.red:Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
