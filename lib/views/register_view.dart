import 'package:flutter/material.dart';
import 'package:wire_app2/api.dart';

import '../main.dart';
import '../models/register_model.dart';
import 'login_view.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 1),
                  child: Text("Register",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 25,
                          fontWeight: FontWeight.w300)),
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 3.8,
                    child: Image.asset("assets/undraw_electricity_k2ft.png")),
                getTextField("Email", Icons.email, _emailController),
                getTextField("Username", Icons.person, _usernameController),
                getTextField("Password", Icons.lock, _passwordController,
                    isPassword: true),
                getTextField(
                    "First Name", Icons.account_circle, _firstNameController),
                getTextField("Last Name", Icons.account_circle_outlined,
                    _lastNameController),
                getTextField("Phone", Icons.phone, _phoneController),
                GestureDetector(
                  onTap: () async {
                    if (_validateForm()) {
                      UserRegisterRequest request = UserRegisterRequest(
                        email: _emailController.text,
                        username: _usernameController.text,
                        password: _passwordController.text,
                        firstName: _firstNameController.text,
                        lastName: _lastNameController.text,
                        phone: _phoneController.text,
                      );
                      var response =
                          await Api.registerCall(registerRequest: request);
                      if (response != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration successful!')),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Registration failed.')),
                        );
                      }
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 22,
                      width: MediaQuery.of(context).size.width / 2.8,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 22,
                      width: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  bool _validateForm() {
    if (_emailController.text.isEmpty) {
      return false;
    }
    if (_usernameController.text.isEmpty) {
      return false;
    }
    if (_passwordController.text.isEmpty) {
      return false;
    }
    if (_firstNameController.text.isEmpty) {
      
      return false;
    }
    if (_lastNameController.text.isEmpty) {
    
      return false;
    }
    if (_phoneController.text.isEmpty) {
    
      return false;
    }
    return true;
  }

  Widget getTextField(
      String hint, IconData icon, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 17.0),
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
      ),
    );
  }
}
