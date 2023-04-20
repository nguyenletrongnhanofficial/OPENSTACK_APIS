import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import '/widgets/instance_widget.dart';
import '/widgets/network_widget.dart';

class HomePage extends StatefulWidget {
  final String Token;
  const HomePage({Key? key, required this.Token}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Token app vừa nhận được là: "),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(widget.Token),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NetworkWidget(),
                  ),
                );
              },
              child: Text('Đi tới trang tạo Network'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstanceWidget(
                      Token: widget.Token,
                    ),
                  ),
                );
              },
              child: Text('Đi tới trang tạo Instance'),
            ),
          ],
        ),
      ),
    );
  }
}
