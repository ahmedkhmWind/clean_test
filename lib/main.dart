import 'package:clean_flutter_poc/features/auth/login/presenters/bloc/auth_bloc.dart';
import 'package:clean_flutter_poc/features/auth/login/presenters/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/injection.dart' as di;

void main() {
  di.init();
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<AuthBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Clean POC',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: LoginPage(),
      ),
    );
  }
  }