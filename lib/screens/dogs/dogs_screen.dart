import 'package:catproject/bloc/likes/bloc.dart';
import 'package:catproject/screens/dogs/hero_screen.dart';
import 'package:catproject/screens/common/cached_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:catproject/bloc/dog_images/bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:like_button/like_button.dart';

class DogsScreen extends StatelessWidget {
  const DogsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LikeBloc _likeBloc = BlocProvider.of<LikeBloc>(context);
    DogsBloc _dogsBloc = BlocProvider.of<DogsBloc>(context);
    return BlocBuilder<DogsBloc, DogsState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          if (state is DogsLoaded) {
            return LazyLoadScrollView(
              onEndOfPage: () {
                _dogsBloc.add(LoadNewImages());
              },
              child: GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: state.dogsImages.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                          return HeroScreen(
                            imgUrl: '${state.dogsImages[index]}',
                            tag: 'dash${state.dogsImages[index]}',
                          );
                        }));
                      },
                      child: Hero(
                        tag: 'dash${state.dogsImages[index]}',
                        flightShuttleBuilder: (
                          BuildContext flightContext,
                          Animation<double> animation,
                          HeroFlightDirection flightDirection,
                          BuildContext fromHeroContext,
                          BuildContext toHeroContext,
                        ) {
                          return SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.all(30),
                              child:
                                  Image.network('${state.dogsImages[index]}'),
                            ),
                          );
                        },
                        child: Stack(
                          children: [
                            CachedImage(imageUrl: state.dogsImages[index]),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      BlocBuilder<LikeBloc, LikesState>(
                                          builder: (context, likeState) {
                                        if (likeState is Likes) {
                                          return LikeButton(
                                            onTap: (isLiked) async {
                                              if (likeState.likes.contains(
                                                  state.dogsImages[index])) {
                                                _likeBloc.add(Dislike(
                                                    id: state
                                                        .dogsImages[index]));
                                                return true;
                                              } else {
                                                _likeBloc.add(Like(
                                                    id: state
                                                        .dogsImages[index]));
                                                return false;
                                              }
                                            },
                                            size: 32,
                                            circleColor: CircleColor(
                                                start: Colors.red,
                                                end: Colors.red),
                                            bubblesColor: BubblesColor(
                                              dotPrimaryColor: Colors.red,
                                              dotSecondaryColor: Colors.red,
                                            ),
                                            likeBuilder: (_) {
                                              return Icon(
                                                CupertinoIcons.heart_fill,
                                                color: likeState.likes.contains(
                                                        state.dogsImages[index])
                                                    ? Colors.red
                                                    : Colors.white70,
                                                size: 32,
                                              );
                                            },
                                          );
                                        } else {
                                          return Text(
                                              "Something went wrong...");
                                        }
                                      }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
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
        });
  }
}
