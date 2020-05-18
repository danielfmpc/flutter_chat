import 'dart:io';

import 'package:chat/components/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  void _getUser() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken, 
        accessToken: googleSignInAuthentication.accessToken
      );
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final FirebaseUser user = authResult.user;
    } catch (error) {
    }
  }

  void _sendMessage({String text, File imgFile}) async {

    Map<String, dynamic> data = {};

    if(imgFile != null){
      StorageUploadTask task = FirebaseStorage.instance.ref().child(
        DateTime.now().millisecondsSinceEpoch.toString(),
      ).putFile(imgFile);

      StorageTaskSnapshot taskSnapshot = await task.onComplete;

      String url = await taskSnapshot.ref.getDownloadURL();
      data["imgFIle"] = url;
    }

    if(text != null) data["text"] = text;

    Firestore.instance.collection("message").add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ola, Daniel"),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.exit_to_app),
          ),          
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection("message").snapshots(),
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                  case ConnectionState.waiting:
                    return Center(
                      child: CircularProgressIndicator(),
                    );                    
                    break;
                  default:
                    List<DocumentSnapshot> documents = snapshot.data.documents.reversed.toList();
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index){
                        return ListTile(
                          title: Text(documents[index].data["text"]),
                        );
                      },
                    );
                }
              },
            ),
          ),
          TextComposer(_sendMessage),
        ],
      ),
    );
  }
}