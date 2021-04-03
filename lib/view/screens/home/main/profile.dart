import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/core/utils/validators.dart';
import 'package:devexam/view/screens/home/settings/setting_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:formz/formz.dart';

import '../../../../core/blocs/auth/auth_bloc.dart';
import '../../../../core/blocs/localization/localization_bloc.dart';
import '../../../../core/blocs/reset-password/resetpassword_cubit.dart';
import '../../../../core/models/user.dart';
import '../../../../core/services/fire_auth_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/system/fire.dart';
import '../../../../core/system/intl.dart';
import '../../../../core/utils/connectivity.dart';
import '../../../../core/utils/fire_exception_hander.dart';
import '../../../../core/utils/perceptive.dart';
import '../../../../core/utils/ui.dart';
import '../../../widgets/auth/custom_auth_field.dart';
import '../../../widgets/components/opacity.dart';
import '../../../widgets/components/widgets.dart';
import '../../../widgets/home/change_username_dialog.dart';
import '../../../widgets/home/exam_history_card.dart';
import '../../../widgets/home/profile_image_card.dart';
import '../../../widgets/home/profile_item_card.dart';

// ignore: must_be_immutable
class Profile extends DevExamStatefulWidget {
  dynamic userID;
  Profile(this.userID);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends DevExamState<Profile> {
  final _userService = UserServices();
  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;
  Random random = Random();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  ScrollController _scrollController = ScrollController();
  final newUsernameFormKey = GlobalKey<FormState>();
  final newUsernameController = TextEditingController();
  String imageUrl;
  int indicatorColorIndex = 0;
  bool showGoToTopButton = false;
  bool isExamHistoryLoading = false;

  List<Color> indicatorColors;

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
    indicatorColors = devExam.theme.allColors;
    Timer(
      Duration(milliseconds: 300),
      () => setState(() => indicatorColorIndex = random.nextInt(6)),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          setState(() => showGoToTopButton = false);
        } else {
          setState(() => showGoToTopButton = true);
        }
      }
    });
  }

  @override
  void dispose() {
    if (_connection.timerHandler != null) {
      _connection.timerHandler.cancel();
    }
    super.dispose();
  }

  Future<void> refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() => isExamHistoryLoading = true);
    await Future.delayed(Duration(seconds: 2));
    usersRef
        .doc(widget.userID)
        .collection('examResults')
        .orderBy("date", descending: true)
        .get();
    setState(() {
      isExamHistoryLoading = false;
      indicatorColorIndex = random.nextInt(6);
    });
  }

  @override
  Widget build(BuildContext contxt) {
    final user = context.select((AuthBloc authBloc) => authBloc.state.user);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (contxt) => AuthBloc(fireAuthService: FireAuthService()),
        ),
        BlocProvider(
          create: (contxt) => ResetpasswordCubit(_userService),
        ),
      ],
      child: PerceptiveWidget(child: pageScaffold(user)),
    );
  }

  Scaffold pageScaffold(UserModel user) {
    return Scaffold(
      appBar: buildAppBar(context, user),
      floatingActionButton: showGoToTopButton ? goToTopButton() : SizedBox(),
      body: MultiBlocListener(
        listeners: blocListeners,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (BuildContext context, state) {
            return NotificationListener<ScrollNotification>(
              onNotification: (scrollEnd) {
                var metrics = scrollEnd.metrics;
                if (metrics.atEdge) {
                  if (scrollEnd is ScrollStartNotification) {
                    Future.delayed(Duration(milliseconds: 500), () {
                      if (metrics.pixels <= 100)
                        setState(() => showGoToTopButton = false);
                      setState(() => showGoToTopButton = true);
                    });
                  }
                }
                return true;
              },
              child: body(user, context),
            );
          },
        ),
      ),
    );
  }

  Widget goToTopButton() {
    return AnimatedCustomFAB(
      size: 35,
      backgroundColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? Colors.black
          : Colors.white,
      tappedSize: 30,
      child: Center(
        child: Icon(
          Icons.arrow_upward,
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
      border: Border.all(
        color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Colors.white
            : Colors.black,
      ),
      onTap: () {
        setState(() => showGoToTopButton = false);
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
    );
  }

  Widget body(UserModel user, BuildContext context) {
    return RefreshIndicator(
      key: refreshKey,
      displacement: 100,
      color: indicatorColors[indicatorColorIndex],
      onRefresh: () => refreshPage(),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            profileInfo(user),
            SizedBox(height: 30),
            divider(),
            SizedBox(height: 30),
            buildTitleOfExamHistory(),
            SizedBox(height: 10),
            buildExamHistoryList(),
          ],
        ),
      ),
    );
  }

  List<BlocListener> get blocListeners {
    return [
      BlocListener<ResetpasswordCubit, ResetpasswordState>(
        listener: (context, state) {
          final errorMessage = AuthExceptionHandler.generateExceptionMessage(
            state.status,
            context,
            devExam,
          );
          if (state.status != AuthStatus.successful &&
              state.formzStatus.isSubmissionFailure) {
            showSnack(
              devExam: devExam,
              isFloating: true,
              context: context,
              title: "$errorMessage",
              color: devExam.theme.errorBg,
            );
          }
          if (state.status == AuthStatus.successful) {
            showSnack(
              devExam: devExam,
              isFloating: true,
              context: context,
              title:
                  devExam.intl.of(context).fmt('message.resetPasswordSuccess'),
              color: devExam.theme.accentGreenblue,
            );
            state.status = AuthStatus.undefined;
          }
        },
      ),
    ];
  }

  Container buildTitleOfExamHistory() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.topLeft,
      child: Text(
        devExam.intl.of(context).fmt('examResult.title'),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  showDialogOfClearAll(BuildContext contxt) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildAlertDialog(
          context: context,
          title: devExam.intl.of(context).fmt('clearExamResult.title'),
          actTitle: devExam.intl.of(context).fmt('act.delete'),
          actFun: () async {
            Navigator.pop(context);
            Future.delayed(Duration(milliseconds: 800));
            var result =
                await _userService.clearFullExamHistoryList(widget.userID);
            print("========= $result");
            if (result == true) {
              showSnack(
                devExam: devExam,
                isFloating: true,
                context: context,
                title:
                    "${devExam.intl.of(context).fmt('clearExamResult.success')}",
                color: devExam.theme.accentGreenblue,
              );
            } else {
              showSnack(
                devExam: devExam,
                sec: 6,
                isFloating: true,
                context: context,
                title:
                    "${devExam.intl.of(context).fmt('clearExamResult.error')}",
                color: devExam.theme.accentGreenblue,
              );
            }
          },
        );
      },
    );
  }

  Widget buildExamHistoryList() {
    if (_showNoInternet) {
      return Container(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                BlocProvider.of<ThemeBloc>(context).state.themeData ==
                        devExam.theme.dark
                    ? "assets/custom/wifi_white.png"
                    : 'assets/custom/wifi.png',
                height: 100,
              ),
              SizedBox(height: 15),
              Text(
                "${devExam.intl.of(context).fmt('attention.noConnection')}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[800],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return FutureBuilder(
        future: usersRef
            .doc(widget.userID)
            .collection('examResults')
            .orderBy("date", descending: true)
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (isExamHistoryLoading) {
            return indicatorOfExamHistoryList();
          } else {
            if (snapshot.hasError) {
              return Container(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "${devExam.intl.of(context).fmt('message.somethingWentWrong')}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red[700],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data.docs.isNotEmpty) {
                return examCardsList(snapshot);
              } else {
                return buildEmptyList();
              }
            } else {
              return indicatorOfExamHistoryList();
            }
          }
        },
      );
    }
  }

  Container buildEmptyList() {
    return Container(
      padding: EdgeInsets.only(top: 100),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              'assets/custom/empty.png',
              height: 120,
            ),
            SizedBox(height: 10),
            Text(
              "${devExam.intl.of(context).fmt('attention.emptyExamResultList')}...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget examCardsList(AsyncSnapshot<QuerySnapshot> snapshot) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: snapshot.data.docs.map((doc) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: OpacityDoer(
                duration: Duration(milliseconds: 250),
                child: ExamHistoryCard(
                  langType: doc['lang'],
                  correctAnswersCount: doc['correctAnswersCount'],
                  incorrectAnswersCount: doc['incorrectAnswersCount'],
                  date:
                      _userService.readTimestamp(doc['date'], context, devExam),
                  incorrectAnswersList: doc['incorrectAnswersList'],
                  noInternet: _showNoInternet,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Container indicatorOfExamHistoryList() {
    return Container(
      padding: EdgeInsets.only(top: 150),
      child: Center(
        child: OpacityDoer(
          duration: Duration(milliseconds: 100),
          child: SpinKitFadingCircle(
            color: indicatorColors[indicatorColorIndex],
            size: 50,
          ),
        ),
      ),
    );
  }

  Widget profileInfo(UserModel user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: infoItems(user)),
          buildProfilePicture(),
        ],
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

  Widget infoItems(UserModel user) {
    return Container(
      child: Center(
        child: Wrap(
          spacing: 8.0.wP,
          children: [
            ProfileItemCard(
              minVal: false,
              userID: widget.userID,
              onTap: () {
                _scrollController.animateTo(
                  200,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
                setState(() => showGoToTopButton = true);
              },
              stream: usersRef
                  .doc(widget.userID)
                  .collection('examResults')
                  .snapshots(),
              type: devExam.intl
                  .of(context)
                  .fmt('examResult.title')
                  .replaceAll(" ", "\n"),
            ),
            ProfileItemCard(
              minVal: true,
              userID: widget.userID,
              stream: usersRef
                  .doc(widget.userID)
                  .collection('savedQuestions')
                  .snapshots(),
              type: devExam.intl
                  .of(context)
                  .fmt('category.customs')
                  .replaceAll(" ", "\n"),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUsername() {
    return StreamBuilder(
      stream: usersRef.doc(widget.userID).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          CurrentUserModel currentuser =
              CurrentUserModel.fromJson(snapshot.data.data());
          return OpacityButton(
            opacityValue: .5,
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
            child: Text(
              currentuser.username == null ? "404" : "${currentuser.username}",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 18.5.fP,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.topLeft,
            child: SpinKitThreeBounce(
              color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                      devExam.theme.dark
                  ? Colors.white
                  : Colors.black,
              size: 15,
            ),
          );
        }
      },
    );
  }

  Widget buildAppBar(BuildContext context, UserModel userModel) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: (widget.userID != "empty") ? buildUsername() : Container(),
      actions: [
        StreamBuilder(
          stream:
              usersRef.doc(widget.userID).collection('examResults').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: buildPopUpMenu(snapshot, context, userModel),
            );
          },
        ),
      ],
    );
  }

  Widget buildPopUpMenu(
    AsyncSnapshot<QuerySnapshot> snapshot,
    BuildContext context,
    UserModel userModel,
  ) {
    return BlocBuilder<ResetpasswordCubit, ResetpasswordState>(
      builder: (contxtOfResetpasswordCubit, stateOfResetpasswordCubit) {
        return PopupMenuButton(
          offset: Offset(2, 10),
          elevation: 3,
          icon: Icon(Icons.more_vert),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: devExam.theme.darkTestPurple),
          ),
          onSelected: (val) => getValidMethodOfMenuItems(
            context,
            val,
            snapshot,
            userModel,
            stateOfResetpasswordCubit,
            contxtOfResetpasswordCubit,
          ),
          itemBuilder: (context) {
            return menuStrings(context, devExam).map((item) {
              return PopupMenuItem(
                value: item,
                child: menuButton(item, getValidIcon(item, context, devExam)),
              );
            }).toList();
          },
        );
      },
    );
  }

  void getValidMethodOfMenuItems(
    BuildContext context,
    dynamic item,
    AsyncSnapshot<QuerySnapshot> snapshot,
    UserModel userModel,
    ResetpasswordState stateOfResetpasswordCubit,
    BuildContext contxtOfResetpasswordCubit,
  ) {
    if (item == menuStrings(context, devExam)[0]) {
      if (_showNoInternet) {
        showSnack(
          devExam: devExam,
          isFloating: true,
          context: context,
          title: devExam.intl.of(context).fmt('attention.noConnection'),
          color: devExam.theme.errorBg,
        );
      } else {
        if (snapshot.data.docs.isEmpty) {
          print("Cloud is empty ");
        } else {
          showDialogOfClearAll(context);
        }
      }
    } else if (item == menuStrings(context, devExam)[1]) {
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
    } else if (item == menuStrings(context, devExam)[2]) {
      if (_showNoInternet) {
        showSnack(
          devExam: devExam,
          isFloating: true,
          context: context,
          title: devExam.intl.of(context).fmt('attention.noConnection'),
          color: devExam.theme.errorBg,
        );
      } else {
        sendPasswordResetEmail(
          userModel,
          stateOfResetpasswordCubit,
          contxtOfResetpasswordCubit,
        );
      }
    } else if (item == menuStrings(context, devExam)[3]) {
      if (devExam.intl.of(context).fmt('lang') == "en") {
        BlocProvider.of<LocalizationBloc>(context)
            .add(LocalizationSuccess(langCode: Lang.RUS));
      } else if (devExam.intl.of(context).fmt('lang') == "ru") {
        BlocProvider.of<LocalizationBloc>(context)
            .add(LocalizationSuccess(langCode: Lang.EN));
      }
    } else if (item == menuStrings(context, devExam)[4]) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsScreen(userID: widget.userID),
        ),
      );
    } else if (item == menuStrings(context, devExam)[5]) {
      showDialog(
        context: context,
        builder: (context) {
          return buildAlertDialog(
            context: context,
            title: devExam.intl.of(context).fmt('attention.logout'),
            actTitle: devExam.intl.of(context).fmt('act.signout'),
            actFun: () {
              setState(() {
                widget.userID = "empty";
              });
              Navigator.pop(context);
              context.read<AuthBloc>().add(AuthLogoutRequested());
            },
          );
        },
      );
    } else {
      return null;
    }
  }

  void sendPasswordResetEmail(
    UserModel userModel,
    ResetpasswordState state,
    BuildContext contxtOfResetpasswordCubit,
  ) async {
    await contxtOfResetpasswordCubit
        .read<ResetpasswordCubit>()
        .emailChanged(userModel.email);
    contxtOfResetpasswordCubit
        .read<ResetpasswordCubit>()
        .sendResetPasswordMail();
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

  AlertDialog buildAlertDialog({
    BuildContext context,
    String title,
    String actTitle,
    String cancelTitle,
    Function actFun,
  }) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: devExam.theme.darkTestPurple),
      ),
      title: Text(title),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "${devExam.intl.of(context).fmt('act.cancel')}",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        TextButton(
          style: alertButtonsStyle(Colors.red),
          onPressed: actFun,
          child: Text(
            actTitle,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
