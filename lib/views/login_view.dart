import 'package:flutter/material.dart';
import 'package:wire_app2/api.dart';
import 'package:wire_app2/views/register_view.dart';

import '../main.dart';
import '../models/login_model.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String _email = "";
    String _password = "";
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap:
                true, // ListView'in boyutunu içeriği kadar olacak şekilde ayarladık
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: Center(
                  child: Text("Login",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 25,
                          fontWeight: FontWeight.w300)),
                ),
              ),
              Container(
                  child: Image.asset("assets/undraw_electric_car_b7hl.png")),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 10,
                    bottom: MediaQuery.of(context).size.height / 20),
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent),
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextField(
                    controller: _emailController,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.orange,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.orange)),
                        hintText: 'E-mail',
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        prefixIcon: Icon(Icons.person, color: Colors.grey)),
                    onChanged: (value) {
                      setState(() {
                        _email = _emailController.text.trim();
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 15),
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.transparent),
                  height: MediaQuery.of(context).size.height / 15,
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    cursorColor: Colors.orange,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(20)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.orange)),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                            fontFamily: "Poppins",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0),
                        prefixIcon: Icon(Icons.lock, color: Colors.grey)),
                    onChanged: (value) {
                      setState(() {
                        _password = _passwordController.text;
                      });
                    },
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    UserLoginRequest request = UserLoginRequest(
                        email: _emailController.text.trim(),
                        password: _passwordController.text);
                    var response = await Api.loginCall(loginRequest: request);
                    if (response != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login successful!')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Login failed.')),
                      );
                    }
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height / 22,
                  width: MediaQuery.of(context).size.width / 2.8,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                    child: Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  child: Center(
                    child: Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.orange, fontSize: 15),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
