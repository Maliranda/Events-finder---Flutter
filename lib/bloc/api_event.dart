abstract class ApiEvent {}

class FetchEvents extends ApiEvent {
  final String city;

  FetchEvents({this.city = 'New York'});
}
