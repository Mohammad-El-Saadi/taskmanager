import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:taskmanager/TaskManager.dart';
import 'dart:convert' as convert;

import 'package:taskmanager/register.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController _emial = TextEditingController();
  TextEditingController _password = TextEditingController();
  GlobalKey<FormState> _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        centerTitle: true,
        leading: Container(),
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
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 
                  ElevatedButton(
                      onPressed: () async {
                        if (_globalKey.currentState!.validate()) {
                          
                          var email = _emial.text;
                          var password = _password.text;
                        

                          var url =
                              "https://mohammadelsaadi.000webhostapp.com/api/login.php";
                          var response = await post(Uri.parse(url),
                              headers: <String, String>{
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                              },
                              body: convert.jsonEncode(<String, String>{
                               
                                'email': '$email',
                                'password': '$password',
                              }));
                          if (response.statusCode == 200) {
                            var jsonResponse =
                                convert.jsonDecode(response.body);
                            if (jsonResponse['password'] == false) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Password or email is invalid'),
                                    content:
                                        Text('Please try again.'),
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
                               Navigator.push(context, MaterialPageRoute(builder: (context) => taskmanager(email: email)),);
                            }
                          }
                        }
                      },
                      child: Text("login"))
                ],
              ),
              SizedBox(height: 10,),
              Text("Didn't have an account?",style: TextStyle(fontSize: 16,color: Colors.red),),
              SizedBox(height: 10,),
               ElevatedButton(onPressed: (){
                    Navigator.push( context, MaterialPageRoute(builder: (context) => Register()),);
                  }, child: Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: login(),
  ));
}
