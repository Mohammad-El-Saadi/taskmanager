import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'package:taskmanager/task.dart';
import 'package:intl/intl.dart';

class showtask extends StatefulWidget {
  @override
  State<showtask> createState() => _showtaskState();
}

class _showtaskState extends State<showtask> {
  String message =
      "Please press the remaining time button to see the remaing time";

  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();

  void calc(int remainingHour, int remainingDays) {
    if (remainingHour > 0 || remainingDays > 0) {
      setState(() {
        message =
            "You still have $remainingDays Days and $remainingHour Hour to finish the task";
      });
    } else {
      setState(() {
        message = "You missed the due date!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Task showed = ModalRoute.of(context)!.settings.arguments as Task;
    var email = showed.email;
    taskNameController.text = showed.name;
    descriptionController.text = showed.description;
    dueDateController.text = showed.dueDate;

    DateTime now = DateTime.now();
    String formattedDate = DateFormat('y-MM-dd').format(now);

    DateTime dueDate = DateFormat('y-MM-dd').parse(showed.dueDate);
    int remainingDays = dueDate.difference(now).inDays;
    int remainingHour = dueDate.difference(now).inHours;

  

    void openEditDialog() async{
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Task Name'),
                TextField(
                  controller: taskNameController,
                ),
                SizedBox(height: 10),
                Text('Description'),
                TextField(
                  controller: descriptionController,
                ),
                SizedBox(height: 10),
                Text('Due Date'),
                TextField(
                  controller: dueDateController,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () async{
                  String task_name = taskNameController.text;
                  String description = descriptionController.text;
                  String due_date = dueDateController.text;
                  String old_task_name = showed.name;

                  var url = "https://mohammadelsaadi.000webhostapp.com/api/update.php";
                          var response = await post(Uri.parse(url),
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: convert.jsonEncode(<String, String>{
                  'email': email,
                  'task_name': task_name,
                  'description':description,
                  'due_date': due_date,
                  'old_task_name': old_task_name,
                }));

                            if (response.statusCode == 200) {
                              var jsonResponse = convert.jsonDecode(response.body);
                              if (jsonResponse['update'] == true) {
                              showed.name = task_name;
                              showed.description = description;
                              showed.dueDate = due_date;

                            
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Changes saved!'),duration: Duration(seconds: 5),
                                ),
                                
                              );
                           Navigator.of(context).pushReplacement( MaterialPageRoute(
                           builder: (BuildContext context) => showtask(),
                          settings: RouteSettings(arguments: showed),
                          ),
                            );
                              
                              }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Task Name already in use!'),duration: Duration(seconds: 5),
                                ),
                              );

                              Navigator.of(context).pop(); 
                              }
                            }
                  // Close the dialog
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Task: ${showed.name}"),
        actions: [
          TextButton.icon(
            onPressed: () {
              calc(remainingHour, remainingDays);
            },
            icon: Icon(Icons.hourglass_full),
            label: Text("Remaining Time"),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              "Description:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(showed.description),
            SizedBox(height: 30),
            Text(
              "Due Date:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(showed.dueDate),
            SizedBox(height: 30),
            Text(
              message,
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openEditDialog();
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
