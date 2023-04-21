import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'pages/login_page.dart';
import 'providers/list_image_provider.dart';
import 'providers/list_flavor_provider.dart';
import 'providers/list_security_group_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ListImageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ListFlavorProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ListSecurityGroupProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.light,
            ),
          ),
        ),
        home: new LoginPage(),
        debugShowCheckedModeBanner: false,
      )));
}
