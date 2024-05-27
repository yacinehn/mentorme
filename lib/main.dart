import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mentorme/auth/LogInPage.dart';
import 'package:mentorme/auth/auth_state.dart';
import 'package:mentorme/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        // Add more providers here if needed
      ],
      child: Consumer<AuthState>(builder: (context, appState, _) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Provider.of<AuthState>(context, listen: false)
                .getPage() // Use getPage from AuthState
            );
      }),
    );
  }
}
