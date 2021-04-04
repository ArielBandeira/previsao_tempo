import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_weather_icons/flutter_weather_icons.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    title: "Previsão do Tempo",
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.amber, fontSize: 25.0)),
        inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white)))),
  ));
}

class Album {
  final int userId;
  final int id;
  final String title;

  Album({@required this.userId, @required this.id, @required this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _cidadeController = TextEditingController();

   String _infoText = "Informe seus dados!";

  void _clearAll() {
    _cidadeController.text = "";
  }

  Future fetchAlbum(String cidade) async {
    var city = cidade;
    //INSIRA SUA CHAVE
    final response = await http.get(Uri.https(
            'api.hgbrasil.com', '/weather', {"city_name": "$city", "key" : "CHAVE"}));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var res = jsonDecode(response.body);
      String text = "Temperatura: " + res["results"]["temp"].toString();
      setState(() {
        _infoText = text;        
      });
      return res;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    paint.color = Colors.white;
    return Scaffold(
        backgroundColor: Colors.blue.shade400,
        appBar: AppBar(
          title: Text("Previsão do Tempo"),
          centerTitle: true,
          backgroundColor: Colors.amber,
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed: _clearAll)
          ],
        ),
        body: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      WeatherIcons.wiDayCloudyWindy,
                      size: 150.0,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 100),
                    TextFormField(
                      controller: _cidadeController,
                      decoration: InputDecoration(
                        labelText: "Cidade",
                        labelStyle: TextStyle(
                            color: Colors.amber, background: paint),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Cidade,UF',
                      ),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    TextButton(
                        onPressed: () {
                          fetchAlbum(_cidadeController.text);
                        },
                        child: Text("Pesquisar", style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)
                        ),
                    ),
                    Text(
                      "$_infoText",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Colors.purple, fontSize: 25.0),
                    )
                  ],
                ))
    );
  }
}