import 'package:deplace_maison/layout/loading.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/app_router.dart';

void main() => runApp(const MyApp());

/// Punto de entrada de la aplicacion.
/// Configura el router y envuelve la navegacion en el shell de carga.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Déplacé Maison',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      // El shell se aplica globalmente a todas las rutas.
      builder: (context, child) => _Shell(child: child!),
    );
  }
}

/// Shell global que bloquea la navegacion hasta que la pantalla
/// de carga haya terminado.
class _Shell extends StatefulWidget {
  final Widget child;
  const _Shell({required this.child});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  /// Indica si la pantalla de carga ya finalizo.
  bool _ready = false;

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      onComplete: () => setState(() => _ready = true),
      // Mientras no este listo, se muestra un widget vacio para
      // evitar que el contenido aparezca antes de tiempo.
      child: _ready ? widget.child : const SizedBox.shrink(),
    );
  }
}