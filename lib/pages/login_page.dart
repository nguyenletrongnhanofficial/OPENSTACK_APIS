import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../config/config.dart';
import '/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dio = Dio();
  late Map<String, dynamic> loginData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginData = {
      "auth": {
        "identity": {
          "methods": ["password"],
          "password": {
            "user": {
              "name": _usernameController.text.trim(),
              "domain": {"name": "Default"},
              "password": _passwordController.text.trim(),
            }
          }
        }
      }
    };
  }

  Future<void> LoginToken() async {
    try {
      var response = await dio.post("$baseUrl/v3/auth/tokens", data: loginData);

      if (response.statusCode == 201) {
        var xSubjectToken = response.headers.value('x-subject-token');
        print(xSubjectToken);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              Token: xSubjectToken.toString(),
            ),
          ),
        );

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Đăng nhập thành công',
            message: 'Chúc mừng bạn đã đăng nhập thành công',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Đăng nhập thất bại',
          message: 'Vui lòng kiểm tra lại Username hoặc Passwork nhen',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                didChangeDependencies();
                LoginToken();
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
