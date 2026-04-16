import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/api_service.dart';
import 'api_event.dart';
import 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final ApiService apiService;

  ApiBloc(this.apiService) : super(ApiLoading()) {
    on<FetchEvents>((event, emit) async {
      emit(ApiLoading());

      try {
        final events = await apiService.fetchEvents(city: event.city);

        emit(ApiLoaded(events));
      } catch (e) {
        emit(ApiError(e.toString()));
      }
    });
  }
}
