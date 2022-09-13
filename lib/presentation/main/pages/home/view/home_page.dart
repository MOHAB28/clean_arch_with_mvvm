import 'package:flutter/material.dart';
import '../../../../../app/di.dart';
import '../../../../resources/strings_manager.dart';
import '../viewmodel/home_viewmodel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeViewmodel _viewmodel = instance<HomeViewmodel>();


  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(AppStrings.home),
    );
  }
}
