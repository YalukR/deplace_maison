import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deplace_maison/layout/layout.dart';
import 'package:deplace_maison/pages/home.dart';

/// Configuracion central de navegacion con go_router.
/// Por ahora define una unica ruta raiz que carga la pagina principal
/// envuelta en el layout global.
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Layout(child: HomePage()),
    ),
  ],
);