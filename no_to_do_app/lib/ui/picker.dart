import 'dart:math' as math;

import 'package:circle_list/circle_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:no_to_do_app/ui/custom_scroll_physics.dart';

/// Created by Marcin Szałek

///NumberPicker is a widget designed to pick a number between #minValue and #maxValue
class NumberPicker extends StatelessWidget {
  ///height of every list element for normal number picker
  ///width of every list element for horizontal number picker
  static const double kDefaultItemExtent = 30;

  ///width of list view for normal number picker
  ///height of list view for horizontal number picker
  static const double kDefaultListViewCrossAxisSize = 350.0;

  ///constructor for horizontal number picker
  NumberPicker.horizontal({
    Key key,
    @required int initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.itemExtent = kDefaultItemExtent,
    this.listViewHeight = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = new ScrollController(
          initialScrollOffset:
              4 ~/ step * itemExtent, //(initialValue - minValue)
        ),
        scrollDirection = Axis.vertical,
        decimalScrollController = null,
        listViewWidth = 350,
        infiniteLoop = false,
        integerItemCount = (maxValue - minValue) ~/ step + 1,
        super(key: key);

  ///constructor for integer number picker
  NumberPicker.integer({
    Key key,
    @required int initialValue,
    @required this.minValue,
    @required this.maxValue,
    @required this.onChanged,
    this.itemExtent = kDefaultItemExtent,
    this.listViewWidth = kDefaultListViewCrossAxisSize,
    this.step = 1,
    this.scrollDirection = Axis.horizontal,
    this.infiniteLoop = false,
    this.zeroPad = false,
    this.highlightSelectedValue = true,
    this.decoration,
  })  : assert(initialValue != null),
        assert(minValue != null),
        assert(maxValue != null),
        assert(maxValue > minValue),
        assert(initialValue >= minValue && initialValue <= maxValue),
        assert(step > 0),
        assert(scrollDirection != null),
        selectedIntValue = initialValue,
        selectedDecimalValue = -1,
        decimalPlaces = 0,
        intScrollController = infiniteLoop
            ? new InfiniteScrollController(
                initialScrollOffset:
                    (initialValue - minValue) ~/ step * itemExtent,
              )
            : new ScrollController(
                initialScrollOffset:
                    (initialValue - minValue) ~/ step * itemExtent,
              ),
        decimalScrollController = null,
        listViewHeight = 350,
        integerItemCount = (maxValue - minValue) ~/ step + 1,
        super(key: key);


  ///called when selected value changes
  final ValueChanged<num> onChanged;

  ///min value user can pick
  final int minValue;

  ///max value user can pick
  final int maxValue;

  ///inidcates how many decimal places to show
  /// e.g. 0=>[1,2,3...], 1=>[1.0, 1.1, 1.2...]  2=>[1.00, 1.01, 1.02...]
  final int decimalPlaces;

  ///height of every list element in pixels
  final double itemExtent;

  ///height of list view in pixels
  final double listViewHeight;

  ///width of list view in pixels
  final double listViewWidth;

  ///ScrollController used for integer list
  final ScrollController intScrollController;

  ///ScrollController used for decimal list
  final ScrollController decimalScrollController;

  ///Currently selected integer value
  final int selectedIntValue;

  ///Currently selected decimal value
  final int selectedDecimalValue;

  ///If currently selected value should be highlighted
  final bool highlightSelectedValue;

  ///Decoration to apply to central box where the selected value is placed
  final Decoration decoration;



  ///Step between elements. Only for integer datePicker
  ///Examples:
  /// if step is 100 the following elements may be 100, 200, 300...
  /// if min=0, max=6, step=3, then items will be 0, 3 and 6
  /// if min=0, max=5, step=3, then items will be 0 and 3.
  final int step;

  /// Direction of scrolling
  final Axis scrollDirection;

  ///Repeat values infinitely
  final bool infiniteLoop;

  ///Pads displayed integer values up to the length of maxValue
  final bool zeroPad;

  ///Amount of items
  final int integerItemCount;

  /**
   *
   */
  static double currentPixelScroll = 0.0;
  ScrollPhysics scrollPhysics = new ScrollPhysics();


  //
  //----------------------------- PUBLIC ------------------------------
  //

  /// Used to animate integer number picker to new selected value
  void animateInt(int valueToSelect) {
    int diff = valueToSelect - minValue;
    int index = diff ~/ step;
    animateIntToIndex(index);
  }

  /// Used to animate integer number picker to new selected index
  void animateIntToIndex(int index) {
    _animate(intScrollController, index * itemExtent);
  }

  /// Used to animate decimal part of double value to new selected value
  void animateDecimal(int decimalValue) {
    _animate(decimalScrollController, decimalValue * itemExtent);
  }

  /// Used to animate decimal number picker to selected value
  void animateDecimalAndInteger(double valueToSelect) {
    animateInt(valueToSelect.floor());
    animateDecimal(((valueToSelect - valueToSelect.floorToDouble()) *
            math.pow(10, decimalPlaces))
        .round());
  }

  //
  //----------------------------- VIEWS -----------------------------
  //


  ///main widget
  @override
  Widget build(BuildContext context) {
    scrollPhysics.maxFlingVelocity;
    final ThemeData themeData = Theme.of(context);
      return _integerInfiniteListView(themeData);

  }




  Widget _integerInfiniteListView(ThemeData themeData) {
    TextStyle defaultStyle = themeData.textTheme.body1
        .copyWith(fontSize: 11, fontWeight: FontWeight.w900);
    TextStyle selectedStyle = themeData.textTheme.headline.copyWith(
        color: Colors.black, fontWeight: FontWeight.w900, fontSize: 24);


    return Listener(
      onPointerUp: (ev) {
        ///used to detect that user stopped scrolling
        if (intScrollController.position.activity is HoldScrollActivity) {
          _animateIntWhenUserStoppedScrolling(selectedIntValue);
        }
      },
      child: new NotificationListener<ScrollNotification>(
        child: new Container(
          height: listViewHeight,

          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Flexible(
                    child: InfiniteListView.builder(

                      controller: intScrollController,
                      //itemExtent: itemExtent,
                      physics: CustomScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final int value = _intValueFromIndex(index);

                        //define special style for selected (middle) element
                        final TextStyle itemStyle =
                        value == selectedIntValue && highlightSelectedValue
                            ? selectedStyle
                            : defaultStyle;

                        return Container(
                          width: (value == selectedIntValue &&
                              highlightSelectedValue)
                              ? 120
                              : 30,
                          child: new Center(
                            child: new Container(
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  new Container(
                                    margin: EdgeInsets.all(2.0),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  new Align (
                                    alignment: Alignment.center,
                                    child: new Container(
                                      width: (value == selectedIntValue &&
                                          highlightSelectedValue) ? 40 : 15,
                                      height: (value == selectedIntValue &&
                                          highlightSelectedValue) ? 40 : 15,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      alignment: Alignment.center,
                                      child: new Text(
                                          value
                                              .toString()
                                              .padLeft(decimalPlaces, '0'),
                                          style: itemStyle),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  ),
                ],
              ),
              _NumberPickerSelectedItemDecoration(
                axis: scrollDirection,
                itemExtent: itemExtent,
                decoration: decoration,
              ),
            ],
          ),
        ),
        onNotification: _onIntegerNotification,
      ),
    );
  }

  String getDisplayedValue(int value) {
    return zeroPad
        ? value.toString().padLeft(maxValue.toString().length, '0')
        : value.toString();
  }

  //
  // ----------------------------- LOGIC -----------------------------
  //

  int _intValueFromIndex(int index) {
    index--;
    index %= integerItemCount;
    return minValue + index * step;
  }



  bool _onIntegerNotification(Notification notification){
    if (notification is ScrollNotification) {
      //calculate
//      int center = (((330 - 3 * itemExtent) ~/ itemExtent));
//      int intIndexOfMiddleElement =
//      (notification.metrics.pixels / itemExtent + center/2).toInt();
//      print("current= ${notification.metrics.pixels}" );
//      if(((notification.metrics.pixels - currentPixelScroll).abs() > (itemExtent * 1))){
//        //6
//        int devide = 6;
//
//        int numRound = ((notification.metrics.pixels -  currentPixelScroll) ~/ (itemExtent * 11)) ;
//        int pixeld = numRound * 3;
//
//
//        if((notification.metrics.pixels - currentPixelScroll) < 0){
//          intIndexOfMiddleElement += pixeld;
//        }
//        else{
//          intIndexOfMiddleElement -= 2;
//        }
//      }
//      currentPixelScroll = notification.metrics.pixels;

      int intIndexOfMiddleElement =
      (notification.metrics.pixels ~/ itemExtent);


      int intValueInTheMiddle =
          _intValueFromIndex(intIndexOfMiddleElement);
      intValueInTheMiddle = _normalizeIntegerMiddleValue(intValueInTheMiddle + 4);

      if (_userStoppedScrolling(notification, intScrollController)) {
        //center selected value
        animateIntToIndex(intIndexOfMiddleElement);
      }

      //update selection
      if (intValueInTheMiddle != selectedIntValue) {
        num newValue;
        if (decimalPlaces == 0) {
          //return integer value
          newValue = (intValueInTheMiddle);
        } else {
          if (intValueInTheMiddle == maxValue) {
            //if new value  is maxValue, then return that value and ignore decimal
            newValue = (intValueInTheMiddle.toDouble());
            animateDecimal(0);
          } else {
            //return integer+decimal
            double decimalPart = _toDecimal(selectedDecimalValue);
            newValue = ((intValueInTheMiddle + decimalPart).toDouble());

          }
        }
        onChanged(newValue);
      }

    }
    return true;
  }


  ///When overscroll occurs on iOS,
  ///we can end up with value not in the range between [minValue] and [maxValue]
  ///To avoid going out of range, we change values out of range to border values.
  int _normalizeMiddleValue(int valueInTheMiddle, int min, int max) {
    return math.max(math.min(valueInTheMiddle, max), min);
  }

  int _normalizeIntegerMiddleValue(int integerValueInTheMiddle) {
    //make sure that max is a multiple of step
    int max = (maxValue ~/ step) * step;
    return _normalizeMiddleValue(integerValueInTheMiddle, minValue, max);
  }

  ///indicates if user has stopped scrolling so we can center value in the middle
  bool _userStoppedScrolling(
    Notification notification,
    ScrollController scrollController,
  ) {
    return notification is UserScrollNotification &&
        notification.direction == ScrollDirection.idle &&
        scrollController.position.activity is! HoldScrollActivity;
  }

  /// Allows to find currently selected element index and animate this element
  /// Use it only when user manually stops scrolling in infinite loop
  void _animateIntWhenUserStoppedScrolling(int valueToSelect) {
    // estimated index of currently selected element based on offset and item extent
    int currentlySelectedElementIndex =
    (intScrollController.offset / itemExtent).round();

    // when more(less) than half of the top(bottom) element is hidden
    // then we should increment(decrement) index in case of positive(negative) offset
    if (intScrollController.offset > 0 &&
        intScrollController.offset % itemExtent > itemExtent / 2) {
      currentlySelectedElementIndex++;
    } else if (intScrollController.offset < 0 &&
        intScrollController.offset % itemExtent < itemExtent / 2) {
      currentlySelectedElementIndex--;
    }

    animateIntToIndex(currentlySelectedElementIndex);
  }

  ///converts integer indicator of decimal value to double
  ///e.g. decimalPlaces = 1, value = 4  >>> result = 0.4
  ///     decimalPlaces = 2, value = 12 >>> result = 0.12
  double _toDecimal(int decimalValueAsInteger) {
    return double.parse((decimalValueAsInteger * math.pow(10, -decimalPlaces))
        .toStringAsFixed(decimalPlaces));
  }
  ///scroll to selected value
  _animate(ScrollController scrollController, double value) {
    scrollController.animateTo(value,
        duration: new Duration(seconds: 1), curve: new ElasticOutCurve());

  }
}

class _NumberPickerSelectedItemDecoration extends StatelessWidget {
  final Axis axis;
  final double itemExtent;
  final Decoration decoration;

  const _NumberPickerSelectedItemDecoration(
      {Key key,
      @required this.axis,
      @required this.itemExtent,
      @required this.decoration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new IgnorePointer(
        child: new Container(
          width: isVertical ? double.infinity : itemExtent,
          height: isVertical ? itemExtent : double.infinity,
          decoration: decoration,
        ),
      ),
    );
  }

  bool get isVertical => axis == Axis.vertical;
}



