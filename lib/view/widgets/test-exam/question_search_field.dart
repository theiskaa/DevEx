import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/view/widgets/components/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class QuestionSearchField extends DevExamStatefulWidget {
  final String questionsLength;
  final VoidCallback onSubmitted;
  final TextEditingController controller;

  QuestionSearchField({
    Key key,
    this.questionsLength,
    this.onSubmitted,
    @required this.controller,
  }) : super(key: key);

  @override
  _QuestionSearchFieldState createState() => _QuestionSearchFieldState();
}

class _QuestionSearchFieldState extends DevExamState<QuestionSearchField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: widget.onSubmitted,
      child: buildField(context),
    );
  }

  Container buildField(BuildContext context) {
    return Container(
      height: 50,
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.go,
        decoration: buildInputDecoration(context),
        onEditingComplete: widget.onSubmitted,
      ),
    );
  }

  InputDecoration buildInputDecoration(BuildContext context) {
    return InputDecoration(
      focusedBorder: buildOutlineInputBorder(context),
      disabledBorder: buildOutlineInputBorder(context),
      enabledBorder: buildOutlineInputBorder(context),
      border: buildOutlineInputBorder(context),
      errorBorder: buildOutlineInputBorder(context),
      focusedErrorBorder: buildOutlineInputBorder(context),
      hintText: devExam.intl.of(context).fmt('category.searchByTypeID'),
      suffixText: widget.questionsLength,
      hintStyle: TextStyle(
        fontSize: 14,
        color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Colors.white.withOpacity(.9)
            : devExam.theme.darkTestPurple.withOpacity(.9),
      ),
      suffixStyle: TextStyle(
        fontSize: 12,
        color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Colors.white.withOpacity(.5)
            : devExam.theme.darkTestPurple.withOpacity(.5),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder(BuildContext context) =>
      OutlineInputBorder(
        borderSide: BorderSide(
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? devExam.theme.accentTestPurple
              : devExam.theme.darkTestPurple,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(15),
      );
}
