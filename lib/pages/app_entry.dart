import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/common_widgets.dart';
import 'main_shell.dart';
import 'onboarding_page.dart';

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppStateScope.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
                  .animate(animation),
          child: child,
        ),
      ),
      child: state.onboardingComplete
          ? const MainShell(key: ValueKey('shell'))
          : const AppBackdrop(
              key: ValueKey('onboarding'),
              child: OnboardingPage(),
            ),
    );
  }
}
