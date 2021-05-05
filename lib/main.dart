import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_training/app/models/character_model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Todo {
  int userId;
  int id;
  String title;
  bool completed;

  Todo({this.userId, this.id, this.title, this.completed});

  Todo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    title = json['title'];
    completed = json['completed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['id'] = this.id;
    data['title'] = this.title;
    data['completed'] = this.completed;
    return data;
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Todo todo;
  List<Todo> todoList = [];

  Character character;
  List<Character> characterList = [];

  void initState() {
    // getToDoListFromAPI();
    getListOfCharactersFromAPI();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    getListOfCharactersFromAPI();
  }

  Future getOnlyOneToDoFromAPI() async {
    var url = 'https://jsonplaceholder.typicode.com/todos/1';
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);

    setState(() {
      todo = Todo.fromJson(json);
    });

    print(todo.toJson());
  }

  Future getToDoListFromAPI() async {
    var url = 'https://jsonplaceholder.typicode.com/todos';
    var response = await http.get(Uri.parse(url));
    var jsonArray = await jsonDecode(response.body);
    List<Todo> modelList = await jsonArray
        .map((json) => Todo.fromJson(json))
        .toList()
        .cast<Todo>();

    setState(() {
      todoList = modelList;
    });
  }

  Future getSingleCharacterFromAPI() async {
    var url = "https://rickandmortyapi.com/api/character/2";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);

    setState(() {
      character = Character.fromJson(json);
    });
  }

  Future getListOfCharactersFromAPI() async {
    var url = "https://rickandmortyapi.com/api/character";
    var response = await http.get(Uri.parse(url));
    var jsonArray = jsonDecode(response.body)['results'];

    // print(jsonArray);

    var modelList = await jsonArray
        .map((json) => Character.fromJson(json))
        .toList()
        .cast<Character>();

    setState(() {
      characterList = modelList;
    });
  }

  Widget _listCard(Character character) {
    return (Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Center(child: Text("${character.id}")),
                    flex: 1,
                  ),
                  Expanded(child: Text("${character.name}"), flex: 3)
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [for (var character in characterList) _listCard(character)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
