import "package:cash_flow/core/theme/app_theme.dart";
import "package:cash_flow/core/values/strings.dart";
import "package:cash_flow/routes/app_pages.dart";
import "package:cash_flow/routes/app_routes.dart";
import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:get/get.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: titleApplication,
      debugShowCheckedModeBanner: false,
      theme: CustomThemeData.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("pt", "BR")],
      getPages: AppPage.routes,
      initialRoute: Routes.LOGIN,
    );
  }
}
