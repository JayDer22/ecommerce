import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce/bloc/product_bloc.dart';
import 'package:ecommerce/event/product_event.dart';
import 'package:ecommerce/Screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc()..add(LoadProducts()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce',
        home: const HomeScreen(),
      ),
    );
  }
}