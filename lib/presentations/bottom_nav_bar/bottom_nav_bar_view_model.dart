
import 'package:flutter/material.dart';
import '../../core/models/base_view_model.dart';
import '../explore/explore_view.dart';
import '../home/home_view.dart';
import '../portfolio/portfolio_view.dart';
import '../saved/saved_view.dart';
import '../profile/profile_view.dart';

class NavItem {
  final Widget Function() screenBuilder;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final String label;

  NavItem({
    required this.screenBuilder,
    required this.selectedIcon,
    required this.unselectedIcon,
    required this.label,
  });
}

class BottomNavBarVM extends BaseViewModel {
  int index = 0;

  late final List<NavItem> navItems;

  BottomNavBarVM() {
    navItems = [
      NavItem(
        screenBuilder: () => const HomeView(),
        selectedIcon: Icons.home_rounded,
        unselectedIcon: Icons.home_outlined,
        label: 'Home',
      ),
      NavItem(
        screenBuilder: () => const ExploreView(),
        selectedIcon: Icons.explore_rounded,
        unselectedIcon: Icons.explore_outlined,
        label: 'Explore',
      ),
      NavItem(
        screenBuilder: () => PortfolioView(
          onExploreMoreProperties: () => navigate(1),
        ),
        selectedIcon: Icons.pie_chart_rounded,
        unselectedIcon: Icons.pie_chart_outline_rounded,
        label: 'Portfolio',
      ),
      NavItem(
        screenBuilder: () => const SavedView(),
        selectedIcon: Icons.credit_card_rounded,
        unselectedIcon: Icons.credit_card_outlined,
        label: 'Saved',
      ),
      NavItem(
        screenBuilder: () => ProfileView(onOpenSaved: () => navigate(3)),
        selectedIcon: Icons.person_rounded,
        unselectedIcon: Icons.person_outline_rounded,
        label: 'Profile',
      ),
    ];
  }

  void navigate(int newIndex) {
    if (newIndex >= navItems.length) return;
    index = newIndex;
    notifyListeners();
  }
}
