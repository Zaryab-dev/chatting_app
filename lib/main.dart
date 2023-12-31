import 'package:chatting_app/firebase_options.dart';
import 'package:chatting_app/pages/auth/controller/auth_controller.dart';
import 'package:chatting_app/pages/auth/landing_page/landing_page.dart';
import 'package:chatting_app/route/routes.dart';
import 'package:chatting_app/screens/mobile_layout_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Common/error.dart';
import 'colors.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: backgroundColor,
            // color: appBarColor
          )
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: ref.watch(userDataAuthProvider).when(data: (user) {
        if(user == null) {
          return LandingPage();
        }
        return MobileLayoutScreen();
      }, error: (err, trace) {
        return ErrorScreen(error: err.toString());
      }, loading: () => Center(child: CircularProgressIndicator(),)),
    );
  }
}
