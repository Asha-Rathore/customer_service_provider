import 'package:flutter/material.dart';

class CustomRefreshIndicatorWidget extends StatelessWidget {
  final Widget? child;
  final Future<void> Function() onRefresh;
  const CustomRefreshIndicatorWidget({Key? key,this.child,required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh, child: child!,);
  }
}
