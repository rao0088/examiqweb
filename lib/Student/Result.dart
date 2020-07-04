import 'package:examiq/services/Quizdata.dart';
import 'package:examiq/widget/bannerads.dart';
import 'package:flutter/material.dart';
import 'package:examiq/services/Result.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
class Result extends StatefulWidget {
  final List aQues;
  final List cQues;
  final int courseid;
  final String userdata;
  final List options;
  final int total;
  Result(this.aQues, this.cQues, this.courseid,this.userdata,this.options,this.total);
  @override
  _ResultState createState() => _ResultState(aQues,cQues,courseid,userdata,options,total);
}

class _ResultState extends State<Result> {
  _ResultState(this.aQues,this.cQues,this.courseid,this.userdata,this.options,this.total);
  String userdata;
  int courseid;
  var Quiz = new List<Quizdata>();
  List aQues;
  List cQues;
  List options;
  bool isLoading = true;
  int total;
  var result;
  Future<List> getquiz() async{
    final String url='https://examiqguru.com/api/flutterapi/quiz/$courseid';
    var response =await http.get(url, headers: {'APP_KEY':'peehuyadav@flutterapikey'});
    setState(() {
      Iterable list = json.decode(response.body);
      Quiz = list.map((model) => Quizdata.fromJson(model)).toList();
    });
    print(Quiz);

    return Quiz ;
  }
  List<charts.Series<ResultData,String>> _chartsd;
  chartData(){
    var chartData=[
        ResultData('correct',cQues.length,Colors.green),
        ResultData('Incorrect',(aQues.length - cQues.length),Colors.red),
        ResultData('Skiped',(total- aQues.length),Colors.amber),
    ];
    _chartsd.add(
      charts.Series(
        id:'Correct',
        domainFn: (ResultData resultData,_)=>resultData.name,
        measureFn: (ResultData resultData,_)=>resultData.total,
        colorFn:(ResultData resultData,_) => charts.ColorUtil.fromDartColor(resultData.colorname),
        data: chartData,
        labelAccessorFn: (ResultData resultData,_)=> '${resultData.total.toString()}',
      ),
    );
  }
  Timer _timer;
  int _start = 5;

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
  resultStudent(){
    setState(() {
      result = cQues.length*2-((aQues.length - cQues.length)*.33).round();
    });
  }

  _backnavigation(){
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/MyHomePage', (Route<dynamic> route) => false);

  }

  @override
  void initState(){
    super.initState();
    this.getquiz();
    _chartsd =List<charts.Series<ResultData,String>>();
    chartData();
    this.startTimer();
    this.resultStudent();
  }

  @override
  void dispose() {
    _timer.cancel();
    Ads.hideBannerAd();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop:(){
         _backnavigation();
        },
      child:Scaffold(
        appBar:AppBar(
          leading:IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
             _backnavigation();
            },
          ),
          title: Text("Result"),
        ),
        body:isLoading
            ? Center(
          child:Column(
            children: <Widget>[
              SizedBox(height: 150),
              Text("Your Result Will be",style:
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
        ):SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width ,
                child: Card(
                  child: charts.BarChart(
                    _chartsd,
                    animate: true,
                    barGroupingType:charts.BarGroupingType.grouped,
                    defaultRenderer: charts.BarRendererConfig(
                      groupingType: charts.BarGroupingType.grouped,
                      strokeWidthPx: 1.0,
                      barRendererDecorator: new charts.BarLabelDecorator<String>(),
                    ),
                    animationDuration: Duration(seconds:0),
                    behaviors: [
                      charts.SeriesLegend(
                        position: charts.BehaviorPosition.end,
                        horizontalFirst: false,
                        showMeasures: true,
                        cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                        legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                        measureFormatter: (num value) {
                          return value == null ? '-' : '${value}';
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 8,
                child: Padding(
                    padding: EdgeInsets.only(left: 15.0,right: 10.0),
                    child:Row(
                      children: <Widget>[
                        Text(' Student Marks',style: TextStyle(fontSize:14,color:Colors.pink)),
                        CircleAvatar(
                          backgroundColor: Colors.redAccent[400],
                          foregroundColor: Colors.white,
                          radius: 60.0,
                          child: Text('${result.toString()} / ${total*2}',style: TextStyle(fontSize:20),
                          ),
                        ),
                      ],
                    )
                ),
              ),
              ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Quiz == null ? 0 : Quiz.length,
                  itemBuilder: (BuildContext context, int index){
                    return Card(
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0,top:12.0,right:5.0,bottom: 12.0),
                            child: Text(
                              " Q ${index + 1} ${Quiz[index].t_qu}",textAlign: TextAlign.start,
                              style:
                              TextStyle(fontSize: 16, color: Colors.black.withOpacity(0.8),),
                            ),
                          ),
                          Card(
                              color:(Quiz[index].t_qcorrect =='1')?Colors.green:Colors.white,
                              child:ListTile(
                                leading:CircleAvatar(
                                  child:  Text('A'),
                                  backgroundColor: options.contains('${Quiz[index].id} ${Quiz[index].t_op1}')?Colors.red:Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                ),
                                title: Text('${Quiz[index].t_op1}',style:
                                TextStyle(fontSize: 14,color: (Quiz[index].t_qcorrect =='1')?Colors.white:Colors.black.withOpacity(0.8)),),
                              )
                          ),
                          Card(
                              color: (Quiz[index].t_qcorrect =='2')?Colors.green:Colors.white,
                              child:ListTile(
                                leading:CircleAvatar(
                                  child:  Text('B'),
                                  backgroundColor:options.contains('${Quiz[index].id} ${Quiz[index].t_op2}')?Colors.red:Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                ),
                                title: Text('${Quiz[index].t_op2}',style:
                                TextStyle(fontSize: 14,color:(Quiz[index].t_qcorrect =='2')?Colors.white: Colors.black.withOpacity(0.8)),),
                              )
                          ),
                          Card(
                              color: (Quiz[index].t_qcorrect =='3')?Colors.green:Colors.white,
                              child:ListTile(
                                leading:CircleAvatar(
                                  child:  Text('C'),
                                  backgroundColor: options.contains('${Quiz[index].id} ${Quiz[index].t_op3}')?Colors.red:Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                ),
                                title: Text('${Quiz[index].t_op3}',style:
                                TextStyle(fontSize: 14,color: (Quiz[index].t_qcorrect =='3')?Colors.white:Colors.black.withOpacity(0.8)),),
                              )
                          ),
                          Card(
                              color: (Quiz[index].t_qcorrect =='4')?Colors.green:Colors.white,
                              child:ListTile(
                                leading:CircleAvatar(
                                  child:  Text('D'),
                                  backgroundColor: options.contains('${Quiz[index].id} ${Quiz[index].t_op4}')?Colors.red:Colors.blueGrey,
                                  foregroundColor: Colors.white,
                                ),
                                title: Text('${Quiz[index].t_op4}',style:
                                TextStyle(fontSize: 14,color: (Quiz[index].t_qcorrect =='4')?Colors.white:Colors.black.withOpacity(0.8)),),
                              )
                          ),
                          Card(
                              child:ListTile(
                                leading:Text('Your answer'),
                                title: Text(cQues.contains(Quiz[index].id)?'- Correct':aQues.contains(Quiz[index].id)?'- Incorrect' :'- Skiped',style:
                                TextStyle(fontSize: 14,color: Colors.red.withOpacity(0.8)),),
                              )
                          ),

                             Card(
                                 child:ListTile(
                                   leading:Text(Quiz[index].explainans !=null ?'Explainations' : ""),
                                   title: Text(Quiz[index].explainans !=null ? Quiz[index].explainans : '',style:
                                   TextStyle(fontSize: 14,color: Colors.red.withOpacity(0.8)),),
                                 )
                             ),

                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
