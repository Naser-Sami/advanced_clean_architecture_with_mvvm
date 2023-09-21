import 'package:advanced_clean_architecture_with_mvvm/app/di.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/forgot_password/view/forgot_password.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/login/view/login.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/main/main.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/onboarding/view/onboarding_view.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/register/view/register.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/resources/strings_manager.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/splash/splash.dart';
import 'package:advanced_clean_architecture_with_mvvm/presentation/store_details/store_details.dart';
import 'package:flutter/material.dart';

class Routes {
  static const String splashRoute = "/";
  static const String registerRoute = "/register";
  static const String loginRoute = "/login";
  static const String onboardingRoute = "/onboarding";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RoutesGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (context) => const SplashView());

      case Routes.registerRoute:
        initRegisterModule();
        return MaterialPageRoute(builder: (context) => const RegisterView());

      case Routes.loginRoute:
        initLoginModule();
        return MaterialPageRoute(builder: (context) => const LoginView());

      case Routes.onboardingRoute:
        return MaterialPageRoute(builder: (context) => const OnboardingView());

      case Routes.forgotPasswordRoute:
        initForgotPasswordModule();
        return MaterialPageRoute(
            builder: (context) => const ForgotPasswordView());

      case Routes.mainRoute:
        return MaterialPageRoute(builder: (context) => const MainView());

      case Routes.storeDetailsRoute:
        return MaterialPageRoute(
            builder: (context) => const StoreDetailsView());

      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: ((context) => const Scaffold(
            body: Center(child: Text(AppStrings.noRouteFound)),
          )),
    );
  }
}
