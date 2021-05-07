import 'dart:convert';
import 'package:flutter_training/app/components/BottomNavigationBarComponent.dart';
import 'package:flutter_training/app/components/ListCard.dart';
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
TextEditingController _nameController = TextEditingController();

class _SearchPageState extends State<SearchPage> {
  String nextUrl = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future filterCharacterFromAPI(name) async {
    var url = "https://rickandmortyapi.com/api/character/?name=$name";
    var response = await http.get(Uri.parse(url));
    var jsonArray = jsonDecode(response.body)['results'];

    var modelList = await jsonArray
        .map((json) => Character.fromJson(json))
        .toList()
        .cast<Character>();

    setState(() {
      characterList = modelList;
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
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a search term',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              filterCharacterFromAPI(_nameController.text);
                            },
                            icon: Icon(Icons.search),
                            label: Text("Buscar"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height - 280,
                child: ListView.builder(
                  itemBuilder: (character, index) {
                    return ListTile(
                        title: ListCard(
                      character: characterList[index],
                    ));
                  },
                  itemCount: characterList.length,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBarComponent());
  }
}
