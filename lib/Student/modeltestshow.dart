import 'package:examiq/Student/starttest.dart';
import 'package:examiq/services/coursedata.dart';
import 'package:examiq/widget/Interstitialads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ModelTest extends StatefulWidget {
  final int ids;
  final String userdata;

  ModelTest(this.ids,this.userdata);
  @override
  _ModelTestState createState() => _ModelTestState(ids,userdata);
}

class _ModelTestState extends State<ModelTest> {
  _ModelTestState(this.ids,this.userdata);
  String  userdata;
  int ids;
  bool isLoading = true;
  var course = new List<Coursedata>();

  Future<List> getCourse() async{
    final String url='https://examiqguru.com/api/flutterapi/$ids';
    var response =await http.get(url, headers: {'APP_KEY':'peehuyadav@flutterapikey'});
    setState(() {
      Iterable list = json.decode(response.body);
      course = list.map((model) => Coursedata.fromJson(model)).toList();

      isLoading = false;
    });
    print(course);

    return course ;
  }

  _startTestNow(userdata,courseid){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Starttest(userdata,courseid);
    }));

  }
  @override
  void initState(){
    super.initState();
    this.getCourse();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Student Library'),
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :ListView.builder(
        itemCount: course == null ? 0 : course.length,
        itemBuilder: (BuildContext context, int index) {
          if(course[index].qno == course[index].qr){
            return Card(
              child:ListTile(
                leading:CircleAvatar(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  child:  Text((index+1).toString()),
                ),
                title:  Text('${(course[index].tname).toUpperCase()}'),
                subtitle: Text('Total Question - ${course[index].qr}'),
                trailing: Text('Marks - ${int.parse(course[index].qno)*2}'),
                onTap: (){
                  Adis.showInterstitialAd();
                  _startTestNow(userdata,course[index].id,);
                },
              ),

            );
          }
          return Card();
        },
      ),
    );
  }
}
