import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:infinite_listview/infinite_listview.dart';

class ExampleSwiperInScrollView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ExampleState();
  }
}

class _ExampleState extends State<ExampleSwiperInScrollView> {
  ScrollController _infiniteScrollController = new InfiniteScrollController(
    initialScrollOffset: 4,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InfiniteListView.separated(
        scrollDirection: Axis.horizontal,

          controller: _infiniteScrollController,
          itemBuilder: (BuildContext context, int index){
            return Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    height:  index % 2 == 0 ? 100 : 30,
                    width:  index % 2 == 0 ? 100 : 30,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        new Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new Align (
                            alignment: Alignment.center,
                            child: new Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white),
                              alignment: Alignment.center,
                              child: new Text(index.toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            );
          },
          separatorBuilder: (BuildContext context, int index) => Divider(height: 2.0),

      ),
    );
  }


}