import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;
import 'TaskManager.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _name = TextEditingController();
  TextEditingController _emial = TextEditingController();
  TextEditingController _password = TextEditingController();
  String? selectedGender;
  GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _globalKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 500,
                child: TextFormField(
                  controller: _name,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Your Name"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 500,
                child: TextFormField(
                  controller: _emial,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Your email"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 500,
                child: TextFormField(
                  controller: _password,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Your password"),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 500,
                child: RadioListTile<String>(
                  title: Text('Male'),
                  value: 'Male',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 500,
                child: RadioListTile<String>(
                  title: Text('Female'),
                  value: 'Female',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          var name = _name.text;
                          var email = _emial.text;
                          var password = _password.text;
                          var gender = selectedGender;

                          var url =
                              "https://mohammadelsaadi.000webhostapp.com/api/register.php";
                          var response = await post(Uri.parse(url),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: convert.jsonEncode(<String, String>{
                                'name': '$name',
                                'email': '$email',
                                'password': '$password',
                                'gender': '$gender'
                              }));
                          if (response.statusCode == 200) {
                            var jsonResponse =
                                convert.jsonDecode(response.body);
                            if (jsonResponse['email'] == true) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Email already exists'),
                                    content:
                                        Text('Please enter a different email.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                               Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => taskmanager(email: email)),
);
                            }
                          }
                        }
                      },
                      child: Text("Register"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Register(),
  ));
}
