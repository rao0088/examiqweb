import 'dart:core';
import 'package:examiq/Student/Result.dart';
import 'package:examiq/services/Quizdata.dart';
import 'package:examiq/widget/Interstitialads.dart';
import 'package:examiq/widget/bannerads.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
class Starttest extends StatefulWidget {
  final String userdata;
  final int courseid;
  Starttest(this.userdata, this.courseid);

  @override
  _StarttestState createState() => _StarttestState(userdata,courseid);
}

class _StarttestState extends State<Starttest> {
  _StarttestState(this.userdata,this.courseid);
  String userdata;
  int courseid;
  int testsubmit=0;
  bool isLoading = true;
  bool istestsubmit = false;
  int total;
  var Quiz = new List<Quizdata>();
  List<String> options=[];
  List<int> question=[];
  List<int> qcorrect=[];
  var op1 = '1';
  var op2 = '2';
  var op3 = '3';
  var op4 = '4';



  Future<List> getquiz() async{
    final String url='https://examiqguru.com/api/flutterapi/quiz/$courseid';
    var response =await http.get(url, headers: {'APP_KEY':'peehuyadav@flutterapikey'});
    setState(() {
      Iterable list = json.decode(response.body);
      Quiz = list.map((model) => Quizdata.fromJson(model)).toList();
    });
    print(Quiz);
    setState(() {
      total=Quiz.length;
    });
    return Quiz ;
  }
  navigationback(){
    if(courseid==null){
      Navigator.pushReplacementNamed(context,'/MyHomePage');
    }

  }
  submitData(){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return Result(question,qcorrect,courseid,userdata,options,total);
    }));
  }

  _submit(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Alert'),
            content:Container(
              child: Text("Are You Sure To Submit"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ok'),
                onPressed: (){
                  Navigator.of(context).pop();
                  submitData();

                },
              ),
              FlatButton(
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  @override
  void initState(){
    super.initState();
    this.getquiz();
    this.startTimer();
    this.navigationback();
  }

  Timer _timer;
  int _start = 10;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) => setState(
            () {
          if (_start < 1) {
            timer.cancel();
            isLoading = false;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    Ads.hideBannerAd();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.popAndPushNamed(context,'/MyHomePage');
      },
      child: Scaffold(
        appBar: AppBar(
          leading:Icon(Icons.watch_later),
          title: Text("Modal Test Begin"),
          actions: <Widget>[
            RaisedButton(
              color: Colors.red[600],
              textColor: Colors.white,
              disabledColor: Colors.red,
              disabledTextColor: Colors.white,
              padding: EdgeInsets.fromLTRB(4,2,3,2),
              splashColor: Colors.red,
              onPressed: (){
                Adis.showInterstitialAd();
                _submit();
              },
              child: Text('Submit',style: TextStyle(fontSize: 20.0),),
            ),
          ],
        ),
        body:isLoading
            ? Center(
          child:Column(
            children: <Widget>[
              SizedBox(height: 150),
              Text("Your test Start in ",style:
              TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),),
              SizedBox(height: 20),
              CircleAvatar(
                radius: 40.0,
                child:  Text('$_start'),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              SizedBox(height: 30),
              Text("Second(s) ",style:
              TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),),
              Text(" Best of Luck",style:
              TextStyle(fontSize: 18, color: Colors.black.withOpacity(0.8)),),
            ],
          ),
        ):ListView.builder(
          itemCount: Quiz == null ? 0 : Quiz.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child:Column(
                children: <Widget>[
                  Divider(
                      color: Colors.red
                  ),
                  Text(
                    " Q ${index + 1} ${Quiz[index].t_qu}",textAlign: TextAlign.start,
                    style:
                    TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8),),
                  ),

                  GestureDetector(
                    onTap: (){


                    },
                    child: Container(
                      child:
                      Padding(
                        padding: const EdgeInsets.only(left:8.0,top:3.0,right:8.0,bottom:7.0),
                        child: Column(
                          children: <Widget>[
                            Divider(
                                color: Colors.red
                            ),
                            GestureDetector(
                              onTap:(){
                                  setState(() {
                                    options.remove('${Quiz[index].id} ${Quiz[index].t_op2}');
                                    options.remove('${Quiz[index].id} ${Quiz[index].t_op3}');
                                    options.remove('${Quiz[index].id} ${Quiz[index].t_op4}');
                                    if(question.contains(Quiz[index].id)){
                                      options.contains('${Quiz[index].id} ${Quiz[index].t_op1}')?options.remove('${Quiz[index].id} ${Quiz[index].t_op1}'):options.add('${Quiz[index].id} ${Quiz[index].t_op1}');
                                      if((Quiz[index].t_qcorrect == op1)){
                                        qcorrect.contains(Quiz[index].id)?qcorrect.remove(Quiz[index].id):qcorrect.add(Quiz[index].id);
                                      }
                                    }else{
                                      question.add(Quiz[index].id);
                                      options.add('${Quiz[index].id} ${Quiz[index].t_op1}');
                                      if(Quiz[index].t_qcorrect == op1){
                                        qcorrect.add(Quiz[index].id);
                                      }
                                    }});
                              },
                              child:Card(
                                child: ListTile(
                                  leading:CircleAvatar(
                                    child:  Text('A'),
                                    backgroundColor: options.contains('${Quiz[index].id} ${Quiz[index].t_op1}')&question.contains(Quiz[index].id)? Colors.red : Colors.blueGrey,
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Row( children: <Widget>[
                                    Flexible(
                                      child: Text('${Quiz[index].t_op1}',style:
                                      TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.8)),),
                                    ),
                                  ],),
                                ),
                              ),
                            ),
                            Divider(
                                color: options.contains('${Quiz[index].id} ${Quiz[index].t_op1}')? Colors.red : Colors.blueGrey
                            ),

                            GestureDetector(
                              onTap:(){
                                setState(() {
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op1}');
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op3}');
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op4}');
                                  if(question.contains(Quiz[index].id)){
                                    options.contains('${Quiz[index].id} ${Quiz[index].t_op2}')?options.remove('${Quiz[index].id} ${Quiz[index].t_op2}'):options.add('${Quiz[index].id} ${Quiz[index].t_op2}');
                                    if((Quiz[index].t_qcorrect == op2)){
                                      qcorrect.contains(Quiz[index].id)?qcorrect.remove(Quiz[index].id):qcorrect.add(Quiz[index].id);
                                    }
                                  }else{
                                    question.add(Quiz[index].id);
                                    options.add('${Quiz[index].id} ${Quiz[index].t_op2}');
                                    if(Quiz[index].t_qcorrect == op2){
                                      qcorrect.add(Quiz[index].id);
                                    }

                                  }

                                });
                              },
                              child:Card(
                                child: ListTile(
                                  leading:CircleAvatar(
                                    child:  Text('B'),
                                    backgroundColor: options.contains('${Quiz[index].id} ${Quiz[index].t_op2}')&question.contains(Quiz[index].id)? Colors.red : Colors.blueGrey,
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Text('${Quiz[index].t_op2}',style:
                                        TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.8)),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Divider(
                                color:options.contains('${Quiz[index].id} ${Quiz[index].t_op2}')? Colors.red : Colors.blueGrey
                            ),
                            GestureDetector(
                              onTap:(){
                                setState(() {
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op2}');
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op1}');
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op4}');
                                  if(question.contains(Quiz[index].id)){
                                    options.contains('${Quiz[index].id} ${Quiz[index].t_op3}')?options.remove('${Quiz[index].id} ${Quiz[index].t_op3}'):options.add('${Quiz[index].id} ${Quiz[index].t_op3}');
                                    if((Quiz[index].t_qcorrect == op3)){
                                      qcorrect.contains(Quiz[index].id)?qcorrect.remove(Quiz[index].id):qcorrect.add(Quiz[index].id);

                                    }
                                  }else{
                                    question.add(Quiz[index].id);
                                    options.add('${Quiz[index].id} ${Quiz[index].t_op3}');
                                    if(Quiz[index].t_qcorrect == op3){
                                      qcorrect.add(Quiz[index].id);
                                    }
                                  }

                                });
                              },
                              child:Card(
                                child: ListTile(
                                  leading:CircleAvatar(
                                    child:  Text('C'),
                                    backgroundColor: options.contains('${Quiz[index].id} ${Quiz[index].t_op3}')&question.contains(Quiz[index].id)? Colors.red : Colors.blueGrey,
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Text('${Quiz[index].t_op3}',style:
                                        TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.8)),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: options.contains('${Quiz[index].id} ${Quiz[index].t_op3}')&question.contains(Quiz[index].id)? Colors.red : Colors.blueGrey,
                            ),

                            GestureDetector(
                              onTap:(){
                                setState(() {
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op2}');
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op3}');
                                  options.remove('${Quiz[index].id} ${Quiz[index].t_op1}');
                                  if(question.contains(Quiz[index].id)){
                                    options.contains('${Quiz[index].id} ${Quiz[index].t_op4}')?options.remove('${Quiz[index].id} ${Quiz[index].t_op4}'):options.add('${Quiz[index].id} ${Quiz[index].t_op4}');
                                    if((Quiz[index].t_qcorrect == op4)){
                                      qcorrect.contains(Quiz[index].id)?qcorrect.remove(Quiz[index].id):qcorrect.add(Quiz[index].id);

                                    }
                                  }else{
                                    question.add(Quiz[index].id);
                                    options.add('${Quiz[index].id} ${Quiz[index].t_op4}');
                                    if(Quiz[index].t_qcorrect == op4){
                                      qcorrect.add(Quiz[index].id);

                                    }
                                  }

                                });
                              },
                              child:Card(
                                child: ListTile(
                                  leading:CircleAvatar(
                                    child:  Text('D'),
                                    backgroundColor: options.contains('${Quiz[index].id} ${Quiz[index].t_op4}')&question.contains(Quiz[index].id)? Colors.red : Colors.blueGrey,
                                    foregroundColor: Colors.white,
                                  ),
                                  title: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Text('${Quiz[index].t_op4}',style:
                                        TextStyle(fontSize: 14,color: Colors.black.withOpacity(0.8)),),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Divider(
                              color: options.contains('${Quiz[index].id} ${Quiz[index].t_op4}')&question.contains(Quiz[index].id)? Colors.red : Colors.blueGrey,
                            ),

                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),

            );
          },
        ),
      ),
    );
  }
}
