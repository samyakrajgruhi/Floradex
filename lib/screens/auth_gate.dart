import 'package:floradex/screens/auth_screen.dart';
import 'package:floradex/screens/onboarding_screen.dart';
import 'package:floradex/services/achievement_event_bus_scope.dart';
import 'package:floradex/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class AuthGate extends StatelessWidget {
  AuthGate({super.key});

  final needOnboarding = currentUser.userName == 'Unknown User';
  
  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder(stream: authService.authStateChanges, builder: (context,snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      if(!snapshot.hasData){
        return const AuthScreen();
      }

      return AchievementEventBusScope(child: needOnboarding ? const OnboardingScreen() : const MainScreen());
    });
  }
}
