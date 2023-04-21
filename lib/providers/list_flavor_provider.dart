import 'dart:convert';
import 'package:flutter/foundation.dart';
import '/config/config.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '/models/list_flavor.dart';

class ListFlavorProvider with ChangeNotifier {
  final _dio = Dio();
  List<ListFlavor> _listFlavor = [];

  List<ListFlavor> get listFlavor => _listFlavor;

  Future<void> getAllListFlavor(String Token) async {
    try {
      var options = Options(
        headers: {'Content-type': 'application/json', 'X-Auth-Token': Token},
      );
      var result =
          await _dio.get("$baseUrl/v2.1/os-keypairs", options: options);
      List<dynamic> keypairs = result.data["keypairs"] as List<dynamic>;
      _listFlavor.clear();
      for (int i = 0; i < keypairs.length; i++) {
        var name = keypairs[i]["keypair"]["name"];

        _listFlavor.add(ListFlavor.toListFlavor(
            keypairs[i]["keypair"] as Map<String, dynamic>));
      }
      notifyListeners();
    } catch (e) {
      _listFlavor = [];
      notifyListeners();
    }
  }
}
