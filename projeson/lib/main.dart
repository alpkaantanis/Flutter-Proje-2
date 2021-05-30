import 'package:flutter/material.dart';
import 'package:projeson/kelimeler.dart';
import 'package:projeson/kelimelerdao.dart';
import 'package:flip_card/flip_card.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Anasayfa(),
    );
  }
}
class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {

  bool aramaYapiliyorMu = false;
  String aramaKelimesi = "";

  Future<List<Kelimeler>> tumKelimelerGoster() async {
    var kelimelerListesi = await Kelimelerdao().tumKelimeler();
    return kelimelerListesi;
  }

  Future<List<Kelimeler>> aramaYap(String aramaKelimesi) async {
    var kelimelerListesi = await Kelimelerdao().kelimeAra(aramaKelimesi);
    return kelimelerListesi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: aramaYapiliyorMu ?
        TextField(
          decoration: InputDecoration(hintText: "Arama için birşey yazın"),
          onChanged: (aramaSonucu){
            print("Arama sonucu : $aramaSonucu");
            setState(() {
              aramaKelimesi = aramaSonucu;
            });
          },
        )
            : Text("Sözlük Uygulaması"),
        actions: [
          aramaYapiliyorMu ?
          IconButton(
            icon: Icon(Icons.cancel),
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = false;
                aramaKelimesi = "";
              });
            },
          )
              : IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState(() {
                aramaYapiliyorMu = true;
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Kelimeler>>(
        future:  aramaYapiliyorMu ? aramaYap(aramaKelimesi) : tumKelimelerGoster(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            var kelimelerListesi = snapshot.data;
            return ListView.builder(
                itemCount: kelimelerListesi.length,
                itemBuilder: (context,indeks){
                  var kelime = kelimelerListesi[indeks];
                  return Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: SizedBox(height: 200,width: 200,
                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 300, height: 300,
                            child: FlipCard(direction: FlipDirection.HORIZONTAL,
                              front: Card(elevation: 6,
                                child: Center(
                                  child:Text(kelime.ingilizce,style: TextStyle(fontWeight: FontWeight.bold),),),),
                              back: Card(elevation: 6,
                                child:Image.asset("resimler/${kelime.turkce}"),),),
                          ),],),),);});
          }else{
            return Center();
          }
        },
      ),

    );
  }
}
