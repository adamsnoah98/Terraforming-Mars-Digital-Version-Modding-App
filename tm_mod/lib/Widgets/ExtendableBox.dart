import 'package:flutter/material.dart';
import 'package:tm_modder/Widgets/CustomDiv.dart';
import 'package:tm_modder/style.dart';
import 'dart:math';

class ExtendableBox extends StatefulWidget {
  final Widget child;
  final double minHeight;
  final double maxHeight;
  final double startHeight;

  ExtendableBox({@required this.child,
    @required this.minHeight,
    @required this.maxHeight,
    @required this.startHeight}) {
    assert (0 < minHeight && minHeight <= maxHeight);
    assert (minHeight <= startHeight && startHeight <= maxHeight);
  }

  State<StatefulWidget> createState() => _ExtendableBoxState(startHeight);
}

class _ExtendableBoxState extends State<ExtendableBox> {

  double _height;

  _ExtendableBoxState(this._height);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: _height,
          width: MediaQuery.of(context).size.width,
          child: widget.child,
        ),
        GestureDetector(
          child: CustomDiv(vPadding: 10,),
          onPanUpdate: (specs) {
            setState(() {
              _height += specs.delta.dy;
              _height = max(widget.minHeight, min(_height, widget.maxHeight));
            });
          },
        ),
      ],
    );
  }

}