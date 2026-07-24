import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_presets.dart';
import 'domain/use_case/bootstrap/bootstrap_use_case.dart';
import 'injection.dart';
import 'presentation/features/theme/provider/theme_provider.dart';
import 'presentation/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  configureDependencies();

  // Bootstrap the application (insert default templates if db is empty)
  await getIt<BootstrapUseCase>().call();

  runApp(
    const ProviderScope(
      child: FictionistApp(),
    ),
  );
}

class FictionistApp extends ConsumerWidget {
  const FictionistApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeAsync = ref.watch(themeNotifierProvider);
    final router = buildAppRouter(ref);

    return themeAsync.when(
      data: (config) => MaterialApp.router(
        title: 'Fictionist',
        theme: AppTheme.build(config),
        themeMode: config.themeMode,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
      loading: () => MaterialApp.router(
        title: 'Fictionist',
        theme: AppTheme.build(ThemePresets.grimoire),
        themeMode: ThemeMode.dark,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
      error: (_, __) => MaterialApp.router(
        title: 'Fictionist',
        theme: AppTheme.build(ThemePresets.grimoire),
        themeMode: ThemeMode.dark,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
