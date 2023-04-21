import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../config/config.dart';

class NetworkWidget extends StatefulWidget {
  final String Token;
  const NetworkWidget({Key? key, required this.Token}) : super(key: key);

  @override
  _NetworkWidgetState createState() => _NetworkWidgetState();
}

class _NetworkWidgetState extends State<NetworkWidget> {
  late TextEditingController _networkNameController;
  late TextEditingController _subnetNameController;
  late TextEditingController _networkAddressController;
  late TextEditingController _staticIpController;
  final dio = Dio();

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

  late Map<String, dynamic> networkData;
  late Map<String, dynamic> subnetkData;
  late String networkIdData = "";
  late String subnetIdData = "";
  late String networkIdDatanew = "";
  late String portIdData = "";
  late Map<String, dynamic> portData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    networkData = {
      "network": {"name": _networkNameController.text, "admin_state_up": true}
    };
    subnetkData = {
      "subnets": [
        {
          "name": _subnetNameController.text,
          "cidr": _networkAddressController.text,
          "ip_version": 4,
          "network_id": networkIdData
        }
      ]
    };
    portData = {
      "port": {
        "admin_state_up": true,
        "port_security_enabled": false,
        "security_groups": null,
        "network_id": networkIdDatanew,
        "fixed_ips": [
          {"ip_address": "192.168.11.11", "subnet_id": subnetIdData}
        ]
      }
    };
  }

  Future<void> addNetwork() async {
    try {
      var response = await dio.post(
        "$baseUrl/v2.0/networks",
        data: networkData,
        options: Options(
          headers: {
            "Content-type": "application/json",
            "X-Auth-Token": widget.Token
          },
        ),
      );

      if (response.statusCode == 201) {
        String networkId = response.data["network"]["id"];
        networkIdData = networkId;
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Network đã được tạo',
            message: 'Chúc mừng bạn đã tạo network thành công',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

        try {
          var response = await dio.post(
            "$baseUrl/v2.0/subnets",
            data: subnetkData,
            options: Options(
              headers: {
                "Content-type": "application/json",
                "X-Auth-Token": widget.Token
              },
            ),
          );
          if (response.statusCode == 201) {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Subnet đã được tạo',
                message: 'Chúc mừng bạn đã tạo Subnet thành công',
                contentType: ContentType.success,
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
            String subnetId = response.data['subnets'][0]['id'];
            String networkIdnew = response.data['subnets'][0]['network_id'];
            subnetIdData = subnetId;
            networkIdDatanew = networkIdnew;
            print("NetworkID: " + networkIdDatanew);
            print("SubnetID: " + subnetIdData);

            try {
              var response = await dio.post(
                "$baseUrl/v2.0/ports",
                data: portData,
                options: Options(
                  headers: {
                    "Content-type": "application/json",
                    "X-Auth-Token": widget.Token
                  },
                ),
              );
              if (response.statusCode == 201) {
                String portId = response.data["port"]["id"];
                portIdData = portId;
                print("PostID: " + portIdData);

                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Hoàn tất',
                    message: 'Chúc mừng bạn đã hoàn tất tạo network',
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
                  title: 'Tạo network thất bại!!!',
                  message: 'Vui lòng kiểm tra lại nhen',
                  contentType: ContentType.failure,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);

              print(e);
            }
          }
        } catch (e) {
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Tạo network thất bại!!!',
              message: 'Vui lòng kiểm tra lại nhen',
              contentType: ContentType.failure,
            ),
          );

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          print(e);
        }
      }
    } catch (e) {
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Tạo network thất bại!!!',
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
                labelText: 'Network name',
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
                labelText: 'Network address',
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
                didChangeDependencies();
                addNetwork();
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
