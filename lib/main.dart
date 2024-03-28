import 'package:circularmallbc/Auth/LoginScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/CustomerHomeScreen.dart';
import 'package:circularmallbc/Customers/MainScreen/HomeScreen.dart';
import 'package:circularmallbc/Model/Auth_Models/login_page_model.dart';
import 'package:circularmallbc/Providers/Cart_Provider.dart';
import 'package:circularmallbc/Providers/wishlist_provider.dart';
import 'package:circularmallbc/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) {
        return Cart();
      }),
      ChangeNotifierProvider(create: (_) {
        return WishList();
      }),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Kanit-Bold",
        primarySwatch: Colors.blue,
      ),
      initialRoute: CustomHomeScreen.routeName,
      routes: {
        CustomHomeScreen.routeName: (context) => CustomHomeScreen(),
        LoginPageWidget.routeName: (context) => LoginPageWidget(),
        HomeScreen.routeName: (context) => HomeScreen(),
        
      },
    );
  }
}
