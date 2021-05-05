import 'package:flutter_training/app/models/character_model.dart';

class Location {
  int id;
  String name;
  String type;
  String dimension;
  List<Character> residents;
  String url;
  String created;

  Location(
      {this.id,
      this.name,
      this.type,
      this.dimension,
      this.residents,
      this.url,
      this.created});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    type = json['type'];
    dimension = json['dimension'];
    residents = json['residents'].cast<Character>();
    url = json['url'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['type'] = this.type;
    data['dimension'] = this.dimension;
    data['residents'] = this.residents;
    data['url'] = this.url;
    data['created'] = this.created;
    return data;
  }
}
