import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/login_page.dart';
import '../pages/chat_page.dart';
import '../pages/settings_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) => const ChatPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => Container()//SettingsPage(),
    ),
  ],
);