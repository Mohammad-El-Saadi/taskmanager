import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:taskmanager/login.dart';
import 'dart:convert' as convert;
import 'task.dart';
import 'showtask.dart';


class taskmanager extends StatefulWidget {
  String email;

  taskmanager({required this.email});

  @override
  State<taskmanager> createState() => _taskmanagerState();
}

class _taskmanagerState extends State<taskmanager> {
  String task_name = "";
  void initState() {
    super.initState();
    loadtasks();
  }

  void loadtasks() async {
    var url = "https://mohammadelsaadi.000webhostapp.com/api/select_tasks.php";
    var response = await post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'email': widget.email,
        }));

    if (response.statusCode == 200) {
      e.clear();
      setState(() {
        String data = response.body;
        for (var row in convert.jsonDecode(data)) {
          var p = Task((widget.email), (row["task_name"]), (row["description"]),
              (row["due_date"]));
          e.add(p);
        }
      });
    }
  }

  Future<void> addTask() async {
    final taskNameController = TextEditingController();
    final due_dateController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskNameController,
                decoration: InputDecoration(labelText: 'task Name'),
              ),
              TextField(
                controller: descController,
                decoration: InputDecoration(labelText: 'Description'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: due_dateController,
                decoration: InputDecoration(labelText: 'due date'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final task_name = taskNameController.text;
                final description = descController.text;
                final due_date = due_dateController.text;

                var url =
                    "https://mohammadelsaadi.000webhostapp.com/api/insert_task.php";

                final response = await post(Uri.parse(url),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: convert.jsonEncode(
                      <String, String>{
                        'task_name': task_name,
                        'description': description,
                        'due_date': due_date,
                        'email': widget.email,
                      },
                    ));

                if (response.statusCode == 200) {
                  var jsonResponse = convert.jsonDecode(response.body);
                  if (jsonResponse['task'] == true) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Task already exists. Please enter another task.'),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  } else {
                    loadtasks();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Task added succssessfully.'),
                        duration: Duration(seconds: 5),
                      ),
                    );
                  }
                }
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void delete() async {
    var url = "https://mohammadelsaadi.000webhostapp.com/api/delete.php";
    var response = await post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'email': widget.email,
          'task_name': task_name,
        }));

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['delete'] == true) {
        loadtasks();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Deleted succssessfully'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Task Manager"),
          centerTitle: true,
          leading: Container(),
          actions: [
            ElevatedButton.icon(
              onPressed: () {
                 Navigator.push( context, MaterialPageRoute(builder: (context) => login()),);
              },
              icon: Icon(Icons.logout),
              label: Text(""),
            ),
            ElevatedButton.icon(
              onPressed: () {
                loadtasks();
              },
              icon: Icon(Icons.refresh),
              label: Text(""),
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: e.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => showtask(),
                      settings: RouteSettings(arguments: e[index]),
                    ));
                  },
                  child: Card(
                    child: ListTile(
                        title: Text("${e[index].name}"),
                        subtitle: Text("${e[index].dueDate}"),
                        trailing: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                task_name = e[index].name;
                              });
                              delete();
                            },
                            icon: Icon(Icons.delete),
                            label: Text("Delete"))),
                  ));
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTask();
          },
          child: Icon(Icons.add),
        ));
  }
}
