
import 'package:flutter/material.dart';

class CustomScrollPhysics extends ScrollPhysics {

  const CustomScrollPhysics({ScrollPhysics parent})
      : super(parent: parent);

  @override
  double get minFlingVelocity => 50.0;

  @override
  double get maxFlingVelocity => 50.0;

  @override
  double get minFlingDistance => 30.0;


  @override
  ScrollPhysics applyTo(ScrollPhysics ancestor) {
    return CustomScrollPhysics();
  }

}