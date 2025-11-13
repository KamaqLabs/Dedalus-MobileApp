import 'package:dedalus/features/discover/presentation/blocs/hotel_bloc.dart';
import 'package:dedalus/features/discover/presentation/blocs/hotel_event.dart';
import 'package:dedalus/features/discover/presentation/blocs/hotel_state.dart';
import 'package:flutter/material.dart';
import 'package:dedalus/core/theme/color_palette.dart';
import 'package:dedalus/features/discover/presentation/widgets/banner_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dedalus/features/discover/presentation/pages/hotel_see_all_page.dart';
import 'package:dedalus/features/discover/data/models/card_type.dart';
import 'package:dedalus/features/discover/presentation/widgets/hotel_list_view_horizontal.dart';
import 'package:dedalus/features/discover/presentation/widgets/hotel_list_view_vertical.dart';

class DiscoverPage extends StatefulWidget {
  final String userName;
  const DiscoverPage({super.key, required this.userName});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> with RouteAware {
  RouteObserver<PageRoute>? _routeObserver;

  @override
  void initState() {
    super.initState();
    context.read<HotelBloc>().add(GetHotels());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver = RouteObserver<PageRoute>();
    _routeObserver?.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    FocusScope.of(context).unfocus();
    super.didPopNext();
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerView(userName: widget.userName),

            // Hotels Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Hotels",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  BlocBuilder<HotelBloc, HotelState>(
                    builder: (context, state) {
                      if (state is LoadedHotelState) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HotelSeeAllPage(
                                  hotels: state.hotels,
                                  cardType: CardType.vertical,
                                  title: "All Hotels",
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "See All",
                            style: TextStyle(
                              color: ColorPalette.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            // Horizontal preview (first 3 hotels)
            SizedBox(
              height: 165,
              child: BlocBuilder<HotelBloc, HotelState>(
                builder: (context, state) {
                  if (state is LoadingHotelState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadedHotelState) {
                    final hotels = state.hotels.take(3).toList();
                    if (hotels.isEmpty) {
                      return const Center(child: Text('No hotels available.'));
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: HotelListViewHorizontal(hotels: hotels),
                    );
                  } else if (state is FailureHotelState) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Vertical list with all hotels
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: BlocBuilder<HotelBloc, HotelState>(
                builder: (context, state) {
                  if (state is LoadingHotelState) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadedHotelState) {
                    final hotels = state.hotels;
                    if (hotels.isEmpty) {
                      return const Center(child: Text('No hotels available.'));
                    }
                    return HotelListViewVertical(hotels: hotels);
                  } else if (state is FailureHotelState) {
                    return Center(child: Text(state.errorMessage));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
