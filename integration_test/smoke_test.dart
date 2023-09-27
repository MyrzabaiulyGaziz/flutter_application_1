import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  testWidgets('Smoke test', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    final Finder username = find.byKey(const ValueKey('username'));
    final Finder password = find.byKey(const ValueKey('password'));
    expect(username, findsOneWidget);
    expect(password, findsOneWidget);

    await tester.enterText(username, 'gaziz@test.com');
    await tester.enterText(password, 'password');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    final Finder signBtn = find.byKey(const ValueKey('signBtn'));
    await tester.tap(signBtn, warnIfMissed: true);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    MyAppState state = tester.state(find.byType(MyApp));
    expect(state.isLoggedInState.value, true);

    NavigatorState navigator = state.navKey.currentState!;
    showDialog(
      context: navigator.context,
      builder: (c) => _SomeDialog(),
    );
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 1));

    navigator.pop();
    await tester.pumpAndSettle();

    expect(find.byWidget(_SomeDialog()), findsNothing);

    showDialog(context: navigator.context, builder: (context) => _SomeDialog());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('okBtn')));
    await tester.pumpAndSettle();

    expect(find.byType(_SomeDialog), findsNothing);

    expect(SchedulerBinding.instance.transientCallbackCount, 0);

    await tester.pump(const Duration(seconds: 2));
  });
}

class _SomeDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        OutlinedButton(
          key:const ValueKey("okBtn"),
          onPressed: () => Navigator.pop(context),
          child:const Text("Ok"),
        ),
      ],
    );
  }
}
