import 'dart:convert';
import 'dart:ui';

import 'package:doggy_app/Data/app_constant.dart';
import 'package:doggy_app/Models/breed_model.dart';
import 'package:doggy_app/Screens/settings_screen.dart';
import 'package:doggy_app/Utils/custom_modal.dart';
import 'package:doggy_app/bloc/breed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'mixin/home_screen_mixin.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with HomeScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<BreedBloc, BreedState>(
        builder: (context, state) {
          if (state is BreedLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BreedLoaded) {
            return _buildGridView(state.breeds);
          } else {
            return const Center(child: Text('Bir hata oluştu'));
          }
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }
}