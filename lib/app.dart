import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/colors.dart';
import 'core/router/app_router.dart';

class GeezApp extends ConsumerWidget {
  const GeezApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Geez AI',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: ThemeMode.system,
    );
  }

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: GeezColors.primary,
        secondary: GeezColors.secondary,
        surface: GeezColors.surface,
        error: GeezColors.error,
      ),
      scaffoldBackgroundColor: GeezColors.background,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.light().textTheme,
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: GeezColors.primary,
        secondary: GeezColors.secondary,
        surface: GeezColors.surfaceDark,
        error: GeezColors.error,
      ),
      scaffoldBackgroundColor: GeezColors.backgroundDark,
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ),
    );
  }
}
