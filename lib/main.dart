import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ValueNotifier<bool> isLoggedInState = ValueNotifier(false);

  GlobalKey<NavigatorState> navKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      home: Material(
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoggedInState,
          builder: (_, isLoggedIn, __) {
            if (isLoggedIn == false) {
              return Column(
                children: [
                  const TextField(key: ValueKey("username")),
                  const TextField(key: ValueKey("password"), obscureText: true),
                  OutlinedButton(
                    key:const ValueKey("signBtn"),
                    child: const Text("Sign in"),
                    onPressed: () => isLoggedInState.value = true,
                  ),
                ],
              );
            } else {
              return const Center(child: Text("Authorization Success!"));
            }
          },
        ),
      ),
    );
  }
}
