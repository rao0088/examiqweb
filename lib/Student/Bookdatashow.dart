import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
class BookDatashow extends StatefulWidget {
  final String description;
  BookDatashow(this.description);
  @override
  _BookDatashowState createState() => _BookDatashowState(description);
}

class _BookDatashowState extends State<BookDatashow> {
  _BookDatashowState(this.description);

  String description;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Chapter'),
      ),
      body: Container(
        padding: EdgeInsets.only(left:10.0,right: 10.0),
        child:SingleChildScrollView(
          child:Container(
            child: HtmlWidget(
              description,
            ),
          ),
        ),
      ),
    );
  }
}
