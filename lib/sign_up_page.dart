import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Color color = Color(0xff040542);

  Future<void> signUp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', emailController.text);
    await prefs.setString('password', passwordController.text);
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sign Up'),
        foregroundColor: color,
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            bottom: 350,
            child: Container(
              width: 500,
              height: 180,
              decoration: BoxDecoration(
                color: Color(0xff040542),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(200),
                  bottomRight: Radius.circular(200),
                ),
              ),
            ),
          ),
          Positioned(
            left: 50,
            right: 50,
            top: 150,            child: Container(
              child: Container(
                height: 450,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(4, 4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: color),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color),
                              borderRadius: BorderRadius.circular(25)
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: color),
                        ),
                      ),
                      SizedBox(height: 20,),
                      ElevatedButton(
                        onPressed: signUp,
                        child: Text('Sign Up'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: color,
                          backgroundColor: Colors.grey[300],
                          elevation: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
