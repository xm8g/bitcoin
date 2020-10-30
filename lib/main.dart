import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(PrecoBitCoin());
}

class PrecoBitCoin extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _preco = '';

  Future<Map> buscaPreco() async {
    String url = 'https://blockchain.info/ticker';
    Response response = await http.get(url);
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('images/bitcoin.png'),
            Padding(
                padding: const EdgeInsets.only(top: 32),
                child: FutureBuilder(
                    future: buscaPreco(),
                    builder: (context, snapshot) {
                      String resultado;
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                          break;
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            resultado = "Erro ao carregar dados.";
                          } else {
                            resultado = snapshot.data["BRL"]["buy"].toString();
                          }
                      }
                      return Text("R\$ " + resultado,
                          style: TextStyle(fontSize: 36));
                    })),
            Padding(
              padding: const EdgeInsets.only(top: 64),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    color: Colors.amber,
                    child: Text(
                      'Atualizar',
                      style: TextStyle(fontSize: 32),
                    ),
                    textColor: Colors.white,
                    onPressed: () => buscaPreco()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
