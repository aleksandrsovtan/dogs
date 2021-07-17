import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_IMAGES = 'CACHED_IMAGES';

const dogImageApi = 'https://dog.ceo/api/breeds/image/random/10';
const dogInfoApi = 'https://api-dog-breeds.herokuapp.com/api/search?q=';

Future<DogInfo?> getDogInfo(String breed) async {
  final response = await get(Uri.parse(dogInfoApi + breed));

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    List<DogInfo>? dogs = data.length > 0
        ? data
            .map((dog) => DogInfo(
                breedName: dog['breedName'],
                image: dog['image'],
                description: dog['description']))
            .toList()
        : null;

    if (dogs == null) return null;
    final DogInfo dog = dogs.firstWhere(
      (dog) => dog.breedName == breed,
      orElse: () => DogInfo(
        breedName: '',
        image: '',
        description: '',
      ),
    );
    return dog.breedName == '' ? null : dog;
  } else {
    print(response);
    return null;
  }
}

class DogInfo {
  String breedName;
  String image;
  String description;

  DogInfo({
    required this.breedName,
    required this.image,
    required this.description,
  });
}

Future<List<String>> loadImages() async {
  final sharedPreference = await SharedPreferences.getInstance();
  try {
    var response = await get(Uri.parse(dogImageApi));

    if (response.statusCode == 200) {
      dynamic data = json.decode(response.body);

      List<String> list = List<String>.from(data['message']);

      sharedPreference.setStringList(CACHED_IMAGES, list);

      return list;
    } else {
      return [];
    }
  } on SocketException {
    final cachedData = sharedPreference.getStringList(CACHED_IMAGES);
    if (cachedData == null) {
      return [];
    }

    return Future.value(cachedData);
  } catch (error) {
    return [];
  }
}
