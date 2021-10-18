import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';

var request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json&key=1be0a910");

void main() async {
  http.Response response = await http.get(request);
  print(response.body);

  runApp(MaterialApp(home: Container()));
}
