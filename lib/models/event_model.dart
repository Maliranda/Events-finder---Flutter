class Event {
  final String name;
  final String date;
  final String venue;
  final String? imageUrl;

  Event({
    required this.name,
    required this.date,
    required this.venue,
    this.imageUrl,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    if (json['images'] != null) {
      final images = json['images'] as List;
      imageUrl = images.firstWhere(
        (img) => img['width'] > 500,
        orElse: () => images[0],
      )['url'];
    }

    return Event(
      name: json['name'] ?? 'No title',
      date: json['dates']['start']['localDate'] ?? 'No date',
      venue: json['_embedded']?['venues']?[0]?['name'] ?? 'No venue',
      imageUrl: imageUrl,
    );
  }
}
