import 'package:flutter/material.dart';
import 'package:quranconnect/services/database_helper.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrasi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _passwordConfirmController,
              decoration: InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;
                String confirmPassword = _passwordConfirmController.text;

                if (password != confirmPassword) {
                  setState(() {
                    _errorMessage = "Password tidak cocok";
                  });
                  return;
                }

                try {
                  await DatabaseHelper().registerUser(username, password);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registrasi berhasil')),
                  );
                  Navigator.pushReplacementNamed(context, '/login');
                } catch (e) {
                  setState(() {
                    _errorMessage = "Username sudah terdaftar";
                  });
                }
              },
              child: Text('Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
