part of 'bloc.dart';

@immutable
abstract class DogFactsEvent {}

class GetPrediction extends DogFactsEvent {
  final String url;

  GetPrediction({required this.url});
}

class GetDogInfo extends DogFactsEvent {
  final String breed;

  GetDogInfo({required this.breed});
}
