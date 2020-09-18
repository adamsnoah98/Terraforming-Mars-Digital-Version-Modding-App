import 'package:flutter/cupertino.dart';
import 'package:tm_modder/style.dart';

class CustomDiv extends StatelessWidget {

  final double vPadding;
  final double _divHeight = 1;

  CustomDiv({this.vPadding = 2});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2*vPadding + _divHeight,
      color: DefaultColor.withOpacity(0.01),
      child: Padding(
        padding:EdgeInsets.symmetric(horizontal:10.0, vertical: vPadding),
        child: Container(
          height: _divHeight,
          width: MediaQuery.of(context).size.width * 0.9,
          color: PrimaryColor.withOpacity(0.5),
        ),
      ),
    );
  }
}