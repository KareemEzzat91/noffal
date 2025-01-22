import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noffal/BlocHelper/home_cubit.dart';
import 'package:noffal/HomeScreen/HomeScreen.dart';

import 'ApiHelper/Apihelper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Apihelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) {
       return HomeCubit();
      },
      child: const MaterialApp(
        title: 'Flutter Demo',
        home: Homescreen(),

      ),
    );
  }
}

