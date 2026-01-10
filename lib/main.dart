import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:niezapominapka/features/auth/LoginScreen.dart';
import 'package:niezapominapka/shopRadar/geofence_provider.dart'; // Upewnij się, że ścieżka jest dobra

import 'theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // ProviderScope musi być TUTAJ, aby wewnątrz NiezapominapkaApp działał "ref"
  runApp(const ProviderScope(child: NiezapominapkaApp()));
}

// Zmieniamy StatelessWidget na ConsumerStatefulWidget
class NiezapominapkaApp extends ConsumerStatefulWidget {
  const NiezapominapkaApp({super.key});

  @override
  ConsumerState<NiezapominapkaApp> createState() => _NiezapominapkaAppState();
}

class _NiezapominapkaAppState extends ConsumerState<NiezapominapkaApp> {

  @override
  void initState() {
    super.initState();

    // To jest ten "magiczny moment".
    // Wywołujemy to RAZ przy starcie całej aplikacji.
    // Dzięki temu konstruktor GeofenceLogic się odpala i rejestruje listenery
    // nawet jeśli użytkownik jeszcze się nie zalogował.

    // addPostFrameCallback jest bezpieczniejszy, bo mamy pewność, że widget tree jest gotowe
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final geofenceLogic = ref.read(geofenceServiceProvider);
      debugPrint("🚀 Geofence Provider zainicjowany w NiezapominapkaApp");
      
      // Automatycznie uruchom monitoring przy starcie aplikacji
      await geofenceLogic.startMonitoring();
    });
  }

  @override
  Widget build(BuildContext context) {
    // WithForegroundTask jest WYMAGANY dla flutter_foreground_task
    // Pozwala na prawidłowe działanie w tle
    return WithForegroundTask(
      child: MaterialApp(
        title: 'Niezapominapka',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const LoginScreen(),
      ),
    );
  }
}