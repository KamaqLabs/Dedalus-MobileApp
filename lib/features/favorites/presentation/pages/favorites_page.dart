import 'package:dedalus/features/favorites/presentation/blocs/favorite_bloc.dart';
import 'package:dedalus/features/favorites/presentation/blocs/favorite_event.dart';
import 'package:dedalus/features/favorites/presentation/blocs/favorite_state.dart';
import 'package:dedalus/features/favorites/presentation/widgets/favorite_hotels_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with RouteAware, WidgetsBindingObserver {
  RouteObserver<PageRoute>? _routeObserver;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Carga los favoritos al iniciar la página
    context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Obtener el RouteObserver del MaterialApp
    _routeObserver = RouteObserver<PageRoute>();
    
    // Registrar esta página con el observador
    _routeObserver?.subscribe(this, ModalRoute.of(context) as PageRoute);
    
    // Recargar los favoritos cuando las dependencias cambian
    context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
  }
  
  @override
  void didPopNext() {
    // Se activa cuando regresamos a esta página (después de un Navigator.pop)
    context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
    super.didPopNext();
  }
  
  @override
  void didPushNext() {
    // Se activa cuando se navega a otra página desde esta
    super.didPushNext();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Recargar cuando la app vuelve a primer plano
      if (mounted) context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
    }
    super.didChangeAppLifecycleState(state);
  }
  
  @override
  void dispose() {
    // Desuscribir para evitar memory leaks
    _routeObserver?.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Hotels'),
        elevation: 0,
      ),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(
        builder: (context, state) {
          if (state is LoadingFavoriteState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedFavoriteState) {
            return FavoriteHotelsList(hotels: state.favorites);
          } else if (state is ErrorFavoriteState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${state.message}",
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoriteBloc>().add(GetAllFavoriteEvent());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text("No data available"),
          );
        },
      ),
    );
  }
}
