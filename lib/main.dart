// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smsq/Screens/Chat/bloc/chat_bloc.dart';
import 'package:smsq/Screens/Home.dart';
import 'package:smsq/Screens/LoginScreen.dart';
import 'package:smsq/Services/bloc/emojiopen_bloc.dart';
import 'package:smsq/Services/bloc/localdata_bloc.dart';
import 'package:smsq/firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString('X-token');
  runApp(MyApp(
    initialRoute: token == null ? '/login' : '/home',
    prefs: prefs,
  ));
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  SharedPreferences prefs;
  final String initialRoute;
  MyApp({
    super.key,
    required this.prefs,
    required this.initialRoute,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => EmojiopenBloc()),
        BlocProvider(create: (context) => LocaldataBloc()),
      ],
      child: MaterialApp(
        title: 'Chat-App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xff0c1014)),
          scaffoldBackgroundColor: const Color(0xff0c1014),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        initialRoute: initialRoute,
        routes: {
          '/login': (context) => const Loginscreen(),
          '/home': (context) => HomeScreen(
                prefs: prefs,
              ),
        },
      ),
    );
  }
}
