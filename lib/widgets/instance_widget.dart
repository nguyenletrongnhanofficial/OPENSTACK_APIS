import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openstack_apis/config/config.dart';
import 'package:provider/provider.dart';
import '/providers/list_image_provider.dart';
import '/providers/list_flavor_provider.dart';
import '/providers/list_security_group_provider.dart';
import '/widgets/network_widget.dart';

class InstanceWidget extends StatefulWidget {
  final String Token;
  final String? portID;

  const InstanceWidget({Key? key, required this.Token, this.portID})
      : super(key: key);

  @override
  _InstanceWidgetState createState() => _InstanceWidgetState();
}

class _InstanceWidgetState extends State<InstanceWidget> {
  List<String> images = [];
  List<String> flavors = [];
  List<String> securityGroups = [];

  String? selectedImage;
  String? selectedFlavor;
  String? selectedSecurityGroup;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController portIdController = TextEditingController();
  final TextEditingController customScriptController = TextEditingController();

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    portIdController.text = widget.portID.toString();

    reloadData();
  }

  void reloadData() async {
    List<String> tempImages = [];
    List<String> tempFlavors = [];
    List<String> tempSecurityGroups = [];

    await Future.wait([
      Provider.of<ListImageProvider>(context, listen: false)
          .getAllListImage(widget.Token),
      Provider.of<ListFlavorProvider>(context, listen: false)
          .getAllListFlavor(widget.Token),
      Provider.of<ListSecurityGroupProvider>(context, listen: false)
          .getAllListSecurityGroup(widget.Token),
    ]);

    tempImages = Provider.of<ListImageProvider>(context, listen: false)
        .listImage
        .map((listImage) => listImage.name)
        .toList();
    tempFlavors = Provider.of<ListFlavorProvider>(context, listen: false)
        .listFlavor
        .map((listFlavor) => listFlavor.name)
        .toList();
    tempSecurityGroups =
        Provider.of<ListSecurityGroupProvider>(context, listen: false)
            .listSecurityGroup
            .map((listSecurityGroup) => listSecurityGroup.name)
            .toList();

    setState(() {
      images = tempImages;
      flavors = tempFlavors;
      securityGroups = tempSecurityGroups;
    });
  }

  late Map<String, dynamic> instanceData;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    instanceData = {
      "server": {
        "name": "gr3",
        "imageRef": "819dc436-a8e1-4b08-8576-91ad1fc9292f",
        "flavorRef": "02-02-45",
        "security_groups": [
          {"name": selectedSecurityGroup.toString()}
        ],
        "networks": [
          {
            "uuid": "2c05dss9-1dd6-4xa3-a0fb-e8c4b43689cc",
            "port": portIdController.text
          }
        ],
        "user_data": "ddb9ba93-7f29-4bd5-b3f0-182688f28560"
      }
    };
  }

  Future<void> addInstance() async {
    try {
      print("đã tới");
      var response = await dio.post(
        "$baseUrl/v2.1/servers",
        data: instanceData,
        options: Options(
          headers: {
            "Content-type": "application/json",
            "X-Auth-Token": widget.Token
          },
        ),
      );
      print(response);

      if (response.statusCode == 202) {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Tạo Instance thành công',
            message: 'Chúc mừng bạn đã tạo Instance thành công',
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
          title: 'Tạo Instance thất bại!!!',
          message: 'Vui lòng thử lại!!',
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create InstanceWidget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Bên dưới là các tùy chọn được lấy từ hệ thống!"),
            Container(
              height: 10,
            ),
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
              decoration: const InputDecoration(
                  labelText: 'Port ID - Được nhập tự động bởi ứng dụng 😇'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: customScriptController,
              decoration: const InputDecoration(labelText: 'Custom Script'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                didChangeDependencies();
                addInstance();
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
