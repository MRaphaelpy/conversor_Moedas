import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import "dart:convert";

var request =
    Uri.parse("https://api.hgbrasil.com/finance?format=json&key=1be0a910");

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
  ));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  print(json.decode(response.body));
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic dolar;
  dynamic euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text("\$ Conversor de Moedas \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando Dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro Ao carregar os Dados",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          Icons.monetization_on,
                          size: 150,
                          color: Colors.amber,
                        ),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Reais",
                              labelStyle:
                                  TextStyle(color: Colors.amber, fontSize: 20),
                              border: OutlineInputBorder(),
                              prefixText: "R\$"),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Dolar",
                              labelStyle:
                                  TextStyle(color: Colors.amber, fontSize: 20),
                              border: OutlineInputBorder(),
                              prefixText: "US\$"),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Euros",
                              labelStyle:
                                  TextStyle(color: Colors.amber, fontSize: 20),
                              border: OutlineInputBorder(),
                              prefixText: "€\$"),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}
