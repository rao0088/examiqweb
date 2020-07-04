class Coursedata {
  int id;
  String tname;
  String course_id;
  String qno;
  String qr;

  Coursedata(int id, String tname, String course_id,String qno,String qr) {
    this.id = id;
    this.tname = tname;
    this.course_id = course_id;
    this.qr = qr;
    this.qno = qno;

  }

  Coursedata.fromJson(Map json)
      : id = json['id'],
        tname = json['tname'],
        course_id = json['course_id'],
        qno = json['qno'],
        qr = json['qr'];

  Map toJson() {
    return {'id': id, 'tname': tname, 'course_id': course_id,'qno':qno,'qr':qr};
  }
}