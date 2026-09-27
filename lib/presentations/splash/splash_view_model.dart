import 'package:stacked/stacked.dart';
import '../../core/constants/shared_prefs_constants.dart';
import '../../core/enums/response_state_enum.dart';
import '../../core/helper/helper_imports.dart';
import '../../core/utils/view_state.dart';
import '../bottom_nav_bar/bottom_nav_bar.dart';
import '../onboarding/onboarding_view.dart';


class SplashViewModel extends BaseViewModel {
  ViewState<dynamic> viewState = ViewState(state: ResponseState.empty);

  bool? isQuestionnaireCompleted;
  bool isLoggedIn = false;
  List<dynamic> interests = [];


  Future<void> initMethod() async {
    await Future.delayed(const Duration(milliseconds: 350));

    final isLoggedIn = await SharedPrefHelper.getBool(SharedPrefs.isLoggedIn);
    final token = await SharedPrefHelper.getString(SharedPrefs.token);

    if (isLoggedIn && token != null && token.isNotEmpty) {
      RoutingHelper.pushAndRemoveUntilToScreen(screen: BottomNavBarView());
    } else {
      RoutingHelper.pushAndRemoveUntilToScreen(screen: OnboardingView());
    }
  }

}

