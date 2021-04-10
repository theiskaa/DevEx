import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/core/utils/connectivity.dart';
import 'package:devexam/core/utils/ui.dart';
import 'package:devexam/view/widgets/auth/custom_auth_field.dart';
import 'package:devexam/view/widgets/components/animated_custom_fab.dart';
import 'package:devexam/view/widgets/components/opacity_button.dart';
import 'package:devexam/view/widgets/components/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:devexam/core/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BugReporterS {
  BugReporterS._();
  static const Email = "bug.reporter.sp@gmail.com";
  static const Password = "devexamyhq";
}

class BugReport extends DevExamStatefulWidget {
  final String userID;
  final UserModel user;
  final String currentPassword;

  BugReport({
    Key key,
    this.userID,
    this.currentPassword,
    this.user,
  }) : super(key: key);

  @override
  BugReportState createState() => BugReportState();
}

class BugReportState extends DevExamState<BugReport> {
  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _desController = TextEditingController();

  void showError() {
    setState(() => _showNoInternet = true);
  }

  void hideError() {
    setState(() => _showNoInternet = false);
  }

  @override
  void initState() {
    super.initState();
    _connection.offlineAction = showError;
    _connection.onlineAction = hideError;
    _connection.connectionTest();
  }

  @override
  void dispose() {
    if (_connection.timerHandler != null) {
      _connection.timerHandler.cancel();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: _sendEmailButton(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _titleField(context),
              SizedBox(height: 20),
              divider(),
              SizedBox(height: 20),
              _descriptionField(context),
            ],
          ),
        ),
      ),
    );
  }

  AnimatedFloatingActionButton _sendEmailButton(BuildContext context) {
    return AnimatedFloatingActionButton(
      child: Icon(
        Icons.send,
        color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Colors.black
            : Colors.white,
      ),
      backgroundColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? Colors.white
          : Colors.black,
      onTap: () {
        if (_formKey.currentState.validate()) {
        } else {
          showSnack(
            context: context,
            color: devExam.theme.errorBg,
            devExam: devExam,
            title: devExam.intl.of(context).fmt('message.invalidFormz'),
          );
        }
      },
    );
  }

  CustomAuthField _descriptionField(BuildContext context) {
    return CustomAuthField(
      maxLines: 9999,
      decoration: _buildCustomFieldDecoration(
        context,
        devExam.intl.of(context).fmt("bugReport.issueDesTitle"),
      ),
      validator: (val) {
        if (val.isEmpty) {
          return devExam.intl.of(context).fmt("authStatus.emptyForm");
        }
        return null;
      },
      controller: _desController,
    );
  }

  Widget _titleField(BuildContext context) => CustomAuthField(
        controller: _titleController,
        decoration: _buildCustomFieldDecoration(
          context,
          devExam.intl.of(context).fmt("bugReport.issueTitle"),
        ),
        validator: (val) {
          if (val.isEmpty) {
            return devExam.intl.of(context).fmt("authStatus.emptyForm");
          }
          return null;
        },
      );

  InputDecoration _buildCustomFieldDecoration(
    BuildContext context,
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
    );
  }
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
