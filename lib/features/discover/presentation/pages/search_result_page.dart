import 'package:dedalus/features/discover/presentation/blocs/search_bloc.dart';
import 'package:dedalus/features/discover/presentation/blocs/search_event.dart';
import 'package:dedalus/features/discover/presentation/blocs/search_state.dart';
import 'package:dedalus/features/discover/presentation/pages/hotel_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedalus/features/discover/presentation/widgets/hotel_card.dart';

class SearchResultsPage extends StatelessWidget {
  final String query;
  
  const SearchResultsPage({
    super.key,
    required this.query,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "$query"'),
        elevation: 0,
      ),
      body: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
        if (state is LoadingSearchState) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is LoadedSearchState) {
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: state.hotels.length,
            itemBuilder: (context, index) {
              final hotel = state.hotels[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HotelDetailPage(hotelId: hotel.id),
                      ),
                    );
                  },
                  child: HotelCard(hotel: hotel),
                ),
              );
            },
          );
        } else if (state is NoResultsSearchState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  'No results found for "${state.query}"',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Try using different keywords',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        } else if (state is ErrorSearchState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 80, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error: ${state.message}',
                  style: const TextStyle(fontSize: 18, color: Colors.red),
                ),
              ],
            ),
          );
        }

        // Inicia la búsqueda automáticamente al entrar a la página
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state is InitialSearchState) {
            context.read<SearchBloc>().add(SearchHotelsEvent(query: query));
          }
        });

        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
