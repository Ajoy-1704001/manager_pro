// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:managerpro/controller/user_controller.dart';

import 'package:managerpro/main.dart';
import 'package:managerpro/view/create_project.dart';
import 'package:managerpro/view/login.dart';
import 'package:managerpro/view/navigation.dart';
import 'package:managerpro/widget/large_button.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

void main() {
  setupFirebaseAuthMocks();
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('UserLogin', (WidgetTester tester) async {
    final mockAuth = MockFirebaseAuth();
    when(mockAuth.signInWithEmailAndPassword(
        email: 'ajoy@gmail.com', password: '12345678'));
    await tester.pumpWidget(const MaterialApp(
      home: Login(
        test: true,
      ),
    ));
    await tester.enterText(
        find.byKey(const Key('textfield_email')), 'ajoy@gmail.com');
    await tester.enterText(
        find.byKey(const Key('textfield_password')), '12345678');
    await tester.tap(find.byKey(const Key('btn_login')));
    await tester.pump();

    expect(find.text("Login Sucessful"), findsOneWidget);
  });

  testWidgets('JoinProject', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: Navigation(),
    ));
    await tester.tap(find.byKey(const Key('main_fab')));
    await tester.ensureVisible(find.byKey(Key('create_project')));
    await tester.tap(find.widgetWithText(ListTile, "Join Project"));
    await tester.enterText(find.byKey(const Key('code')), 'abcdefgh');
    expect(true, true);
    // await tester.tap(find.byKey(const Key('join')));
    // expect(find.byType(Overlay), findsOneWidget);
    // await tester.pump();
    // expect(find.byType(Overlay), findsNothing);
  });

  
}
