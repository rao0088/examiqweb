import 'package:examiq/widget/Interstitialads.dart';
import 'package:flutter/material.dart';
import 'package:examiq/Student/modeltestshow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:examiq/database/StudentHelper.dart';
import 'package:firestore_ui/firestore_ui.dart';

import 'bookdetails.dart';
class StudentPage extends StatefulWidget {
  final String userdata;
  StudentPage (this.userdata);
  @override
  _StudentPageState createState() => _StudentPageState(userdata);
}

class _StudentPageState extends State<StudentPage> {
  String  userdata;
  bool isLoading = true;
  _StudentPageState(this.userdata);
  final databaseReference = Firestore.instance;
  List<DocumentSnapshot> _user = new List<DocumentSnapshot>();
  //var document;

  getUser() async{
    databaseReference.collection(userdata).getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {

        setState(() {
          isLoading=false;
          _user.add(result);
        });
        print(_user);
        return result;

      });
    });
  }

  navigateToLastScreen(BuildContext context){

    Navigator.of(context).pop();

  }

  _deleteuser(id)async{

    await databaseReference.collection(userdata).document(id).delete();
    navigateToLastScreen(context);
  }

  deleteCoursealert(String id){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Alert'),
            content:Container(
              child: Text("Are you sure to Delete"),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('ok'),
                onPressed: (){
                  _deleteuser(id);
                },
              ),
            ],
          );
        }
    );
  }

  eerror(int ids,String message){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Alert'),
            content:Container(
              child: Text("this is $ids and this is $message"),
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

  viewtestDetails(ids,userdata){
    Navigator.push(context, MaterialPageRoute(builder: (context){

      return ModelTest(ids,userdata);
    }));


  }
  viewbookDetails(ids,userdata){
    Navigator.push(context, MaterialPageRoute(builder: (context){

      return BookDetails(ids,userdata);
    }));
  }
  @override
  void initState(){
    super.initState();
    this.getUser();

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.popAndPushNamed(context,'/MyHomePage');
          },
        ),
        title: Text('Student Library'),
      ),
      body:isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          :FirestoreAnimatedGrid(
        key: ValueKey("grid"),
        query: databaseReference.collection(userdata).snapshots(),
        onLoaded: (snapshot) =>
            print("Received on grid: ${snapshot.documents.length}"),
        crossAxisCount:(MediaQuery.of(context).orientation == Orientation.portrait) ? 2 : 3,
        itemBuilder: (
            BuildContext context,
            DocumentSnapshot snapshot,
            Animation<double> animation,
            int index,
            ){
          return Card(
            child:InkWell(
              onTap:(){
                //viewtestDetails(snapshot.data['courseid']);
                if(snapshot.data['coursetype']=='1'){
                  viewtestDetails(snapshot.data['courseid'],userdata);
                  Adis.showInterstitialAd();
                }else{
                  viewbookDetails(snapshot.data['courseid'],userdata);
                  Adis.showInterstitialAd();
                }

              },
              child: Column(
                children: <Widget>[
                  Icon(index.isEven ? Icons.school : Icons.book,size:MediaQuery.of(context).orientation == Orientation.portrait ?50 : 40,
                    color: index.isOdd  ? Colors.amber[800]: Colors.green[800],),
                  SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: '${snapshot.data['coursename']}',
                      style: TextStyle(fontSize:18,color: Colors.black,),
                    ),
                  ),
                  SizedBox(height: 30),
                  Ink(
                    child: ListTile(
                    leading: Icon(Icons.delete_forever,color:Colors.black),
                    onTap: (){
                      deleteCoursealert(snapshot.documentID);
                     // eerror(snapshot.data['courseid']);
                    },
                  ),
                  ),

                ],
            ),
            ),
          );
        },
      ),
    );
  }
}

