import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseURL = 'http://192.168.3.21:8000';

Future<double> getConsumption() async {
  final url = Uri.parse('$baseURL/consumption/heater/?amt=1');
  final response = await http.get(url, headers: {"Accept": "application/json"});
  final Map<String, dynamic> data = json.decode(response.body);

  return data["consumption"][0];
}

Future<double> getShowerConsumption() async {
  final url = Uri.parse('$baseURL/consumption/shower/?amt=1');
  final response = await http.get(url, headers: {"Accept": "application/json"});
  final Map<String, dynamic> data = json.decode(response.body);

  return data["consumption"][0];
}
