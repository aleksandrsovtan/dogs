part of 'bloc.dart';

@immutable
abstract class DogsState {}

class DogsInitial extends DogsState {}

class DogsLoaded extends DogsState {
  final List<String> dogsImages;

  DogsLoaded({required this.dogsImages});
}
