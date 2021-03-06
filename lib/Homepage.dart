import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:examiq/Student/student.dart';
import 'package:examiq/database/FirebaseMessage.dart';
import 'package:examiq/notification.dart';
import 'package:examiq/widget/bannerads.dart';
import 'package:flutter/material.dart';
import 'package:examiq/database/StudentHelper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  int _selectedIndex = 0;
  FirebaseUser user;
  bool isSignedIn= false;
  bool isLoading = true;
  bool isInternet = true;
  final databaseReference = Firestore.instance;
  String coursename;
   List<int> coursedata=[];
  Map<String, dynamic> firemessage;
  int courseid;
  String coursetype;
  int noti = 0;



  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user){
      if(user==null){
        Navigator.pushReplacementNamed(context, "/LoginPage");
      }
    });
  }

  checkinternet() async {
    final result = await InternetAddress.lookup('www.google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
     isInternet=true;
    }else{
      isInternet=false;
    }
  }
  getUser() async{
    FirebaseUser firebaseUser =await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if(firebaseUser !=null){
      setState(() {
        this.user =firebaseUser;
        this.isSignedIn = true;
      });
      getcourseData();
    }

  }
final String url="https://examiqguru.com/api/flutterapi";
List<dynamic> course ;
Future<List> getCourse() async{
  var response =await http.get(url, headers: {'APP_KEY':'peehuyadav@flutterapikey'});
  setState(() {
    course = jsonDecode(response.body);
    isLoading = false;
  });

  return course ;

}
   getcourseData() async {
    //return coursedata = await databaseReference.collection(user.email).snapshots();
     databaseReference.collection(user.email).getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {

          setState(() {
            coursedata.add(result.data['courseid']);
          });
          //print(coursedata);
      });
    });
  }
addCourse(String eMessage){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Message'),
            content:Container(
              child: Text(eMessage),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Add to your Library'),
                onPressed: (){
                  addcourseData(context);
                },
              ),
            ],
          );
        }
    );
  }
 eerror(String message){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Alert'),
            content:Container(
              child: Text(message),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('ok'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }

  ealertfirenotification(message){
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message["notification"]["title"]),
          subtitle: Text(message["notification"]["body"]),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }


  _saveDeviceToken() async {
    if (firemessage!=null) {
      NotiData data = NotiData(firemessage["notification"]["title"], firemessage["notification"]["body"]);
      await databaseReference.collection('Token').document()
          .setData(data.toJson());
    }
  }

  addcourseData(BuildContext context) async{

    if(coursename!=null && courseid!=null && coursetype!=null){
      StudentData data = StudentData(this.coursename,this.courseid,this.coursetype);
      await databaseReference.collection(user.email).document()
          .setData(data.toJson());
      Navigator.popAndPushNamed(context,'/MyHomePage');
      navigatorLastscreen();
    }else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error Message'),
              content: Text("All Feild Are Required"),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          }
      );
    }
  }

  _onItemTapped(int index){

    setState(() {
      _selectedIndex = index;
    });

    if(index==1){
      Navigator.push(context, MaterialPageRoute(builder: (context){

        return NotificationPage();
      }));
    }
    if(index==2){
      Navigator.push(context, MaterialPageRoute(builder: (context){
        return StudentPage(user.email);
      }));
    }

  }
  navigatorLastscreen(){
    Navigator.popAndPushNamed(context,'/MyHomePage');
  }
  signOut() async{
    _auth.signOut();
  }

  void getfirebabeMessage(){
    _fcm.configure(
        onMessage: (firemessage) async {
          print('on message $firemessage');
          setState(() => noti= noti+1);
          ealertfirenotification(firemessage);
          _saveDeviceToken();
        },
        onResume: (firemessage) async {
      print('on resume $firemessage');
      setState(() => noti= noti+1);
      _saveDeviceToken();

    }, onLaunch: (firemessage) async {
      print('on launch $firemessage');
      setState(() => noti= noti+1);
      _saveDeviceToken();
    });

  }


  @override
  void initState(){
    super.initState();
    this.checkAuthentication();
    this.getUser();
    this.getCourse();
    this.checkinternet();
    this.getfirebabeMessage();
    Ads.showBannerAd();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam IQ Guru',style: TextStyle(color: Colors.white),),
      ),
      drawer: !isSignedIn?CircularProgressIndicator()
          : Drawer(
        elevation: 3.0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
//           DrawerHeader(
//             child: Text('Header'),
//             decoration: BoxDecoration(
//               color:Colors.green,
//             ),
//           ),
            UserAccountsDrawerHeader(
              accountName: Text(user.displayName),
              accountEmail: Text(user.email),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                Theme.of(context).accentColor,
                child: Text(
                  user.displayName[0].toUpperCase(),
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            Container(
              //color: Theme.of(context).primaryColor,
              padding: EdgeInsets.fromLTRB(30.0,20.0,30.0,20.0),
              child: RaisedButton.icon(
                  color: Theme.of(context).primaryColor,
                  onPressed: signOut, icon: Icon(Icons.account_circle), label: Text('Logout')),
            ),
            Card(
              child: ListTile(
                title: Text("Contact Us"),
                subtitle: Text("examiqguru@gmail.com"),
              ),
            ),
            ListTile(
              title: Text('App version 1.0.0'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: !isInternet ? Center(
        child: Text("No internet Connection"),
      ): isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :GridView.builder(
        itemCount: course == null ? 0 : course.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).orientation == Orientation.portrait) ? 3 : 4),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child:InkWell(
              onTap: () {
                setState(() {
                  courseid = course[index]['id'];
                  coursename = course[index]['name'];
                  coursetype = course[index]['coursetype'].toString();
                });
                if(coursedata.contains(course[index]['id'])){
                  eerror("This course already added in Student library");
                }else if(coursedata.length>1){
                  eerror("Student Can Add only Two Courses in library");
                }else {
                  addCourse(course[index]['about']);
                }
              },
              child:Column(
                children: <Widget>[
                  Card(child:Text((coursedata.contains(course[index]['id']))  ? "        Added         " : "",style:TextStyle(color: Colors.white),),
                    color: Colors.orange[400],
                  ),
                  Icon(index.isEven ? Icons.school : Icons.book,
                    size:MediaQuery.of(context).orientation == Orientation.portrait ?40 : 30,
                    color: index.isOdd  ? Colors.amber[800]: Colors.green[800],),
                  Expanded(
                    child: Text(course[index]['name']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            title: Text('Notification'),
            icon: new Stack(
              children: <Widget>[
                new Icon(Icons.notifications),
                new Positioned(
                  right: 0,
                  child: new Container(
                    padding: EdgeInsets.all(1),
                    decoration: new BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 12,
                      minHeight: 12,
                    ),
                    child: new Text(
                      '$noti',
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              ],
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Library'),

          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}


