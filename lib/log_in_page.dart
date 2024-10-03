import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_activity.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  Color color = Color(0xff040542);

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('email');
    String? password = prefs.getString('password');

    if (username == emailController.text &&
        password == passwordController.text) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool('log_in', true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainActivity()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid credentials.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: Colors.grey[400],
        title: Text(
          'Login',
          style: TextStyle(
            color: color,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
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
            top: 150,
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
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: login,
                      child: Text('Login'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: color,
                        backgroundColor: Colors.grey[300],
                        elevation: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/signup');
                      },
                      child: Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(color: color),
                      ),
                    ),
                  ],
                ),
              ),


            ),
          ),
        ],
      ),
    );
  }
}
