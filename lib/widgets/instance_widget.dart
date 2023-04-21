import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:openstack_apis/config/config.dart';
import 'package:provider/provider.dart';
import '/providers/list_image_provider.dart';
import '/providers/list_flavor_provider.dart';
import '/providers/list_security_group_provider.dart';

class InstanceWidget extends StatefulWidget {
  final String Token;

  const InstanceWidget({
    Key? key,
    required this.Token,
  }) : super(key: key);

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

  // //
  // late Map<String, dynamic> networkData;
  // late Map<String, dynamic> subnetkData;
  // late String networkIdData = "";

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   networkData = {
  //     "network": {"name": _networkNameController.text, "admin_state_up": true}
  //   };
  //   subnetkData = {
  //     "subnets": [
  //       {
  //         "name": _subnetNameController.text,
  //         "cidr": _networkAddressController.text,
  //         "ip_version": 4,
  //         "network_id": networkIdData
  //       }
  //     ]
  //   };
  // }

  // Future<void> addNetwork() async {
  //   try {
  //     var response = await dio.post(
  //       "$baseUrl/v2.0/networks",
  //       data: networkData,
  //       options: Options(
  //         headers: {
  //           "Content-type": "application/json",
  //           "X-Auth-Token": widget.Token
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 201) {
  //       String networkId = response.data["network"]["id"];
  //       networkIdData = networkId;

  //       try {
  //         var response = await dio.post(
  //           "$baseUrl/v2.0/subnets",
  //           data: subnetkData,
  //           options: Options(
  //             headers: {
  //               "Content-type": "application/json",
  //               "X-Auth-Token": widget.Token
  //             },
  //           ),
  //         );
  //         if (response.statusCode == 201) {
  //           final snackBar = SnackBar(
  //             elevation: 0,
  //             behavior: SnackBarBehavior.floating,
  //             backgroundColor: Colors.transparent,
  //             content: AwesomeSnackbarContent(
  //               title: 'Thành công!!!',
  //               message: 'Chúc mừng bạn đã tạo network thành công',
  //               contentType: ContentType.success,
  //             ),
  //           );

  //           ScaffoldMessenger.of(context)
  //             ..hideCurrentSnackBar()
  //             ..showSnackBar(snackBar);
  //         }
  //       } catch (e) {
  //         final snackBar = SnackBar(
  //           elevation: 0,
  //           behavior: SnackBarBehavior.floating,
  //           backgroundColor: Colors.transparent,
  //           content: AwesomeSnackbarContent(
  //             title: 'Tạo network thất bại!!!',
  //             message: 'Vui lòng kiểm tra lại nhen',
  //             contentType: ContentType.failure,
  //           ),
  //         );

  //         ScaffoldMessenger.of(context)
  //           ..hideCurrentSnackBar()
  //           ..showSnackBar(snackBar);

  //         print(e);
  //       }
  //     }
  //   } catch (e) {
  //     final snackBar = SnackBar(
  //       elevation: 0,
  //       behavior: SnackBarBehavior.floating,
  //       backgroundColor: Colors.transparent,
  //       content: AwesomeSnackbarContent(
  //         title: 'Tạo network thất bại!!!',
  //         message: 'Vui lòng kiểm tra lại nhen',
  //         contentType: ContentType.failure,
  //       ),
  //     );

  //     ScaffoldMessenger.of(context)
  //       ..hideCurrentSnackBar()
  //       ..showSnackBar(snackBar);

  //     print(e);
  //   }
  // }

  //

  @override
  void initState() {
    super.initState();

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
