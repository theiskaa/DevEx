import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/core/services/local_db_service.dart';
import 'package:devexam/core/utils/ui.dart';
import 'package:devexam/view/widgets/components/widgets.dart';
import 'package:devexam/view/widgets/settings/design_preferences_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:devexam/core/models/user.dart';

class DesignPreferences extends DevExamStatefulWidget {
  final String userID;
  final UserModel user;
  final String currentPassword;

  DesignPreferences({
    Key key,
    this.userID,
    this.currentPassword,
    this.user,
  }) : super(key: key);

  @override
  _DesignPreferencesState createState() => _DesignPreferencesState();
}

class _DesignPreferencesState extends DevExamState<DesignPreferences> {
  bool _scrollSearchIndex;
  bool _fieldSearchIndex;

  @override
  void initState() {
    _scrollSearchIndex = true;
    _fieldSearchIndex = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildDropDownTile(context),
            SizedBox(height: 30),
            divider(),
            SizedBox(height: 30),
            buildFieldTile(context),
          ],
        ),
      ),
    );
  }

  DesignPreferencesTile buildDropDownTile(BuildContext context) {
    return DesignPreferencesTile(
      title: devExam.intl.of(context).fmt('designPrefs.searchQuestionByScroll'),
      customWidgetEx: scrollSearch(context, devExam),
      switcherWidget: CupertinoSwitch(
        activeColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? devExam.theme.accentTestPurple
            : devExam.theme.darkTestPurple,
        value: _scrollSearchIndex,
        onChanged: (value) {
          setState(() => _scrollSearchIndex = !_scrollSearchIndex);
        },
      ),
    );
  }

  DesignPreferencesTile buildFieldTile(BuildContext context) {
    return DesignPreferencesTile(
      title: devExam.intl.of(context).fmt('designPrefs.searchQuestionByField'),
      customWidgetEx: fieldSearch(context, devExam),
      switcherWidget: CupertinoSwitch(
        activeColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? devExam.theme.accentTestPurple
            : devExam.theme.darkTestPurple,
        value: _fieldSearchIndex,
        onChanged: (value) {
          setState(() => _fieldSearchIndex = !_fieldSearchIndex);
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(Icons.arrow_back_ios),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
