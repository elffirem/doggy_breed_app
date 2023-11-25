import 'package:doggy_app/Screens/home_screen.dart';
import 'package:doggy_app/bloc/breed_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BreedBloc>().add(FetchBreeds());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BreedBloc, BreedState>(
        listener: (context, state) {
          if (state is BreedLoaded) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
            );
          }
          // Hata ve yükleme durumları için ekleyebilirsiniz
        },
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}