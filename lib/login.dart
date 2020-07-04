import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth =FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  checkAuthentication()async{

    _auth.onAuthStateChanged.listen((user) async{
      if(user!=null){

        Navigator.pushReplacementNamed(context, "/");

      }
    });
  }

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);

    // print(user);
    try{
      if(user !=null){

        //return user;
        print("signed in " + user.displayName);
      }
    }catch(e){

      showError(e.message);

    }
    return user;

  }


  showError(String errorMessage){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Error Message'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
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
    this.checkAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     resizeToAvoidBottomInset: false,
      backgroundColor:Colors.white,
      body: Stack(
        children: <Widget>[
        Align(
        alignment: Alignment.topCenter,
        child: ClipPath(
          child: Container(
            alignment: Alignment.topCenter,
            color: Colors.red,
            height: 200,
            width: MediaQuery.of(context).size.width,
            child:Padding(
              padding:EdgeInsets.only(top:95),
              child: RichText(
                text: TextSpan(
                  text: 'Exam',
                  style: TextStyle(
                      color: Colors.white, fontSize: 32),
                  children:  <TextSpan>[
                    TextSpan(
                        text: 'IQ',
                        style:TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(text: 'Guru',
                      style: TextStyle(
                          color: Colors.black, fontSize: 35),),
                  ],
                ),
              ),
            ),
          ),
          clipper: CustomClipPath(),
        ),
      ),
       Align(
         alignment: Alignment.center,
         child: RaisedButton.icon(
           color:Theme.of(context).primaryColor,
           elevation: 8.0,
           onPressed:(){
             _handleSignIn()
                 .then((FirebaseUser user) => print(user))
                 .catchError((e) => print(e));
           },
           icon: Icon(FontAwesomeIcons.google,color:Colors.white,size: 60.0,),
           label: Text('Sign In With Google',style: TextStyle(
             color: Colors.white,
             fontSize: 20.0,
           ),),
         ),
       ),

              Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    color: Colors.black,
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  ),
                  clipper: CustomClipPath(),
                ),
              ),
        ],
      ),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(size.width/4, size.height - 40, size.width/2, size.height-20);
    path.quadraticBezierTo(3/4*size.width, size.height, size.width, size.height-30);
    path.lineTo(size.width, 0);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}