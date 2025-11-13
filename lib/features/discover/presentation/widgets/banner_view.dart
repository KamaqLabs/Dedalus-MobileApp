import 'dart:ui';
import 'dart:math' as math;
import 'package:dedalus/features/discover/presentation/blocs/search_bloc.dart';
import 'package:dedalus/features/discover/presentation/blocs/search_event.dart';
import 'package:dedalus/features/discover/presentation/pages/search_result_page.dart';
import 'package:flutter/material.dart';
import 'package:dedalus/core/theme/color_palette.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannerView extends StatefulWidget {  // Cambiado a StatefulWidget
  final String userName;
  const BannerView({super.key, required this.userName});

  @override
  State<BannerView> createState() => _BannerViewState();
}

class _BannerViewState extends State<BannerView> with WidgetsBindingObserver {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController(); // Nuevo

  @override
  void initState() {
    super.initState();
    // Registrar observer para detectar cambios en el ciclo de vida
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // Asegurarse de que el focus node se disponga correctamente
    _searchFocusNode.dispose();
    _searchController.dispose(); // Importante para evitar memory leaks
    // Eliminar el observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Cuando la app pasa a segundo plano o se reactiva
    if (state == AppLifecycleState.inactive || 
        state == AppLifecycleState.paused) {
      _searchFocusNode.unfocus();
      _searchController.clear(); // Limpiar al salir de la app
    }
    super.didChangeAppLifecycleState(state);
  }

  // Nuevo método para forzar la pérdida de foco
  void _clearFocus() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
  }

  void _clearSearch() {
    _searchController.clear(); // Método para limpiar el texto
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Asegurarse de que el campo pierda el foco cuando cambien las dependencias
    _clearFocus();
    _clearSearch(); // Limpiar cuando cambian las dependencias
  }

  @override
  Widget build(BuildContext context) {
    // Verificar y quitar el foco cada vez que se construye el widget
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearFocus();
    });

    // Evitar overflow: altura responsiva y padding dinámico cuando aparece teclado
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double bannerHeight = math.min(250, screenHeight * 0.35);

    return GestureDetector(
      // Cerrar teclado al tocar fuera del campo
      onTap: () {
        _clearFocus();
      },
      child: AnimatedPadding(
        padding: EdgeInsets.only(bottom: bottomInset),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(36),
            bottomRight: Radius.circular(36),
          ),
          child: Container(
            height: bannerHeight, // altura responsiva
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/banner-machu-picchu.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.place, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Lima, Peru",
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white24,
                            child: Icon(Icons.person, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Flexible(
                        child: Text(
                          "Hey, ${widget.userName}!\nTell us where you want to go",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(48.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                            color: Colors.white.withOpacity(0.2),
                            child: Row(
                              children: [
                                const Icon(Icons.search, color: Colors.white),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    focusNode: _searchFocusNode,
                                    controller: _searchController, // Asignar el controller
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                    cursorColor: ColorPalette.primaryColor,
                                    autofocus: false,
                                    textInputAction: TextInputAction.search,
                                    enableInteractiveSelection: true,
                                    decoration: const InputDecoration(
                                      hintText: "Search places",
                                      hintStyle: TextStyle(color: Colors.white70),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                                      isCollapsed: true,
                                    ),
                                    onSubmitted: (query) {
                                      if (query.isNotEmpty) {
                                        // Importante: Cerrar teclado primero
                                        _searchFocusNode.unfocus();

                                        // Breve delay para permitir que el teclado se cierre completamente
                                        Future.delayed(const Duration(milliseconds: 100), () {
                                          // Primero actualizar el bloc de búsqueda
                                          context.read<SearchBloc>().add(SearchHotelsEvent(query: query));

                                          // Luego navegar a la página de resultados
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SearchResultsPage(query: query),
                                            ),
                                          ).then((_) {
                                            // Limpiar el texto cuando regresamos de la página de resultados
                                            _clearSearch();
                                          });
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
