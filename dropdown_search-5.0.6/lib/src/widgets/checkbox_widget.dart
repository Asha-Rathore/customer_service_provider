import 'package:flutter/material.dart';

typedef Widget WidgetCheckBox(BuildContext context, bool isChecked);

class CheckBoxWidget extends StatefulWidget {
  final WidgetCheckBox? layout;
  final WidgetCheckBox? checkBox;
  final bool isChecked;
  final bool isDisabled;
  final ValueChanged<bool?>? onChanged;
  final bool interceptCallBacks;
  final TextDirection textDirection;

  CheckBoxWidget({
    Key? key,
    this.isChecked = false,
    this.isDisabled = false,
    this.layout,
    this.checkBox,
    this.interceptCallBacks = false,
    this.textDirection = TextDirection.ltr,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  final ValueNotifier<bool> isCheckedNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    isCheckedNotifier.value = widget.isChecked;
  }

  @override
  void didUpdateWidget(covariant CheckBoxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isChecked != oldWidget.isChecked) isCheckedNotifier.value = widget.isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: ValueListenableBuilder(
        valueListenable: isCheckedNotifier,
        builder: (ctx, bool v, w) {
          var w = Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              widget.layout != null ? Expanded(child: widget.layout!(context, v == true)) : Container(),
              Theme(
                data: ThemeData(
                  fontFamily: "Jost_Medium",
                    unselectedWidgetColor: const Color(0xff8300C4),
                    splashColor: Colors.transparent,
                    checkboxTheme: CheckboxThemeData(
                      checkColor: MaterialStateProperty.resolveWith((_) => Color(0xff8300C4)),
                      fillColor: MaterialStateProperty.resolveWith((_) => Colors.transparent),
                      side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(width: 1.0, color: Color(0xff8300C4)),
                      ),
                    )
                  // Your color
                ),
                child: widget.checkBox != null
                    ? widget.checkBox!(context, v == true)
                    : Checkbox(value: v, onChanged: widget.isDisabled ? null : (b) {},          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                ),
              ),
            ],
          );

          if (widget.interceptCallBacks)
            return w;
          else
            return InkWell(
              onTap: widget.isDisabled
                  ? null
                  : () {
                      isCheckedNotifier.value = !v;
                      if (widget.onChanged != null) widget.onChanged!(v);
                    },
              child: IgnorePointer(child: w),
            );
        },
      ),
    );
  }
}
