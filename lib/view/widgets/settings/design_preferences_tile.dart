import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/core/system/devexam.dart';
import 'package:devexam/view/widgets/components/widgets.dart';
import 'package:devexam/view/widgets/test-exam/search_question_drowdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DesignPreferencesTile extends DevExamStatelessWidget {
  final String title;
  final Widget switcherWidget;
  final Widget customWidgetEx;

  DesignPreferencesTile({
    Key key,
    this.title,
    this.switcherWidget,
    this.customWidgetEx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          buildWidgetsAppbar(),
          featureOverviewWidget(context),
        ],
      ),
    );
  }

  Container featureOverviewWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? Colors.white.withOpacity(.8)
              : Colors.black.withOpacity(.8),
        ),
      ),
      child: Center(
        child: customWidgetEx ?? SizedBox.shrink(),
      ),
    );
  }

  Widget buildWidgetsAppbar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (switcherWidget != null) switcherWidget,
        ],
      ),
    );
  }
}

Widget scrollSearch(BuildContext context, DevExam devExam) {
  return SearchQuestionDropDown(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              devExam.intl.of(context).fmt('category.searchByIndex'),
              style: TextStyle(
                color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                        devExam.theme.dark
                    ? Colors.white
                    : devExam.theme.darkTestPurple,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                      devExam.theme.dark
                  ? devExam.theme.accentTestPurple
                  : devExam.theme.darkTestPurple,
            )
          ],
        ),
      ),
    ),
  );
}

Widget fieldSearch(BuildContext context, DevExam devExam) {
  return SearchQuestionDropDown(
    horizontalPadding: 10,
    radius: 10,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              devExam.intl.of(context).fmt('category.searchByTypeID'),
              style: TextStyle(
                color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                        devExam.theme.dark
                    ? Colors.white.withOpacity(.9)
                    : devExam.theme.darkTestPurple.withOpacity(.9),
              ),
            ),
            Text(
              "1/20",
              style: TextStyle(
                color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                        devExam.theme.dark
                    ? Colors.white.withOpacity(.5)
                    : devExam.theme.darkTestPurple.withOpacity(.5),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
