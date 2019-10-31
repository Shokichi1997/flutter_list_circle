import 'package:flutter/material.dart';
import 'package:no_to_do_app/ui/no_todo_item.dart';
import 'package:no_to_do_app/ui/picker.dart';
import 'package:no_to_do_app/ui/tt.dart';

import 'no_todo.dart';

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  int _currentValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text("Test"),),
      body: Container(
        child: Center(
          child: new NumberPicker.integer(
              initialValue: _currentValue,
              minValue: 0,
              maxValue: 15,
              infiniteLoop: true,
              onChanged: (newValue) =>
                  setState(() { _currentValue = newValue;
                  })),
        ),
      //child: ExampleSwiperInScrollView()  ,
      ),

    );
  }
}
