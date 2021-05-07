import 'dart:convert';
import 'package:flutter_training/app/components/BottomNavigationBarComponent.dart';
import 'package:flutter_training/app/components/ListCard.dart';
import 'package:flutter_training/app/models/todo_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_training/app/models/character_model.dart';
import '../globals/index.dart' as globals;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

Character character;
List<Character> characterList = [];

class _SearchPageState extends State<SearchPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    globals.routeName = ModalRoute.of(context).settings.name;
    return Scaffold(
        appBar: AppBar(
          title: Text("Lista de personagens - busca"),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (character, index) {
                return ListTile(
                  title: ListCard(
                    character: characterList[index],
                  ),
                );
              },
              itemCount: characterList.length,
            ),
          ),
          // ),
        ),
        bottomNavigationBar: BottomNavigationBarComponent());
  }
}
