import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import "dart:convert";
import 'home.dart';


var request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json&key=1be0a910");

void main() async {
  runApp(MaterialApp(home: Home(),
  )
  );
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}
