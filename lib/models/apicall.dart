import 'dart:convert';

import 'package:http/http.dart';

import 'Topics.dart';

class ApiCall{
  Future<List<Topic>> getTopicsFromApi() async {
    Response response = await get(
        Uri.parse(
          "https://utkwwq6r95.execute-api.us-east-1.amazonaws.com/assignment/topics",
        ),
        headers: {
          "userid": "25794905-2dd4-40bd-97b9-9d5d69294b86",
          "token": "d61036c6-5ffd-4964-b7ff-8d5ba8ca0262"
        });

    if (response.statusCode == 200) {

      List<Map> data =[];

        List fetched_data = jsonDecode(response.body);
        data = fetched_data.cast<Map>();
      return Topic.topicJsonToList(data);
    }
    else {

      throw Exception(response.reasonPhrase);
    }
  }
}
