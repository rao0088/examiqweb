import 'package:examiq/Student/Bookdatashow.dart';
import 'package:examiq/services/Bookdata.dart';
import 'package:examiq/widget/Interstitialads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
class BookDetails extends StatefulWidget {
  final int ids;
  final String userdata;
  BookDetails(this.ids,this.userdata);
  @override
  _BookDetailsState createState() => _BookDetailsState(ids,userdata);
}

class _BookDetailsState extends State<BookDetails> {
  _BookDetailsState(this.ids,this.userdata);
  String  userdata;
  int ids;
  bool isLoading = true;

  var book = new List<Bookdata>();

  Future<List> getBook() async{
    final String url='https://examiqguru.com/api/flutterapi/book/$ids';
    var response =await http.get(url, headers: {'APP_KEY':'peehuyadav@flutterapikey'});
    setState(() {
      Iterable list = json.decode(response.body);
      book = list.map((model) => Bookdata.fromJson(model)).toList();
      isLoading = false;
    });
    print(book);

    return book;
  }
  Bookshow(description){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      Adis.showInterstitialAd();
      return BookDatashow(description);
    }));
  }
  @override
  void initState(){
    super.initState();
    this.getBook();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Details'),
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :ListView.builder(
        itemCount: book == null ? 0 : book.length,
        itemBuilder: (BuildContext context, int index) {
            return Card(
              child:ListTile(
                leading:CircleAvatar(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child:  Text((index+1).toString()),
                ),
                title:  Text('${(book[index].title)}'),
                onTap: (){
                 Bookshow(book[index].description);
                },
              ),

            );
        },
      ),
    );
  }
}

