import 'package:archo/widget/no_internet.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'controller/dio_retry.dart';
import 'provider/app_provider.dart';
import 'provider/connectivity_provider.dart';
import 'util/util.dart';
import 'view/home_page.dart';
import 'view/settings_page.dart';

void main() async {
  await Util.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider(context)),
        ChangeNotifierProvider(create: (context) => ConnectivityProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      dio.interceptors.addAll([
        dioCacheManager.interceptor,
        RetryOnConnectionChangeInterceptor(
          context,
          requestRetrier: DioConnectivityRequestRetry(
            dio: dio,
            connectivity: Connectivity(),
          ),
        ),
        RetryInterceptor(
            options: RetryOptions(
              retries: 3,
              retryInterval: const Duration(seconds: 5),
              retryEvaluator: (error) =>
                  error.type != DioErrorType.CANCEL &&
                  error.type != DioErrorType.RESPONSE,
            ),
            dio: dio)
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    //In case if you need something from app provider (i.e. Login Verification)
    var appProvider = Provider.of<AppProvider>(context, listen: false);

    return Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ValueListenableBuilder<Box>(
              valueListenable: Hive.box('theme_box').listenable(),
              builder: (context, box, child) => MaterialApp(
                title: 'Flutter Archo',
                debugShowCheckedModeBanner: false,
                navigatorKey: Get.key,
                navigatorObservers: [
                  GetObserver(MiddleWare.observer),
                ],
                theme: box.get("theme", defaultValue: "light") == "light"
                    ? Util.lightTheme
                    : Util.darkTheme,
                routes: {
                  HomePage.routeName: (context) => HomePage(),
                  SettingsPage.routeName: (context) => SettingsPage(),
                },
                onGenerateRoute: (settings) {
                  switch (settings.name) {
                    case HomePage.routeName:
                      return Util.platformRoute(
                          page: SettingsPage(), isDialog: true);
                      break;
                  }
                  return null;
                },
                initialRoute: HomePage.routeName,
              ),
            ),
            Consumer<ConnectivityProvider>(
                builder: (context, connectivity, _) =>
                    (connectivity.connectivityResult != null &&
                            connectivity.connectivityResult ==
                                ConnectivityResult.none)
                        ? NoInternetView()
                        : SizedBox())
          ],
        ));
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}
