import 'package:dogsproject/bloc/auth/bloc.dart';
import 'package:dogsproject/bloc/dog_facts/bloc.dart';
import 'package:dogsproject/bloc/dog_images/bloc.dart';
import 'package:dogsproject/bloc/likes/bloc.dart';
import 'package:dogsproject/screens/home/home_page_guess.dart';
import 'package:dogsproject/screens/home/home_screen_user.dart';
import 'package:dogsproject/services/image_recognition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadModel();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return MaterialApp(home: Text('Error connecting to firebase'));
          } else if (snapshot.connectionState == ConnectionState.done) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<DogsBloc>(
                    create: (context) => DogsBloc()..add(InitialDogs())),
                BlocProvider<DogFactsBloc>(create: (context) => DogFactsBloc()),
                BlocProvider<LikeBloc>(create: (context) => LikeBloc()),
                BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
              ],
              child: BlocBuilder<AuthBloc, AuthState>(
                  buildWhen: (previous, current) {
                return true;
              }, builder: (context, state) {
                if (state is AuthSuccess) {
                  if (state.currentUser != null) {
                    return MaterialApp(
                      title: 'Cats App',
                      home: HomeScreenUser(),
                    );
                  } else {
                    return Login();
                  }
                } else {
                  return Login();
                }
              }),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
