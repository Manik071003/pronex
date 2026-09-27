import 'package:pronex/presentations/splash/splash_view_model.dart';
import 'package:flutter/material.dart';
import '../../core/constants/image_constants.dart';
import '../../core/utils/base_view.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView.reactive(
      viewModelBuilder: () => SplashViewModel(),
      onViewModelReady: (vm) => vm.initMethod(),
      builder: (__, viewModel, _) {
        return Scaffold(
          body: Center(
            child: SizedBox(
              width: 512,
              height: 512,
              child: Image.asset(
                ImageConstants.splashImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
