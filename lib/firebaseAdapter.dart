import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_list/main.dart';

class FirebaseAdapter {
  Firestore firebaseInstance;
  FirebaseAdapter(this.firebaseInstance);

  getTaskList() {
    return StreamBuilder<QuerySnapshot>(
      stream: firebaseInstance.collection('tasks').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return new Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: getTasks(snapshot),
            );
        }
      },);
  }

  getTasks(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map(
      (DocumentSnapshot doc) => new Task(name: doc["name"], id: doc.documentID, firebaseAdapter: this)
    ).toList();
  }

  deleteTask(String documentID) {
    firebaseInstance.collection('tasks').document(documentID).delete();
  }

  createTask(String name) {
    firebaseInstance.collection('tasks').add(<String, dynamic>{'name': name});
  }

  updateTask(String name, String documentID) {
    firebaseInstance.collection('tasks').document(documentID).updateData(<String, dynamic>{'name': name});
  }
  
}