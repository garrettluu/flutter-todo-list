import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo_list/firebaseAdapter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Flutter Todo List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAdapter firebaseAdapter;
  _MyHomePageState() {
    firebaseAdapter = new FirebaseAdapter(Firestore.instance);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: firebaseAdapter.getTaskList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTask(firebaseAdapter: firebaseAdapter,)),
          );
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class NewTask extends StatefulWidget {
  FirebaseAdapter firebaseAdapter;
  NewTask({Key key, @required this.firebaseAdapter}) : super(key: key);

  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final controller = TextEditingController();
  String text = '';
  @override
  void initState() {
    super.initState();
    controller.addListener(_setText);
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _setText() => this.text = controller.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('New Task'),
      ),
      body: Center (
        child: TextField(
          decoration: InputDecoration(border: InputBorder.none, hintText: 'Enter a Task name'),
          controller: controller,
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.firebaseAdapter.createTask(controller.text);
          Navigator.pop(context);
        },
        child: Icon(Icons.send),
      ),
    );
  }
}

class Task extends StatelessWidget {
  String name;
  String id;
  FirebaseAdapter firebaseAdapter;
  Task({@required this.name, @required this.id, this.firebaseAdapter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Text(
            name,
            style: TextStyle(fontSize: 16),
          ),
          RaisedButton(onPressed: () {
            firebaseAdapter.deleteTask(id);
          }),
        ],
      ),
    );
  }
}
