import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/view/widgets/components/opacity_button.dart';
import 'package:devexam/view/widgets/components/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingTile extends DevExamStatelessWidget {
  final String title;
  final Widget tralling;
  final Function onTap;
  final bool disableOnTap;
  final Color iconCardcolor;
  final IconData icon;

  SettingTile({
    Key key,
    this.title,
    this.tralling,
    this.onTap,
    this.disableOnTap = false,
    this.iconCardcolor,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return disableOnTap
        ? item(context)
        : OpacityButton(
            opacityValue: .4,
            onTap: onTap,
            child: item(context),
          );
  }

  Container item(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Colors.grey[800].withOpacity(.3)
            : Colors.grey[200].withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      padding: EdgeInsets.all(10),
      child: tile(),
    );
  }

  Row tile() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              buildIcon(),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.5,
                ),
              ),
            ],
          ),
          tralling ??
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
              ),
        ],
      );

  Container buildIcon() {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: iconCardcolor,
      ),
      child: Center(
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
