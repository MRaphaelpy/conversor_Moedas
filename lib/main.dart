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
  final realcontroler = TextEditingController();
  final dolarcontroler = TextEditingController();
  final eurocontroler = TextEditingController();
  dynamic dolar;
  dynamic euro;

  void _realchanged(String text) {
    if (text.isEmpty) {
      _clearall();
      return;
    }
    double real = double.parse(text);
    

    dolarcontroler.text = (real / dolar).toStringAsFixed(2);
    eurocontroler.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarchanged(String text) {
        if (text.isEmpty) {
      _clearall();
      return;
    }
    double dolar = double.parse(text);
    realcontroler.text = (dolar * this.dolar).toStringAsFixed(2);
    eurocontroler.text = (dolar * this.dolar / euro).toStringAsExponential(2);
  }

  void _eurochanged(String text) {
        if (text.isEmpty) {
      _clearall();
      return;
    }
    double euro = double.parse(text);
    realcontroler.text = (euro * this.euro).toStringAsExponential(2);
    dolarcontroler.text = (euro * this.euro / dolar).toStringAsExponential(2);
  }

  void _clearall() {
    realcontroler.text = "";
    eurocontroler.text = "";
    dolarcontroler.text = "";
  }

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
                        buildTextField(
                            "Reais", "R\$", realcontroler, _realchanged),
                        Divider(),
                        buildTextField(
                            "Dolares", "US", dolarcontroler, _dolarchanged),
                        Divider(),
                        buildTextField(
                            "Eurus", "€", eurocontroler, _eurochanged),
                      ],
                    ),
                  );
                }
            }
          }),
    );
  }
}

Widget buildTextField(String label, String prefix,
    TextEditingController allcontroler, dynamic value) {
  return TextField(
    controller: allcontroler,
    decoration: InputDecoration(
        labelText: "$label",
        labelStyle: TextStyle(color: Colors.amber, fontSize: 20),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: value,
    keyboardType: TextInputType.number,
  );
}
