import 'package:http/http.dart' as http;
import 'dart:convert';
import './model/pizza.dart';

class HttpHelper {
  final String authority = 'zvrkq.wiremockapi.cloud';
  final String path = 'pizzalist/';

  Future<List<Pizza>> getPizzaList() async {
    final Uri url = Uri.https(authority, path);

    print("CALLING: $url");

    final http.Response result = await http.get(url);

    print("STATUS: ${result.statusCode}");
    print("BODY: ${result.body}");

    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);

      if (jsonResponse is! List) {
        throw Exception("Expected a JSON list");
      }

      return jsonResponse.map<Pizza>((i) => Pizza.fromJson(i)).toList();
    } else {
      return [];
    }
  }
}
