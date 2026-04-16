import '../models/event_model.dart';

abstract class ApiState {}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final List<Event> events;

  ApiLoaded(this.events);
}

class ApiError extends ApiState {
  final String message;

  ApiError(this.message);
}
