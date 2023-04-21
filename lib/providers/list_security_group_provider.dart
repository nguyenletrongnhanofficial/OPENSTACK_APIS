import 'dart:convert';
import 'package:flutter/foundation.dart';
import '/config/config.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '/models/list_security_group.dart';

class ListSecurityGroupProvider with ChangeNotifier {
  final _dio = Dio();
  List<ListSecurityGroup> _listSecurityGroup = [];

  List<ListSecurityGroup> get listSecurityGroup => _listSecurityGroup;

  Future<void> getAllListSecurityGroup(String Token) async {
    try {
      var options = Options(
        headers: {'Content-type': 'application/json', 'X-Auth-Token': Token},
      );
      var result =
          await _dio.get("$baseUrl/v2.0/security-groups", options: options);
      Map<String, dynamic> data = result.data as Map<String, dynamic>;

      List<dynamic> listSecurityGroupServer =
          data["security_groups"] as List<dynamic>;
      _listSecurityGroup.clear();

      for (int i = 0; i < listSecurityGroupServer.length; i++) {
        var name = listSecurityGroupServer[i]["name"];
        _listSecurityGroup.add(ListSecurityGroup.toListSecurityGroup(
            listSecurityGroupServer[i] as Map<String, dynamic>));
      }

      notifyListeners();
    } catch (e) {
      _listSecurityGroup = [];
      notifyListeners();
    }
  }
}
