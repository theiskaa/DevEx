import 'package:flutter/material.dart';

import '../components/widgets.dart';

class CustomCategoryCard extends DevExamStatefulWidget {
  final Color color;
  final String title;
  final int questionLenght;
  final Color textColor;
  final double fontSize;
  final Function onTap;
  final Function onLongPress;
  final IconData icon;
  final String lang;
  final Border border;

  CustomCategoryCard({
    Key key,
    this.color,
    this.textColor,
    this.title,
    this.fontSize,
    this.onTap,
    this.icon,
    this.questionLenght,
    this.border,
    this.onLongPress,
    this.lang,
  }) : super(key: key);

  @override
  _CustomCategoryCardState createState() => _CustomCategoryCardState();
}

class _CustomCategoryCardState extends DevExamState<CustomCategoryCard> {
  bool _isTapped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (d) {
        setState(() {
          _isTapped = true;
        });
      },
      onTapUp: (d) {
        setState(() {
          _isTapped = false;
        });
        widget.onTap();
      },
      onTapCancel: () {
        setState(() {
          _isTapped = false;
        });
      },
      onLongPressStart: (d) {
        setState(() {
          _isTapped = true;
        });
      },
      onLongPressUp: () {
        widget.onLongPress();
      },
      onLongPressEnd: (d) {
        setState(() {
          _isTapped = false;
        });
      },
      child: Opacity(
        opacity: _isTapped ? .5 : 1,
        child: buttonBody(context),
      ),
    );
  }

  Padding buttonBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: boxDecoration(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: Column(
              children: [
                buildTitle(),
                buildCountAndLangTitle(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildCountAndLangTitle(BuildContext context) {
    return Container(
      alignment: Alignment.bottomRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "${widget.lang} - ",
            style: TextStyle(
              color: widget.textColor.withOpacity(.7),
              fontSize: 18,
            ),
          ),
          SizedBox(width: 5),
          Text(
            "${widget.questionLenght} ${devExam.intl.of(context).fmt('question').toLowerCase()}",
            style: TextStyle(
              color: widget.textColor.withOpacity(.7),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      border: widget.border,
      color: widget.color,
      borderRadius: BorderRadius.circular(20),
    );
  }

  Container buildTitle() {
    return Container(
      alignment: Alignment.topLeft,
      child: Text(
        widget.title,
        style: TextStyle(
          color: widget.textColor,
          fontSize: 20,
        ),
      ),
    );
  }
}
