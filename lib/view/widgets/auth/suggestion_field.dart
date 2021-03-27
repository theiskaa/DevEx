import 'package:flutter/material.dart';

import '../components/widgets.dart';

/// Custom style class for `SuggestionListItem`.
///  to set all visual properties easily
class SuggestionItemStyle {
  /// [backgroundColor] of `SuggestionItem` card.
  final Color backgroundColor;

  /// [titleStyle] of `SuggestionItem`'s title.
  final TextStyle titleStyle;

  /// icon of `SuggestionItem`'s tralling.
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  /// [border] of `SuggestionItem` card.
  final Border border;

  /// [borderRadius] of `SuggestionItem` card.
  final BorderRadius borderRadius;

  /// [gradient] of `SuggestionItem` card.
  final Gradient gradient;

  /// [boxShadow] of `SuggestionItem` card.
  final List<BoxShadow> boxShadow;

  /// [margin] of `SuggestionItem` card.
  final EdgeInsetsGeometry margin;

  final Color shadowcolor;

  const SuggestionItemStyle({
    this.backgroundColor,
    this.titleStyle,
    this.icon = Icons.clear,
    this.iconSize,
    this.iconColor = Colors.red,
    this.border,
    this.borderRadius,
    this.gradient,
    this.boxShadow,
    this.margin,
    this.shadowcolor,
  });

  /// The default style, wich is setted otomaticaly.
  /// Includes just basic white theme design
  static const DefaultStyle = const SuggestionItemStyle(
    backgroundColor: Colors.white,
    icon: Icons.clear,
    iconColor: Colors.red,
    iconSize: 20,
    titleStyle: TextStyle(color: Colors.black),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
  );

  /// The Custom White Neumorphism style of `SuggestionItemStyle`.
  static const WhiteNeumorphismedStyle = const SuggestionItemStyle(
    margin: const EdgeInsetsDirectional.only(start: 1, end: 1, top: 1),
    backgroundColor: Colors.white,
    icon: Icons.clear,
    iconColor: Colors.red,
    iconSize: 20,
    shadowcolor: Color(0xffD5D5D5),
    titleStyle: TextStyle(color: Colors.black),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    boxShadow: [
      BoxShadow(
        blurRadius: 1,
        spreadRadius: 1,
        offset: Offset(0, 2),
        color: Color(0xffD5D5D5),
      ),
    ],
  );

  /// The Custom Black Neumorphism style of `SuggestionItemStyle`.
  static const BlackNeumorphismedStyle = const SuggestionItemStyle(
    margin: const EdgeInsetsDirectional.only(start: 1, end: 1, top: 1),
    backgroundColor: Color(0xFF0E0E0E),
    icon: Icons.clear,
    iconColor: Colors.red,
    shadowcolor: Color(0xFF2E2E2E),
    iconSize: 20,
    titleStyle: TextStyle(color: Colors.white),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    boxShadow: [
      BoxShadow(
        blurRadius: 1,
        spreadRadius: 1,
        offset: Offset(0, 2),
        color: Color(0xFF2E2E2E),
      ),
    ],
  );

  static const BlueNeumorphismedStyle = const SuggestionItemStyle(
    margin: const EdgeInsetsDirectional.only(start: 1, end: 1, top: 1),
    backgroundColor: Colors.white,
    icon: Icons.clear,
    shadowcolor: Color(0xff2865CE),
    iconColor: Colors.red,
    iconSize: 20,
    titleStyle: TextStyle(color: Colors.black),
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    boxShadow: [
      BoxShadow(
        blurRadius: 1,
        spreadRadius: 0.5,
        offset: Offset(0, 3),
        color: Color(0xff2865CE),
      ),
    ],
  );
}

/// AutoSuggestion class
class SuggestionField extends DevExamStatefulWidget {
  /// The basic text editing controller for listen value changes.
  /// and for play around the input's value.
  final TextEditingController textController;

  /// The main list as `String` which would be into suggestion box.
  final List<String> suggestionList;

  /// To set custom `ValueChanged` method, when tapping `suggestionItem`
  final ValueChanged<dynamic> onValueChanged;

  /// for set custom `onTap` method
  /// for example: you need open a page, when item selected
  /// so you can use [onTap] as Navigator..
  final VoidCallback onTap;

  /// As default we use `onIconTap` for remove tapped item to [suggestionList].
  /// this property make able to customize this.
  final VoidCallback onIconTap;

  /// To calucalte suggestionBox's size by item.
  /// so if `sizeByItem == 1` then size will be `60`
  final int sizeByItem;

  /// [SuggestionBox] basicly is simple Container and it has decoration by default.
  /// If user need/want customize this decoration, then should use [suggestionBoxDecoration].
  final BoxDecoration suggestionBoxDecoration;

  /// `wDivider` means - with divider? so if it equeals `true`, we can see a simple line,
  /// every suggestionItem's front.
  final bool wDivider;

  /// As default we have divider as `Container`, to create your own divider widget should use [divider].
  final Widget divider;

  /// Custom style option of `SuggestionItem`, it takes, [SuggestionItemStyle.DefaultStyle] by default.
  /// Able to set as Custom, like this:
  /// ```dart
  /// SuggestionItemStyle(...)
  /// ```
  /// also able to set by ready designs. for example:
  /// ```dart
  /// SuggestionItemStyle.DefaultStyle
  /// ```
  /// ```dart
  /// SuggestionItemStyle.WhiteNeumorphismedStyle
  /// ```
  /// ```dart
  /// SuggestionItemStyle.BlackNeumorphismedStyle
  /// ```
  final SuggestionItemStyle suggestionItemStyle;

  /// When set `hint` whithout [fieldDecoration]
  /// it include suggestion field's hint & label.
  final String hint;

  /// onChanged stringed function for set value.
  final Function(String) onChanged;

  /// Custom icon as traling to `SuggestionItem`.
  final Icon trallingIcon;

  /// to set custom InputDecoration for `suggestionField`
  final InputDecoration fieldDecoration;

  /// to set custom TextInputType.
  final TextInputType fieldType;

  /// For controle size of `suggestionField`.
  final int maxLines;

  /// For dissable default `onTap` method of `SuggestionItem`.
  final bool disabledDefaultOnTap;

  /// For dissable default `onIconTap` method of `SuggestionItem`.
  final bool disabledDefaultOnIconTap;

  /// To do or don't closing `suggestionBox` after tapping -`SuggestionItem`.
  final bool closeBoxAfterSelect;

  ///
  final String errorText;

  SuggestionField({
    Key key,

    // You can't blank this properties.
    @required this.textController,
    @required this.suggestionList,

    // suggestionBox properties
    this.suggestionBoxDecoration,
    this.divider,
    this.wDivider = false,
    this.sizeByItem,
    this.onValueChanged,
    this.closeBoxAfterSelect = true,

    // SuggestionItem properties
    this.suggestionItemStyle = SuggestionItemStyle.DefaultStyle,
    this.onTap,
    this.onIconTap,
    this.trallingIcon,
    this.disabledDefaultOnTap = false,
    this.disabledDefaultOnIconTap = false,

    // suggestionField properties
    this.hint,
    this.fieldDecoration,
    this.fieldType,
    this.maxLines,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  @override
  SuggestionFieldState createState() => SuggestionFieldState();
}

class SuggestionFieldState extends DevExamState<SuggestionField> {
  /// for controle [suggestionBox]
  bool showSuggestionBox = false;

  /// to collect and list the `widget.suggestionList` elements matching the text of the `widget.textController` in a list.
  List<dynamic> _matchers = <dynamic>[];

  // Default overlay.
  OverlayEntry overlayEntry;

  /// node for focus `suggestionField`
  FocusNode _node = FocusNode();

  LayerLink _layerLink = LayerLink();

  // Overly list to manage overlays easily.
  List overlaysList = [];

  @override
  void initState() {
    super.initState();
    widget.textController.addListener(_textListener);
  }

  void _textListener() {
    if (widget.textController.text.length > 0) {
      // first clear all matcher items.
      _matchers.clear();

      if (_matchers.length == 0) {
        _customSetState(setState(() {
          showSuggestionBox = false;
        }));
      }

      /// And upper case every item which are into `widget.suggestionList`
      /// to for easy separation. by listening `widget.textController`.
      widget.suggestionList.forEach((f) {
        if (f.toUpperCase().contains(
              widget.textController.text.toUpperCase(),
            )) _matchers.add(f);
      });

      // If cases for controle/manage `suggestionBox` with following custom properties
      if (_matchers.length > 0) {
        if (_matchers.length == 1 &&
            _matchers[0] == widget.textController.text) {
          if (widget.closeBoxAfterSelect) {
            showSuggestionBox = false;
          } else {
            showSuggestionBox = true;
          }
        } else {
          showSuggestionBox = true;
        }
      } else {
        showSuggestionBox = false;
      }
      _customSetState(setState(() {}));
    } else {
      _customSetState(
        setState(() {
          showSuggestionBox = false;
        }),
      );
    }

    if (showSuggestionBox)
      showBox();
    else
      closeBox();
  }

  void _customSetState(void setS) {
    if (this.mounted) return setS;
  }

  /// Custom method for show suggestionBox.
  /// so creating overlay by listening `overlaysList`.
  void showBox() {
    if (overlayEntry != null) {
      if (overlaysList.isNotEmpty) {
        overlayEntry.remove();
        setState(() => overlayEntry = null);
      }
    }
    _createOverlay(context);
  }

  /// Custom method for close suggestionBox.
  /// so removing overlay by listening `overlaysList`.
  void closeBox() {
    if (overlayEntry != null) {
      if (overlaysList.isNotEmpty) {
        overlayEntry.remove();
        setState(() => overlayEntry = null);
      }
    }
  }

  // default item tap method.
  _onItemTap(String selectedItem) {
    if (widget.disabledDefaultOnTap != null &&
        widget.disabledDefaultOnTap != false) {
      if (widget.onValueChanged != null) widget.onValueChanged(selectedItem);
      widget.onTap();
    } else {
      _customSetState(setState(() {
        widget.textController.text = selectedItem;
        widget.textController.selection = TextSelection.fromPosition(
            TextPosition(offset: widget.textController.text.length));

        // custom onChanged method.
        if (widget.onValueChanged != null) widget.onValueChanged(selectedItem);
      }));
      if (widget.onTap != null) widget.onTap();
      closeBox();
    }
  }

  // tralling tap method.
  _onTrallingTap(String selectedItem) {
    if (widget.disabledDefaultOnIconTap != null &&
        widget.disabledDefaultOnIconTap != false) {
      widget.onIconTap();
    } else {
      widget.suggestionList.remove(selectedItem);
      _matchers.remove(selectedItem);
      if (widget.onIconTap != null) widget.onIconTap();
      if (_matchers.length == 0) {
        closeBox();
        _customSetState(setState(() {
          showSuggestionBox = false;
        }));
      }
      _customSetState(setState(() {}));
      showBox();
    }
  }

  @override
  Widget build(BuildContext context) => suggestionField();

  void _createOverlay(BuildContext context) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 5.0),
          child: buildSuggestionBox(context),
        ),
      ),
    );
    Overlay.of(context).insert(overlayEntry);
    overlaysList.clear();
    overlaysList.add(overlayEntry);
  }

  Widget buildSuggestionBox(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: _getRightBoxDecoration(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
            maxHeight: _getRightMaxHeight(),
          ),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _matchers.length,
            separatorBuilder: (context, index) {
              if (widget.wDivider != null && widget.wDivider != false) {
                if (widget.divider != null) {
                  return widget.divider;
                } else {
                  return Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: 1,
                    color: Colors.black.withOpacity(.3),
                  );
                }
              } else
                return SizedBox(width: 0, height: 0);
            },
            itemBuilder: (context, index) {
              return suggestionListItem(index);
            },
          ),
        ),
      ),
    );
  }

  Container suggestionListItem(int index) => Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: _SuggestionItem(
                title: "${_matchers[index]}",
                style: widget.suggestionItemStyle,
                onTap: () => _onItemTap(_matchers[index]),
                onIconTap: () => _onTrallingTap(_matchers[index]),
              ),
            ),
          ],
        ),
      );

  Widget suggestionField() => CompositedTransformTarget(
        link: _layerLink,
        child: TextField(
          keyboardType: widget.fieldType,
          focusNode: _node,
          onChanged: widget.onChanged,
          controller: widget.textController,
          maxLines: (widget.maxLines != null) ? widget.maxLines : 1,
          decoration: (widget.fieldDecoration != null)
              ? widget.fieldDecoration
              : buildInputDecoration(),
        ),
      );

  double _getRightMaxHeight() {
    double size;
    if (widget.suggestionItemStyle ==
            SuggestionItemStyle.WhiteNeumorphismedStyle ||
        widget.wDivider == true ||
        widget.suggestionItemStyle ==
            SuggestionItemStyle.BlackNeumorphismedStyle) {
      if (widget.suggestionItemStyle ==
              SuggestionItemStyle.WhiteNeumorphismedStyle ||
          widget.suggestionItemStyle ==
              SuggestionItemStyle.BlackNeumorphismedStyle ||
          widget.suggestionItemStyle ==
                  SuggestionItemStyle.BlueNeumorphismedStyle &&
              widget.wDivider == true) {
        size = 70;
      }
      size = 65;
    } else {
      size = 60;
    }
    if (widget.sizeByItem != null) {
      if (widget.sizeByItem == 1) {
        return size;
      } else {
        return size * widget.sizeByItem.roundToDouble();
      }
    } else {
      if (_matchers.length == 1) {
        return size;
      } else {
        return size * 3.toDouble();
      }

      /*
      if (_matchers.length == 1) {
        return size;
      } else if (_matchers.length == 2) {
        return size * _matchers.length.roundToDouble();
      } else {
        return size * 3.toDouble();
      }
      */
    }
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      errorText: widget.errorText,
      hintText: widget.hint,
      errorStyle: TextStyle(color: Colors.red),
      hintStyle: TextStyle(
        color: Colors.black.withOpacity(.8),
        fontSize: 18,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: devExam.theme.darkExamBlue),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.black),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 2, color: Colors.red),
      ),
      focusedErrorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          width: 2,
          color: Colors.red,
        ),
      ),
      enabled: true,
    );
  }

  Decoration _getRightBoxDecoration() {
    if (widget.suggestionBoxDecoration != null) {
      return widget.suggestionBoxDecoration;
    } else {
      return BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            spreadRadius: 10,
            offset: Offset(0, 5),
            color: widget.suggestionItemStyle.shadowcolor.withOpacity(.3) ??
                Colors.black.withOpacity(.2),
            blurRadius: 10,
          )
        ],
      );
    }
  }
}

/// Custom private widget, for build `SuggestionItem`
class _SuggestionItem extends StatelessWidget {
  final SuggestionItemStyle style;
  final Function onTap;
  final Function onIconTap;
  final String title;

  const _SuggestionItem({
    Key key,
    @required this.style,
    @required this.onTap,
    @required this.onIconTap,
    @required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: style.margin,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        border: style.border,
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
        gradient: style.gradient,
      ),
      child: ListTile(
        hoverColor: Colors.transparent,
        onTap: onTap,
        title: Text(
          title,
          style: style.titleStyle,
        ),
        trailing: IconButton(
          icon: Icon(style.icon, color: style.iconColor, size: style.iconSize),
          onPressed: onIconTap,
        ),
      ),
    );
  }
}
