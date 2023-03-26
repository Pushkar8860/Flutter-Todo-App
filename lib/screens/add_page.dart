import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key, Map? todo}) : super(key: key)

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage>  {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if(todo!=null){
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Todo': 'Add todo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.9),
        children:  [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: isEdit? updateData: SubmitData, child:  Text(isEdit ?'Update':'Submit'))
        ],
      ),
    );
  }
  Future<void> updateData()  async {
    final todo = widget.todo;
    if(todo == null)
      return;
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = 'http://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json'
    });

    if(response.statusCode == 200){
      showMessage("Updation Success", false);
      titleController.text='';
      descriptionController.text='';
    }else{
      showMessage('Updation failed', true);
    }
  }
  Future<void> SubmitData () async {
    final title = titleController.text;
    final description = descriptionController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    const url = 'http://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);

    final response = await http.post(uri, body: jsonEncode(body), headers: {
      'Content-Type': 'application/json'
    });
    if(response.statusCode == 201){
      print(response.body);
      showMessage("Creation Success", false);
      titleController.text='';
      descriptionController.text='';
    }else{
      print('error');
      showMessage('Creation failed', true);
    }
  }

  void showMessage(String message, bool type){
    final snackBar = SnackBar(content: Text(message),
    backgroundColor: type?Colors.red:Colors.green);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
