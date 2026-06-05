import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:deplace_maison/layout/layout.dart';
import 'package:deplace_maison/pages/home.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Layout(child: HomePage()),
    ),
  ],
);
