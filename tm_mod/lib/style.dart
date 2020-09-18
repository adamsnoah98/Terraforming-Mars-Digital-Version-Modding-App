import 'package:flutter/material.dart';

const LargeTextSize = 26.0;
const MediumTextSize = 20.0;
const BodyTextSize = 16.0;

const String FontDefault = 'Baloo_Da_2';

const AppBarTextStyle = TextStyle( // for app bars and banners
  fontFamily: FontDefault,
  fontWeight: FontWeight.w400,
  fontSize: MediumTextSize,
  color: Colors.white,
);

const TitleTextStyle = TextStyle( // for page/alert titles
  fontFamily: FontDefault,
  fontWeight: FontWeight.w700,
  fontSize: MediumTextSize,
  color: Colors.black,
);

const HeaderTextStyle = TextStyle( // for section headers (lists, etc.)
  fontFamily: FontDefault,
  fontWeight: FontWeight.w400,
  fontSize: MediumTextSize,
  color: Colors.black,
);

const BodyTextStyle = TextStyle( // for normal text
  fontFamily: FontDefault,
  fontWeight: FontWeight.w400,
  fontSize: BodyTextSize,
  color: Colors.black,
);

const PrimaryColor = Colors.blueGrey;
const DefaultColor = Colors.white;
const WeakLineColor = Color.fromRGBO(96, 125, 139, 0.5);
const SheetColor = Color.fromRGBO(207, 216, 220, 1.0);
const SelectedBackgroundColor = Color.fromRGBO(207, 216, 220, 0.5);

const DefaultRadius = 25.0;
const HeaderContainerHeight = 50.0;