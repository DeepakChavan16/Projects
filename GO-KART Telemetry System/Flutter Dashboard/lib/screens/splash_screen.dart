import 'dart:async';

import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'mobile_dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ResponsiveDashboard(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D10),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // FKDC LOGO
            Image.asset(
              'assets/images/fkdc_logo.png',
              width: 190,
              height: 190,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 32),

            // WELCOME TEXT
            const Text(
              'Welcome to Dashboard',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 12),

            // DESIGNER CREDIT
            const Text(
              'Design by Dynamic Booster 8.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.cyan,
                fontSize: 15,
                fontWeight: FontWeight.w500,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 35),

            // LOADING BAR
            const SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                minHeight: 3,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.cyan,
                ),
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Initializing...',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResponsiveDashboard extends StatelessWidget {
  const ResponsiveDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return const MobileDashboardScreen();
        }

        return const DashboardScreen();
      },
    );
  }
}