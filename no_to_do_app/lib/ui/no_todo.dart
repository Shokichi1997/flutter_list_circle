      import 'package:flutter/cupertino.dart';
      import 'package:flutter/material.dart';
      import 'dart:math';

      const SCALE_FRACTION = 0.15; //small circle 0.15
      const FULL_SCALE = 0.5; //0.5
      const PAGER_HEIGHT = 200.0;

      class ItCrowdPage extends StatefulWidget {
        @override
        _ItCrowdPageState createState() => _ItCrowdPageState();
      }

      class _ItCrowdPageState extends State<ItCrowdPage> {
        double viewPortFraction = 1/5;

        PageController pageController;

        int currentPage = 4;

        List<Map<String, String>> listOfCharacters = [
          {'image': "#140125", 'name': "Richmond"},
          {'image': "#FF01FF",'name': "Roy"},
          {'image': "#CC99AA", 'name': "Moss"},
          {'image': "#AACCCC", 'name': "Douglas"},
          {'image': "#775522", 'name': "Jen"},
          {'image': "#331144", 'name': "Moss 1"},
          {'image': "#991245", 'name': "Moss 2"},
          {'image': "#784511", 'name': "Moss 3"},
          {'image': "#CA15AA", 'name': "Moss 4"},

        ];

        double page = 4.0;

        @override
        void initState() {
          pageController =
              PageController(initialPage: currentPage, viewportFraction: viewPortFraction);
          super.initState();
        }

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 1,
              centerTitle: true,
              backgroundColor: Colors.indigo,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "The IT Crowd",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            body: ListView(
              children: <Widget>[
                SizedBox(height: 20,),
                Container(
                  height: PAGER_HEIGHT,

                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification notification) {
                      if (notification is ScrollUpdateNotification) {
                        setState(() {
                          page = pageController.page;
                        });

                      }
                      return true;
                    },
                    child: Container(
                      margin: EdgeInsets.all(5.2),
                      child: SizedBox(
                        width: page == currentPage ? 200 : 50,
                        child: Center(
                          child: PageView.builder(

                            reverse: true,
                            onPageChanged: (pos) {
                              setState(() {
                                currentPage = pos;
                              });
                            },
                            physics: BouncingScrollPhysics(),

                            controller: pageController,
                            itemCount: listOfCharacters.length,
                            itemBuilder: (context, index) {
                              final scale =
                              max(SCALE_FRACTION, (FULL_SCALE - (index - page).abs()) + viewPortFraction);
                              return circleOffer(
                                  listOfCharacters[index]['image'], scale, index);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    listOfCharacters[currentPage]['name'],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),

              ],
            ),
          );
        }

        Widget circleOffer(String color, double scale, int index) {
          color = color.replaceAll('#', '0xff');
          double sizeCircleSmall = page == index ? 50 * (scale * 1) : 30 * (scale);

          return Container(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: PAGER_HEIGHT * scale,
                width: PAGER_HEIGHT * scale,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    new Container(
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(int.parse(color)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Align (
                        alignment: Alignment.center,
                        child: new Container(
                          width: sizeCircleSmall,
                          height: sizeCircleSmall,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white),
                          alignment: Alignment.center,
                          child: new Text("A",
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        }
      }