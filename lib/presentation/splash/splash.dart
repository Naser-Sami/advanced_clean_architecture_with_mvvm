import 'dart:async';

import 'package:advanced_clean_architecture_with_mvvm/app/app_prefs.dart';
import 'package:advanced_clean_architecture_with_mvvm/app/di.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/assets_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/color_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/constants_manager.dart';
import 'package:flutter/material.dart';

import '../resources/routes_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay() {
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), _goNext);
  }

  _goNext() async {
    _appPreferences.isUserLoggedIn().then(
          (value) => {
            if (value)
              {
                // .. navigate to main screen (user is already logged in)
                Navigator.pushReplacementNamed(context, Routes.mainRoute)
              }
            else
              {
                _appPreferences.isOnboardingScreenViewed().then(
                      (value) => {
                        if (value)
                          {
                            // .. navigate to login screen
                            Navigator.pushReplacementNamed(
                                context, Routes.loginRoute)
                          }
                        else
                          {
                            // .. start application for the first time
                            Navigator.pushReplacementNamed(
                                context, Routes.onboardingRoute)
                          }
                      },
                    ),
              }
          },
        );
  }

  @override
  void initState() {
    _startDelay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body:
          const Center(child: Image(image: AssetImage(ImageAssets.splashLogo))),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
