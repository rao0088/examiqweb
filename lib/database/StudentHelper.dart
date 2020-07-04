import 'package:cloud_firestore/cloud_firestore.dart';
class StudentData{
  String _id;
  String _coursename;
  int _courseid;
  String _coursetype;
  // construster for  adding data

  StudentData(this._coursename,this._courseid,this._coursetype);

  // construster for  Editing  data

  StudentData.withId(this._id,this._coursename,this._courseid,this._coursetype);

  //getter  for data getting

  String get id => this._id;
  String get coursename=>this._coursename;
  int get courseid => this._courseid;
  String get coursetype => this._coursetype;

  // setters

  set coursename(String coursename){
    this._coursename = coursename;
  }
  set courseid(int courseid){
    this._courseid = courseid;
  }

  set coursetype(String coursetype){
    this._coursetype = coursetype;
  }




  StudentData.fromDocument(DocumentSnapshot doc){

    this._id = doc['id'];
    this._coursename=doc['coursename'];
    this._courseid=doc['courseid'];
    this._coursetype=doc['coursetype'];

  }

  Map<String, dynamic> toJson(){
    return{
      "coursename": _coursename,
      "courseid":_courseid,
      "coursetype":_coursetype,

    };

  }


}