import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/event_model.dart';

class ApiService {
  final String apiKey;
  ApiService({required this.apiKey});

  Future<List<Event>> fetchEvents({String city = 'New York'}) async {
    final url = Uri.parse(
      'https://app.ticketmaster.com/discovery/v2/events.json?countryCode=US&size=20&city=$city&apikey=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final eventsJson = data['_embedded']?['events'] as List?;
      if (eventsJson == null) return [];
      return eventsJson.map((e) => Event.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}
