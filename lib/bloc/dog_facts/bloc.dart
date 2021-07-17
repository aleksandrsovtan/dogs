import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dogsproject/services/dogs_api.dart';
import 'package:dogsproject/services/image_recognition.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class DogFactsBloc extends Bloc<DogFactsEvent, DogFactsState> {
  DogFactsBloc() : super(DogFactsInitial());

  @override
  Stream<DogFactsState> mapEventToState(
    DogFactsEvent event,
  ) async* {
    if (event is GetPrediction) {
      final breed = await getPrediction(event.url);
      yield PredictionLoaded(breed: breed);
    }
    if (event is GetDogInfo) {
      final info = await getDogInfo(event.breed);
      if (info == null) {
        yield InfoError(message: 'Unable to find breed info');
      } else {
        yield InfoLoaded(
          breed: info.breedName,
          imgUrl: info.image,
          description: info.description,
        );
      }
    }
  }
}
