import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geez_ai/core/theme/theme.dart';
import 'package:geez_ai/core/router/app_router.dart';

class GeezApp extends ConsumerWidget {
  const GeezApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Geez AI',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: GeezTheme.lightTheme,
      darkTheme: GeezTheme.darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}
