import 'package:flutter/material.dart';
import 'package:mp5/Dbhelper/db_helper.dart';
import 'package:mp5/view/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final bool isDarkMode = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login/Register Screen',
      theme: ThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 4, 4, 4),
          ),
        ),
      ),
      home: LoginRegisterScreen(isDarkMode: isDarkMode),
    );
  }
}

class LoginRegisterScreen extends StatelessWidget {
  final bool isDarkMode;

  const LoginRegisterScreen({Key? key, required this.isDarkMode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginRegister'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/news_background.jpeg', // Replace with your image path
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 217, 217, 217)),
                      border: const OutlineInputBorder(),
                      errorText: usernameController.text.isEmpty
                          ? 'Please enter a username'
                          : null,
                      errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 67, 67)),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 241, 239, 239)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Color.fromARGB(255, 217, 217, 217)),
                      border: const OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 248, 245, 245)), // Set border color
                      ),
                      errorText: passwordController.text.isEmpty
                          ? 'Please enter a password'
                          : null,
                      errorStyle: const TextStyle(color: Color.fromARGB(255, 195, 67, 67)),
                    ),
                    style: const TextStyle(color: Color.fromARGB(255, 241, 238, 238)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _loginUser(
                          context, usernameController, passwordController);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Color.fromARGB(255, 230, 24, 24)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _registerUser(
                          context, usernameController, passwordController);
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Color.fromARGB(255, 230, 24, 24)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _loginUser(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController passwordController) async {
    String username = usernameController.text;
    String password = passwordController.text;
    DatabaseHelper dbHelper = DatabaseHelper();
    bool isLoggedIn = await dbHelper.loginUser(username, password);
    if (isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
          duration: Duration(seconds: 2),
        ),
      );

      // Navigate to the HomeScreen on successful login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false, // This prevents going back to the previous screens
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Failed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _registerUser(
      BuildContext context,
      TextEditingController usernameController,
      TextEditingController passwordController) async {
    String username = usernameController.text;
    String password = passwordController.text;
    DatabaseHelper dbHelper = DatabaseHelper();
    // Simulating user registration
    int result = await dbHelper.insertUser(username, password);
    if (result != -1 && username != '' && password != '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Failed'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
