class Quizdata {
  int id;
  String t_id;
  String t_qu;
  String t_op1;
  String t_op2;
  String t_op3;
  String t_op4;
  String t_qcorrect;
  String explainans;


  Quizdata(int id, String t_id, String t_qu,String t_op1,String t_op2,String t_op3,String t_op4,String t_qcorrect,String explainans) {
    this.id = id;
    this.t_id = t_id;
    this.t_op1 = t_op1;
    this.t_op2 = t_op2;
    this.t_op3 = t_op3;
    this.t_op4 = t_op4;
    this.t_qcorrect = t_qcorrect;
    this.explainans = explainans;

  }

  Quizdata.fromJson(Map json)
      : id = json['id'],
        t_qu = json['t_qu'],
        t_op1 = json['t_op1'],
        t_op2 = json['t_op2'],
        t_op3 = json['t_op3'],
        t_op4 = json['t_op4'],
        t_qcorrect = json['t_qcorrect'],
        explainans = json['explainans'];

        Map toJson() {
    return {'id': id, 't_qu': t_qu, 't_op1': t_op1, 't_op2': t_op2,'t_op3': t_op3,'t_op4': t_op4,'t_qcorrect': t_qcorrect,'explainans': explainans};
  }
}