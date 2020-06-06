import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//antes de importar esse pacote abaixo, inserir linha 26 no arquivo pubspec.yaml
//http: ^0.12.0+2
import 'package:http/http.dart' as http;
//para transformar os dados em json
import 'dart:convert';
import 'dart:async';

//Voce pode gerar chave se cadastrando no site https://hgbrasil.com/status/finance/
const key = "";
const request ="https://api.hgbrasil.com/finance?format=json&key="+key;

void main() async{
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
      hintColor: Colors.amber,
      primaryColor: Colors.white
    ),
  ));

  }

//Função que retorna um dado futuro
Future<Map> getData() async{
  http.Response response  = await http.get(request);
  return json.decode(response.body);
}

  class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
  }



  class _HomeState extends State<Home> {
  //controladores para coletar os textos digitados nos campos
    final realController= TextEditingController();
    final dolarController= TextEditingController();
    final euroController= TextEditingController();


    void _clearAll(){
      realController.text = "";
      dolarController.text = "";
      euroController.text = "";
    }
   //funções que serão chamadoas ao alterar os valores dos campos

   void _realChanged(String text){
     if(text.isEmpty) {
       _clearAll();
       return;
     }
     double real = double.parse(text);
     dolarController.text = (real/dolar).toStringAsFixed(2);
     euroController.text = (real/euro).toStringAsFixed(2);



   }
    void _dolarChanged(String text){
      if(text.isEmpty) {
        _clearAll();
        return;
      }
      double dolar = double.parse(text);
      realController.text = (dolar*this.dolar).toStringAsFixed(2);
      euroController.text = (dolar*this.dolar/euro).toStringAsFixed(2);
    }
    void _euroChanged(String text){
      if(text.isEmpty) {
        _clearAll();
        return;
      }
      double euro = double.parse(text);
      realController.text = (euro * this.euro).toStringAsFixed(2);
      dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);

    }



  double dolar;
  double euro;

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (contex, snapshot){
              //informando estado da requisição
              switch(snapshot.connectionState){
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                    child: Text("Carregando Dados...",
                    style: TextStyle(
                        color: Colors.amber,
                    fontSize: 25.0),
                    textAlign: TextAlign.center,)
                    );
                  default:
                    if(snapshot.hasError){
                      return Center(
                          child: Text("Erro ao Dados..." + snapshot.data.toString(),
                            style: TextStyle(
                                color: Colors.amber,
                                fontSize: 25.0),
                            textAlign: TextAlign.center,)
                      );
                    }else{
                      //obtendo valores
                      dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                      euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];


                      return SingleChildScrollView(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on, size: 150.0, color: Colors.amber),
                          buildTextField("Reais", "R\$ ", realController,_realChanged ),
                          Divider(),
                          buildTextField("Dolares", "US\$ ",dolarController, _dolarChanged),
                          Divider(),
                          buildTextField("Euros", "€ ",euroController,_euroChanged),

                        ],
                        ),
                      );
                    }
             }

            }),
      );
    }
  }

  //construir as caixas de texto

Widget buildTextField(String label, String prefix, TextEditingController c, Function f){
  return TextField(
    controller: c ,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
        color: Colors.amber,
        fontSize: 25.0
    ),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
    //keyboardType: TextInputType.number,

  );

}






