import 'dart:ui';

import 'package:catproject/bloc/dog_facts/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HeroScreen extends StatelessWidget {
  final String imgUrl;
  final String tag;

  const HeroScreen({Key? key, required this.imgUrl, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
        ),
        body: Center(
          child: Hero(
            tag: tag,
            flightShuttleBuilder: (
              BuildContext flightContext,
              Animation<double> animation,
              HeroFlightDirection flightDirection,
              BuildContext fromHeroContext,
              BuildContext toHeroContext,
            ) {
              return SingleChildScrollView(
                child: Image.network('$imgUrl'),
              );
            },
            child: Container(
              margin: EdgeInsets.all(30),
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Image.network(imgUrl),
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Facts(url: imgUrl),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Facts extends StatelessWidget {
  final String url;

  const Facts({required this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<DogFactsBloc>(context)
      ..add(GetPrediction(url: url));
    return Container(
      child: BlocBuilder<DogFactsBloc, DogFactsState>(
        builder: (context, state) {
          if (state is PredictionLoaded) {
            final capitalized =
                state.breed[0].toUpperCase() + state.breed.substring(1);
            _bloc.add(GetDogInfo(breed: state.breed));
            return Text(
              capitalized,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            );
          } else if (state is InfoLoaded) {
            final capitalized =
                state.breed[0].toUpperCase() + state.breed.substring(1);
            return Column(
              children: [
                Text(
                  capitalized,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Image.network(state.imgUrl),
                Text(
                  '${state.description}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            );
          } else if (state is InfoError) {
            return Text(
              '${state.message}',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            );
          } else {
            return Center(
              child: SpinKitFadingCircle(
                size: 100,
                itemBuilder: (BuildContext context, int index) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      color: index.isEven ? Colors.orange : Colors.orange[300],
                      borderRadius: BorderRadius.circular(180),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
