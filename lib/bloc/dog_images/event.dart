part of 'bloc.dart';

@immutable
abstract class DogsEvent {}

class InitialDogs extends DogsEvent {}

class LoadNewImages extends DogsEvent {}
