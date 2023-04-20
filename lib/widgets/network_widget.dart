import 'package:flutter/material.dart';

class NetworkWidget extends StatefulWidget {
  const NetworkWidget({Key? key}) : super(key: key);

  @override
  _NetworkWidgetState createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget> {
  late TextEditingController _networkNameController;
  late TextEditingController _subnetNameController;
  late TextEditingController _networkAddressController;
  late TextEditingController _staticIpController;

  @override
  void initState() {
    super.initState();
    _networkNameController = TextEditingController();
    _subnetNameController = TextEditingController();
    _networkAddressController = TextEditingController();
    _staticIpController = TextEditingController();
  }

  @override
  void dispose() {
    _networkNameController.dispose();
    _subnetNameController.dispose();
    _networkAddressController.dispose();
    _staticIpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NetworkWidget'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _networkNameController,
              decoration: InputDecoration(
                labelText: 'NetworkWidget name',
              ),
            ),
            TextField(
              controller: _subnetNameController,
              decoration: InputDecoration(
                labelText: 'Subnet name',
              ),
            ),
            TextField(
              controller: _networkAddressController,
              decoration: InputDecoration(
                labelText: 'NetworkWidget address',
              ),
            ),
            TextField(
              controller: _staticIpController,
              decoration: InputDecoration(
                labelText: 'Static IP',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement button action
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
