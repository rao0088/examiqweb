import 'package:cloud_firestore/cloud_firestore.dart';
class NotiData{
  String _id;
  String _title;
  String _body;
  // construster for  adding data

  NotiData(this._title,this._body);

  // construster for  Editing  data

  NotiData.withId(this._id,this._title,this._body);

  //getter  for data getting

  String get id => this._id;
  String get title=>this._title;
  String get body => this._body;

  // setters

  set title(String title){
    this._title = title;
  }
  set body(String body){
    this._body = body;
  }




  NotiData.fromDocument(DocumentSnapshot doc){

    this._id = doc['id'];
    this._title=doc['title'];
    this._body=doc['body'];

  }

  Map<String, dynamic> toJson(){
    return{
      "title": _title,
      "body":_body,

    };

  }


}