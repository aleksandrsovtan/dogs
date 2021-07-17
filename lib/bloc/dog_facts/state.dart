part of 'bloc.dart';

@immutable
abstract class DogFactsState {}

class DogFactsInitial extends DogFactsState {}

class PredictionLoaded extends DogFactsState {
  final String breed;

  PredictionLoaded({required this.breed});
}

class InfoLoaded extends DogFactsState {
  final String breed;
  final String imgUrl;
  final String description;

  InfoLoaded({
    required this.breed,
    required this.imgUrl,
    required this.description,
  });
}

class InfoError extends DogFactsState {
  final String message;

  InfoError({required this.message});
}
