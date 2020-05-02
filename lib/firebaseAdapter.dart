import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/main.dart';

class FirebaseAdapter {
  var firebaseInstance;
  FirebaseAdapter(this.firebaseInstance);

  getTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseInstance.collection('tasks').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return new Task(name: 'Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Task(name:'Loading...');
          default:
            return new ListView(
              children: getTasks(snapshot),
            );
        }
      },);
  }

  getTasks(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map(
      (doc) => new Task(name: doc["name"])
    ).toList();
  }
  
}