import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/api_bloc.dart';
import '../bloc/api_event.dart';
import '../bloc/api_state.dart';
import '../widgets/event_card.dart';

class EventsScreen extends StatelessWidget {
  EventsScreen({super.key});

  final TextEditingController _cityController = TextEditingController();
  final String defaultCity = 'New York';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Finder'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                hintText: 'Enter city',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final city = _cityController.text.trim();

                    // instead _fetchEvents()
                    context.read<ApiBloc>().add(FetchEvents(city: city));
                  },
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ),
      ),

      //instead FutureBuilder
      body: BlocBuilder<ApiBloc, ApiState>(
        builder: (context, state) {
          if (state is ApiLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ApiError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Error loading events'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ApiBloc>().add(
                        FetchEvents(city: defaultCity),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is ApiLoaded) {
            final events = state.events;

            if (events.isEmpty) {
              return const Center(child: Text('No events found'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<ApiBloc>().add(
                  FetchEvents(
                    city: _cityController.text.trim().isEmpty
                        ? defaultCity
                        : _cityController.text.trim(),
                  ),
                );
              },
              child: ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return EventCard(event: events[index]);
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
