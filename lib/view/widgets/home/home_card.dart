import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/widgets.dart';

class HomeCard extends DevExamStatelessWidget {
  final Function onTap;
  final Function onLongPress;
  final String img;
  final String tag;

  HomeCard({
    Key key,
    this.onTap,
    this.onLongPress,
    this.img,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        onLongPress: onLongPress,
        child: gridOfCard(context),
      ),
    );
  }

  Padding gridOfCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.width - 100,
        decoration: BoxDecoration(
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? Colors.black
              : Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                      devExam.theme.dark
                  ? Colors.grey[200].withOpacity(.1)
                  : Colors.black.withOpacity(.6),
              spreadRadius: .3,
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Hero(
            tag: tag,
            child: Image.asset(img, height: 220),
          ),
        ),
      ),
    );
  }
}
