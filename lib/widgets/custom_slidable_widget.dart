import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../utils/asset_paths.dart';

class CustomSlidableWidget extends StatelessWidget {
  final Widget child;
  final Function()? onTapDelete, onTapEdit;
  final bool? isenable, showEditIcon;
  final double? actionExtentRatio;

  const CustomSlidableWidget(
      {super.key,
      required this.child,
      this.onTapDelete,
      this.isenable,
      this.actionExtentRatio,
      this.onTapEdit,
      this.showEditIcon = true});

  @override
  Widget build(BuildContext context) {
    return Slidable(
        actionPane: const SlidableScrollActionPane(),
        actionExtentRatio: actionExtentRatio ?? 0.15,
        enabled: isenable ?? true,
        secondaryActions: showEditIcon!
            ? [
                IconSlideAction(
                  color: Colors.transparent,
                  iconWidget: Container(
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      AssetPath.EDIT_ICON,
                      scale: 2,
                    ),
                  ),
                  onTap: onTapEdit,
                ),
                IconSlideAction(
                  color: Colors.transparent,
                  iconWidget: Container(
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      AssetPath.TRASH_ICON,
                      scale: 3,
                    ),
                  ),
                  onTap: onTapDelete,
                ),
              ]
            : [
                IconSlideAction(
                  color: Colors.transparent,
                  iconWidget: Container(
                    decoration: BoxDecoration(),
                    child: Image.asset(
                      AssetPath.TRASH_ICON,
                      scale: 3.5,
                    ),
                  ),
                  onTap: onTapDelete,
                ),
              ],
        child: child);
  }
}
