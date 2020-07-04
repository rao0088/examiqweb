class Bookdata{
  int id;
  String title;
  String bookid;
  String description;


  Bookdata(int id, String title, String bookid,String description,) {
    this.id = id;
    this.title = title;
    this.bookid = bookid;
    this.description = description;
  }

  Bookdata.fromJson(Map json)
      : id = json['id'],
        title = json['title'],
        bookid=json['bookid'],
        description = json['description'];

  Map toJson() {
    return {'id': id, 'title': title, 'bookid': bookid,'description':description};
  }
}