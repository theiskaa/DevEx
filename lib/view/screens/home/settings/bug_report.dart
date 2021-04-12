import 'dart:io';

import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/core/services/user_service.dart';
import 'package:devexam/core/utils/connectivity.dart';
import 'package:devexam/core/utils/fire_exception_hander.dart';
import 'package:devexam/core/utils/ui.dart';
import 'package:devexam/view/widgets/auth/custom_auth_field.dart';
import 'package:devexam/view/widgets/components/animated_custom_fab.dart';
import 'package:devexam/view/widgets/components/opacity_button.dart';
import 'package:devexam/view/widgets/components/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:devexam/core/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
  static const BugReportEmail = "bug.reporter.sp@gmail.com";

  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;

  final _userService = UserServices();

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _desController = TextEditingController();
  List<String> _attachmentsList = [];

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

  void _sendMail() async {
    if (!_showNoInternet) {
      if (_formKey.currentState.validate()) {
        AuthStatus authStatus = await _userService.sendBugReportMail(
          title: _titleController.text,
          body: _desController.text,
          attachments: _attachmentsList,
          recipient: BugReportEmail,
        );
        final errorMessage =
            await AuthExceptionHandler.generateExceptionMessage(
          authStatus,
          context,
          devExam,
        );

        // To escape from this issue - https://github.com/sidlatau/flutter_email_sender/issues/65
        if (Platform.isIOS && authStatus == AuthStatus.undefined) {
          final _url = Uri(
            scheme: 'mailto',
            path: '$BugReportEmail',
            queryParameters: {
              'subject': _titleController.text,
              'body': _desController.text,
            },
          ).toString();

          if (await canLaunch(_url)) {
            await launch(_url);
          } else {
            authStatus = AuthStatus.undefined;
          }
        }

        showSnack(
          sec: (authStatus == AuthStatus.bugReportedSuccessfully) ? 6 : 3,
          devExam: devExam,
          context: context,
          title: "$errorMessage",
          color: (authStatus == AuthStatus.bugReportedSuccessfully)
              ? Color(0xFF58114D)
              : devExam.theme.errorBg,
        );
      } else {
        showSnack(
          context: context,
          color: devExam.theme.errorBg,
          devExam: devExam,
          title: devExam.intl.of(context).fmt('message.invalidFormz'),
        );
      }
    } else {
      showSnack(
        devExam: devExam,
        isFloating: true,
        context: context,
        title: devExam.intl.of(context).fmt('attention.noConnection'),
        color: devExam.theme.errorBg,
      );
    }
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
      onTap: () => _sendMail(),
    );
  }

  CustomAuthField _descriptionField(BuildContext context) {
    return CustomAuthField(
      maxLines: 100,
      decoration: _buildCustomFieldDecoration(
        context,
        devExam.intl.of(context).fmt("bugReport.issueDesTitle"),
      ),
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
      focusedErrorBorder: InputBorder.none,
    );
  }

  Widget attachmentIcon() {
    return Container(
      alignment: Alignment.center,
      width: 30,
      height: 30,
      child: Stack(
        children: [
          Icon(Icons.attach_email, size: 30),
          (_attachmentsList.isNotEmpty)
              ? Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.topRight,
                  child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _attachmentsList.length.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      title: Text(
        devExam.intl.of(context).fmt('settings.bugReport'),
        style: TextStyle(fontSize: 18),
      ),
      backgroundColor: Colors.transparent,
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(Icons.arrow_back_ios),
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OpacityButton(
            enableOnLongPress: true,
            opacityValue: .3,
            child: attachmentIcon(),
            onLongPress: () {
              if (_attachmentsList.isNotEmpty) {
                showDialog(
                  context: context,
                  builder: (context) => buildAttachmentsListDialog(context),
                );
              } else {
                showSnack(
                  context: context,
                  color: devExam.theme.errorBg,
                  devExam: devExam,
                  title: devExam.intl
                      .of(context)
                      .fmt('bugReport.emptyAttachmentList'),
                );
              }
            },
            onTap: () => _userService.addAttachment(
              _attachmentsList,
              customSetState: () => setState(() {}),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAttachmentsListDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: devExam.theme.darkTestPurple),
        ),
        title: Text(devExam.intl.of(context).fmt("bugReport.attachedPhotos")),
        content: Container(
          height: 50,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: attachementListWidget(setState, context),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              devExam.intl.of(context).fmt('act.goBack').toLowerCase(),
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Row attachementListWidget(StateSetter setState, BuildContext context) {
    return Row(
      children: <Widget>[
        for (var i = 1; i < _attachmentsList.length + 1; i++)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: <Widget>[
                Text(
                  i.toString(),
                  softWrap: false,
                  style: TextStyle(fontWeight: FontWeight.w900),
                  overflow: TextOverflow.fade,
                ),
                SizedBox(width: 2),
                OpacityButton(
                  opacityValue: .3,
                  child: Icon(Icons.remove_circle),
                  onTap: () {
                    setState(() => _attachmentsList.removeAt(i - 1));
                    _rebuildPage();
                    if (_attachmentsList.isEmpty) {
                      Navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
      ],
    );
  }

  void _rebuildPage() => setState(() {});
}
