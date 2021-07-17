import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:catproject/services/dogs_api.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'event.dart';
part 'state.dart';

class DogsBloc extends Bloc<DogsEvent, DogsState> {
  final List<String> _images = [];
  DogsBloc() : super(DogsInitial());

  @override
  Stream<DogsState> mapEventToState(
    DogsEvent event,
  ) async* {
    if (event is InitialDogs) {
      final dogsImages = await loadImages();
      _images..addAll(dogsImages);
      yield DogsLoaded(dogsImages: _images);
    } else if (event is LoadNewImages) {
      final dogsImages = await loadImages();
      _images..addAll(dogsImages);
      yield DogsLoaded(dogsImages: _images);
    }
  }
}
