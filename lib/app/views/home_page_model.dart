import 'dart:convert';
import 'package:flutter_training/app/models/todo_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_training/app/models/character_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Todo> todoList = [];
Todo todo;
Character character;
List<Character> characterList = [];

class _MyHomePageState extends State<MyHomePage> {
  ScrollController _scrollController = new ScrollController();
  String nextUrl = "";

  @override
  void initState() {
    getListOfCharactersFromAPI("https://rickandmortyapi.com/api/character");
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          nextUrl != null) {
        getListOfCharactersFromAPI(nextUrl);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    // getListOfCharactersFromAPI();
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

  Future getListOfCharactersFromAPI(String url) async {
    var response = await http.get(Uri.parse(url));
    var jsonArray = jsonDecode(response.body)['results'];

    var modelList = await jsonArray
        .map((json) => Character.fromJson(json))
        .toList()
        .cast<Character>();

    setState(() {
      characterList = [...characterList, ...modelList];
      nextUrl = jsonDecode(response.body)['info']['next'];
    });

    print(characterList.length);
  }

  Widget _listCard(Character character) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: (Card(
        elevation: 10,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Image.network(character.image),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              "${character.id}",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            character.origin.name,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            character.name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            character.gender + " - " + character.species,
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            character.status,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(bottom: 150),
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (character, index) {
              return ListTile(
                title: _listCard(
                  characterList[index],
                ),
              );
            },
            itemCount: characterList.length,
          ),
        ),
        // ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
