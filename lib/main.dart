import 'package:dimipay_app_v2/app/core/utils/loader.dart';
import 'package:dimipay_app_v2/app/routes/pages.dart';
import 'package:dimipay_app_v2/app/routes/routes.dart';
import 'package:dimipay_app_v2/app/services/theme/service.dart';
import 'package:dimipay_design_kit/dimipay_design_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

String getInintialRoute({bool debug = false}) {
  return debug ? Routes.TEST : Routes.HOME;
}

void main() async {
  await AppLoader().load();
  runApp(
    Obx(
      () {
        DPLightTheme lightTheme = DPLightTheme();
        DPDarkTheme darkTheme = DPDarkTheme();
        ThemeService themeService = Get.find<ThemeService>();
        return GetMaterialApp(
            title: '디미페이',
            initialRoute: getInintialRoute(debug: true),
            getPages: AppPages.pages,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'SUITv1',
              brightness: Brightness.light,
              appBarTheme: AppBarTheme(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarIconBrightness: Brightness.dark,
                  statusBarColor: Colors.transparent,
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                titleSpacing: 0,
                foregroundColor: lightTheme.colors.grayscale1000,
                centerTitle: false,
              ),
              textSelectionTheme: TextSelectionThemeData(selectionColor: lightTheme.colors.primaryBrand.withAlpha(100), selectionHandleColor: lightTheme.colors.primaryBrand),
              cupertinoOverrideTheme: CupertinoThemeData(primaryColor: lightTheme.colors.primaryBrand),
              scaffoldBackgroundColor: lightTheme.colors.grayscale100,
              extensions: [lightTheme.colors, lightTheme.textStyle],
              cardColor: lightTheme.colors.grayscale100,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              fontFamily: 'SUITv1',
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                titleSpacing: 0,
                foregroundColor: darkTheme.colors.grayscale1000,
                centerTitle: false,
              ),
              textSelectionTheme: TextSelectionThemeData(selectionColor: darkTheme.colors.primaryBrand.withAlpha(100), selectionHandleColor: lightTheme.colors.primaryBrand),
              cupertinoOverrideTheme: CupertinoThemeData(primaryColor: darkTheme.colors.primaryBrand),
              scaffoldBackgroundColor: darkTheme.colors.grayscale100,
              extensions: [darkTheme.colors, darkTheme.textStyle],
              cardColor: darkTheme.colors.grayscale100,
            ),
            themeMode: themeService.themeMode);
      },
    ),
  );
}
