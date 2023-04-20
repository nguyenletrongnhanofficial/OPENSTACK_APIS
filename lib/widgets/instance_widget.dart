import 'package:flutter/material.dart';

class InstanceWidget extends StatefulWidget {
  final String Token;
  const InstanceWidget({Key? key, required this.Token}) : super(key: key);

  @override
  _InstanceWidgetState createState() => _InstanceWidgetState();
}

class _InstanceWidgetState extends State<InstanceWidget> {
  List<String> images = const ['CentOS 9 Stream', 'Windows 10', 'Windows 11'];
  List<String> flavors = const ['tiny.1', 'tiny.2', 'tiny.3'];
  List<String> securityGroups = const ['group1', 'group2', 'group3'];

  String? selectedImage;
  String? selectedFlavor;
  String? selectedSecurityGroup;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController portIdController = TextEditingController();
  final TextEditingController customScriptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create InstanceWidget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Select Image:'),
            DropdownButton<String>(
              value: selectedImage,
              onChanged: (String? value) {
                setState(() {
                  selectedImage = value;
                });
              },
              items: images.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            const Text('Select Flavor:'),
            DropdownButton<String>(
              value: selectedFlavor,
              onChanged: (String? value) {
                setState(() {
                  selectedFlavor = value;
                });
              },
              items: flavors.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            const Text('Select Security Group:'),
            DropdownButton<String>(
              value: selectedSecurityGroup,
              onChanged: (String? value) {
                setState(() {
                  selectedSecurityGroup = value;
                });
              },
              items:
                  securityGroups.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: portIdController,
              decoration: const InputDecoration(labelText: 'Port ID'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: customScriptController,
              decoration: const InputDecoration(labelText: 'Custom Script'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Handle the create button press
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
