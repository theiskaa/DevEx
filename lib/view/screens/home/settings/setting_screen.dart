import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/core/utils/validators.dart';
import 'package:devexam/view/widgets/components/widgets.dart';
import 'package:devexam/view/widgets/settings/setting_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:devexam/core/blocs/localization/localization_bloc.dart';
import 'package:devexam/core/models/user.dart';
import 'package:devexam/core/services/user_service.dart';
import 'package:devexam/core/system/fire.dart';
import 'package:devexam/core/system/intl.dart';
import 'package:devexam/core/utils/connectivity.dart';
import 'package:devexam/core/utils/ui.dart';
import 'package:devexam/view/widgets/auth/custom_auth_field.dart';
import 'package:devexam/view/widgets/home/change_username_dialog.dart';
import 'package:devexam/view/widgets/home/profile_image_card.dart';

import 'change_password.dart';

class SettingsScreen extends DevExamStatefulWidget {
  final userID;
  SettingsScreen({this.userID});
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends DevExamState<SettingsScreen> {
  final _userService = UserServices();
  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;
  bool _themeSwitchValue;

  final newUsernameFormKey = GlobalKey<FormState>();
  final newUsernameController = TextEditingController();

  /// Language list for dropDown.
  List<String> languages() => [
        "${devExam.intl.of(context).fmt('settings.langENG')} 🇬🇧",
        "${devExam.intl.of(context).fmt('settings.langRUS')} 🇷🇺",
      ];

  String getRightLanguage() {
    if (devExam.intl.of(context).fmt('lang') == "en") {
      return languages()[0];
    } else if (devExam.intl.of(context).fmt('lang') == "ru") {
      return languages()[1];
    }
    return '';
  }

  void showError() {
    setState(() => _showNoInternet = true);
  }

  void hideError() {
    setState(() => _showNoInternet = false);
  }

  bool detectTheme() {
    BlocProvider.of<ThemeBloc>(context).add(DecideTheme());
    if (BlocProvider.of<ThemeBloc>(context).state.themeData ==
        devExam.theme.dark) {
      return _themeSwitchValue = true;
    } else if (BlocProvider.of<ThemeBloc>(context).state.themeData ==
        devExam.theme.light) {
      return _themeSwitchValue = false;
    }
    return _themeSwitchValue = false;
  }

  @override
  void initState() {
    super.initState();
    detectTheme();
    _connection.offlineAction = showError;
    _connection.onlineAction = hideError;
    _connection.connectionTest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: buildProfilePicture(),
            ),
            SizedBox(height: 35),
            buildSettingTiles(context)
          ],
        ),
      ),
    );
  }

  Column buildSettingTiles(BuildContext context) {
    return Column(
      children: [
        SettingTile(
          icon: Icons.person,
          iconCardcolor: Color(0xffFF5551),
          title: devExam.intl.of(context).fmt('more.changeUsername'),
          onTap: () {
            if (_showNoInternet) {
              showSnack(
                devExam: devExam,
                isFloating: true,
                context: context,
                title: devExam.intl.of(context).fmt('attention.noConnection'),
                color: devExam.theme.errorBg,
              );
            } else {
              showDialog(
                context: context,
                builder: (context) => customAlertDialogOfChangeUsername(),
              );
            }
          },
        ),
        customDivider,
        SettingTile(
          icon: Icons.lock_outline_rounded,
          iconCardcolor: Color(0xff2D56A1),
          title: devExam.intl.of(context).fmt('settings.changePassword'),
          onTap: () {
            if (_showNoInternet) {
              showSnack(
                devExam: devExam,
                isFloating: true,
                context: context,
                title: devExam.intl.of(context).fmt('attention.noConnection'),
                color: devExam.theme.errorBg,
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePassword(),
                ),
              );
            }
          },
        ),
        SizedBox(height: 15),
        miniDivider,
        SizedBox(height: 15),
        buildLanguageTile(context),
        customDivider,
        buildDarkThemeTile(context),
        customDivider,
        SettingTile(
          iconCardcolor: Color(0xff2896FF),
          icon: Icons.design_services_rounded,
          title: devExam.intl.of(context).fmt('settings.designPrefs'),
          onTap: () {},
        ),
      ],
    );
  }

  SettingTile buildDarkThemeTile(BuildContext context) {
    return SettingTile(
      iconCardcolor: Color(0xFFC72159),
      icon: Icons.auto_awesome,
      disableOnTap: true,
      title: devExam.intl.of(context).fmt('settings.darkTheme'),
      tralling: CupertinoSwitch(
        activeColor: Color(0xFFC72159),
        value: _themeSwitchValue,
        onChanged: (value) async {
          if (value == false) {
            setState(() => _themeSwitchValue = value);
            BlocProvider.of<ThemeBloc>(context).add(LightTheme());
          } else {
            setState(() => _themeSwitchValue = value);

            BlocProvider.of<ThemeBloc>(context).add(DarkTheme());
          }
        },
      ),
    );
  }

  SettingTile buildLanguageTile(BuildContext context) {
    return SettingTile(
      icon: Icons.language,
      iconCardcolor: Color(0xff6EC14D),
      disableOnTap: true,
      title: devExam.intl.of(context).fmt('settings.appLang').trim(),
      tralling: DropdownButton<String>(
        icon: Icon(Icons.arrow_drop_down),
        value: getRightLanguage(),
        isDense: true,
        iconSize: 16,
        onChanged: (String lang) {
          if (lang == languages()[0]) {
            BlocProvider.of<LocalizationBloc>(context).add(
              LocalizationSuccess(langCode: Lang.EN),
            );
          } else if (lang == languages()[1]) {
            BlocProvider.of<LocalizationBloc>(context).add(
              LocalizationSuccess(langCode: Lang.RUS),
            );
          }
        },
        items: languages().map<DropdownMenuItem<String>>(
          (String value) {
            return DropdownMenuItem<String>(
                value: value, child: Text('$value'));
          },
        ).toList(),
      ),
    );
  }

  Widget customAlertDialogOfChangeUsername() {
    return Form(
      key: newUsernameFormKey,
      child: ChangeUsernameDialog(
        darkColor: devExam.theme.darkTestPurple,
        textField: CustomAuthField(
          accentColor: devExam.theme.accentTestPurple,
          validator: (val) => validateNewUsername(
            newUsername: val,
            devExam: devExam,
            context: context,
          ),
          darkColor: devExam.theme.darkTestPurple,
          hint: "${devExam.intl.of(context).fmt('account.username')}"
              .toLowerCase(),
          controller: newUsernameController,
        ),
        accentColor: devExam.theme.accentTestPurple,
        actTitle: devExam.intl.of(context).fmt('act.change'),
        act: () async {
          if (newUsernameFormKey.currentState.validate()) {
            Navigator.pop(context);
            bool result = await _userService.changeUsername(
              widget.userID,
              newUsernameController.text,
            );
            if (result == true) {
              showSnack(
                devExam: devExam,
                isFloating: true,
                context: context,
                title: devExam.intl.of(context).fmt('changeUsername.success'),
                color: devExam.theme.accentGreenblue,
              );
              newUsernameController.clear();
            } else {
              showSnack(
                devExam: devExam,
                sec: 6,
                isFloating: true,
                context: context,
                title: devExam.intl.of(context).fmt('changeUsername.error'),
                color: devExam.theme.errorBg,
              );
            }
          }
        },
        infoWidget: Text(
          devExam.intl.of(context).fmt('changeUsername.des'),
        ),
      ),
    );
  }

  Widget buildProfilePicture() {
    if (widget.userID != "empty") {
      return StreamBuilder(
        stream: usersRef.doc(widget.userID).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            CurrentUserModel currentuser =
                CurrentUserModel.fromJson(snapshot.data.data());
            if (_showNoInternet) {
              return ProfileImageCard(
                size: 130,
                imageUrl: "${currentuser.photoUrl}",
              );
            }
            return OpacityButton(
              opacityValue: .5,
              child: ProfileImageCard(
                size: 130,
                imageUrl: "${currentuser.photoUrl}",
              ),
              onTap: () => _userService.uploadProfilePicture(widget.userID),
            );
          } else {
            return ProfileImageCard(
              size: 130,
              imageUrl: "loading",
            );
          }
        },
      );
    } else {
      return ProfileImageCard(
        size: 130,
        imageUrl: "",
      );
    }
  }

  Widget get customDivider {
    return Container(
      child: divider(),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }

  Widget get miniDivider {
    return Container(
      height: 0.5,
      width: MediaQuery.of(context).size.width - 150,
      color: Colors.black.withOpacity(.5),
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
