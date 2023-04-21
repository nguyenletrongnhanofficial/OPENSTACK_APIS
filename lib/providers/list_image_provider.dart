import 'dart:convert';
import 'package:flutter/foundation.dart';
import '/config/config.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '/models/list_image.dart';

class ListImageProvider with ChangeNotifier {
  final _dio = Dio();
  List<ListImage> _listImage = [];

  List<ListImage> get listImage => _listImage;

  Future<void> getAllListImage(String Token) async {
    try {
      var options = Options(
        headers: {'Content-type': 'application/json', 'X-Auth-Token': Token},
      );
      var result = await _dio.get("$baseUrl/v2/images", options: options);
      Map<String, dynamic> data = result.data as Map<String, dynamic>;
      List<dynamic> listImageServer = data["images"] as List<dynamic>;
      _listImage.clear();
      for (int i = 0; i < listImageServer.length; i++) {
        var name = listImageServer[i]["name"];
        _listImage.add(
            ListImage.toListImage(listImageServer[i] as Map<String, dynamic>));
      }

      notifyListeners();
    } catch (e) {
      _listImage = [];
      notifyListeners();
    }
  }
}
