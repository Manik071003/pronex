import 'package:google_fonts/google_fonts.dart';
import 'package:pronex/presentations/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/color_constants.dart';
import 'core/constants/dimension_constants.dart';
import 'core/di/injector.dart';
import 'dart:io' as io;




Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDependencies();
  io.HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());


  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // HttpOverrides.global = MyHttpOverrides();

}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: ColorConstants.primaryAppColor,
      navigatorKey: AppConstants.globalNavKey,
      debugShowCheckedModeBanner: false,
      title: 'Love Today',
      builder: (context, child) {
        return EasyLoading.init()(
          context,
          SafeArea(
            child: child ?? const SizedBox(),
          ),
        );
      },

      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
        textTheme: GoogleFonts.interTextTheme(),
        primaryTextTheme: GoogleFonts.interTextTheme(),
        progressIndicatorTheme:ProgressIndicatorThemeData(color:ColorConstants.primaryAppColor) ,
        primaryColor: ColorConstants.primaryAppColor,
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.px14),
            borderSide: BorderSide(
              color: ColorConstants.primaryAppColor,
              width: 1.5,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.px14),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
              width: Dimensions.px1,
            ),
          ),
        ),
      ),

      home: const SplashView(),
      // home:  FilterView(),
    );
  }
}


class MyHttpOverrides extends io.HttpOverrides {
  @override
  io.HttpClient createHttpClient(io.SecurityContext? context) {
    final client = super.createHttpClient(context);

    client.badCertificateCallback =
        (io.X509Certificate cert, String host, int port) => true;

    return client;
  }
}





