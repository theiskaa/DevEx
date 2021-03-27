import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../../../../core/services/user_service.dart';
import '../../../../../../core/system/fire.dart';
import '../../../../../../core/utils/connectivity.dart';
import '../../../../../widgets/components/opacity.dart';
import '../../../../../widgets/components/widgets.dart';
import '../../../../../widgets/test-exam/custom_categories_card.dart';
import 'custom_category_test.dart';

class CustomTestCategories extends DevExamStatefulWidget {
  final userID;
  final snapshot;
  final commingFromProfile;
  CustomTestCategories(
      {Key key, this.userID, this.snapshot, this.commingFromProfile})
      : super(key: key);

  @override
  _CustomTestCategoriesState createState() => _CustomTestCategoriesState();
}

class _CustomTestCategoriesState extends DevExamState<CustomTestCategories> {
  UserServices _userServices = UserServices();
  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  final newUsernameFormKey = GlobalKey<FormState>();
  final newUsernameController = TextEditingController();
  String imageUrl;

  int lengthOfCustomCategories;

  Future<void> refreshPage() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    lengthOfCustomCategories == lengthOfCustomCategories - 1
        ? print("already uptaded")
        : setState(() {});
  }

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
    lengthOfCustomCategories = widget.snapshot.data.docs.length;
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
      backgroundColor: devExam.theme.darkTestPurple.withOpacity(.9),
      appBar: buildAppBar(context),
      body: Container(
        alignment: Alignment.topCenter,
        child: _showNoInternet
            ? buildNoInternetConnectionCard(context)
            : buildExamHistoryList(),
      ),
    );
  }

  Container buildNoInternetConnectionCard(BuildContext context) {
    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "${devExam.intl.of(context).fmt('attention.noConnection')}",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildExamHistoryList() {
    return FutureBuilder(
      future: usersRef
          .doc(widget.userID)
          .collection('savedQuestions')
          .orderBy("date", descending: true)
          .get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "${devExam.intl.of(context).fmt('message.somethingWentWrong')}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          if (snapshot.data.docs.isNotEmpty) {
            return refreshableWidget(child: examCardsList(snapshot, context));
          } else {
            return refreshableWidget(child: buildEmptyList(context));
          }
        } else {
          return indicatorOfsavedQuestionsList();
        }
      },
    );
  }

  Widget examCardsList(
    AsyncSnapshot<QuerySnapshot> snapshot,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: snapshot.data.docs.map((doc) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: CustomCategoryCard(
                border: Border.all(color: Colors.white),
                color: devExam.theme.darkTestPurple,
                lang: doc['lang'],
                title:
                    _userServices.readTimestamp(doc['date'], context, devExam),
                questionLenght: doc['questions'].toList()[0].length,
                fontSize: 21,
                textColor: Colors.white,
                onTap: () {
                  if (_showNoInternet == true) {
                    print(_showNoInternet);
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => CustomCategoryTest(
                          data: doc['questions'],
                          questionIndex: 1,
                          commingFromProfile:
                              widget.commingFromProfile ?? false,
                        ),
                      ),
                    );
                  }
                },
                onLongPress: () {
                  if (_showNoInternet) {
                    print(_showNoInternet);
                  } else {
                    showDialogOfClearSavedQuestions(
                      context,
                      _userServices.readTimestamp(
                          doc['date'], context, devExam),
                      doc['questions'].toList()[0].length,
                      doc.id,
                    );
                  }
                },
              ),
              // ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget refreshableWidget({Widget child}) {
    return RefreshIndicator(
      key: refreshKey,
      backgroundColor: devExam.theme.darkTestPurple,
      color: Colors.white,
      onRefresh: () => refreshPage(),
      child: child,
    );
  }

  Container buildEmptyList(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/custom/empty.png', height: 120),
            SizedBox(height: 10),
            Text(
              devExam.intl.of(context).fmt('attention.emptySavedQuestions'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container indicatorOfsavedQuestionsList() {
    return Container(
      child: Center(
        child: OpacityDoer(
          duration: Duration(milliseconds: 100),
          child: SpinKitFadingCircle(
            color: Colors.white,
            size: 50,
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: OpacityButton(
        opacityValue: .5,
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        onTap: () => Navigator.pop(context),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: rightColorToLength(),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Text(
                  _showNoInternet ? "!" : "$lengthOfCustomCategories/10",
                  style: TextStyle(fontSize: 12.3, color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  showDialogOfClearSavedQuestions(
    BuildContext context,
    String date,
    int qcount,
    String doc,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return buildAlertDialog(
          context: context,
          title:
              devExam.intl.of(context).fmt('custom.category.act.delete.title'),
          actTitle: devExam.intl.of(context).fmt('act.delete'),
          actFun: () async {
            await _userServices.deleteCustomCategory(
              uid: widget.userID,
              doc: doc,
            );
            setState(() {
              lengthOfCustomCategories = lengthOfCustomCategories - 1;
            });
            refreshPage();
            Navigator.pop(context);
          },
        );
      },
    );
  }

  AlertDialog buildAlertDialog({
    BuildContext context,
    String title,
    String actTitle,
    Function actFun,
    String content,
  }) {
    return AlertDialog(
      backgroundColor: devExam.theme.darkTestPurple.withOpacity(.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        side: BorderSide(color: Colors.white),
      ),
      title: Text(title, style: TextStyle(color: Colors.white)),
      actions: [
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () => Navigator.pop(context),
          child: Text(
            devExam.intl.of(context).fmt('act.cancel'),
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.red),
          onPressed: actFun,
          child: Text(
            actTitle,
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 10),
      ],
    );
  }

  Color rightColorToLength() {
    if (lengthOfCustomCategories == 8) {
      return Colors.red.withOpacity(.6);
    } else if (lengthOfCustomCategories == 9) {
      return Colors.red.withOpacity(.7);
    } else if (lengthOfCustomCategories == 10) {
      return Colors.red.withOpacity(.9);
    }

    return Colors.white.withOpacity(.1);
  }
}
