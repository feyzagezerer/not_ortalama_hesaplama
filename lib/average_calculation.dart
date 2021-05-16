import 'dart:math';

import 'package:flutter/material.dart';
import 'package:not_ortalama_hesaplama/models/lesson.dart';

class AverageCalculation extends StatefulWidget {
  @override
  _AverageCalculationState createState() => _AverageCalculationState();
}

class _AverageCalculationState extends State<AverageCalculation> {
  String lessonName;
  int lessonCredit = 1;
  double lessonletterValue = 4;
  List<Lesson> allLessons;
  static int counter = 0;

  var formKey = GlobalKey<FormState>();
  double average = 0;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allLessons = [];
  }

  void showSnackBar(String content) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Ortalama Hesaplama",
          style: TextStyle(color: Colors.purple, fontSize: 28),
        ),
        elevation: 3,
      ),
      floatingActionButton: FloatingActionButton(
        hoverColor: Colors.purple,
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
          }
        },
        child: Text("Ders Ekle", textAlign: TextAlign.center),
      ),
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.endFloat, -2, -41),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return ui();
        } else {
          return uiLandscape();
        }
      }),
    );
  }

  Widget ui() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ders Adı",
                          filled: true,
                          fillColor: Colors.purple.shade100,
                          isCollapsed: false,
                          hintText: "Ders adını giriniz.",
                          hintStyle: TextStyle(fontSize: 20),
                          labelStyle: TextStyle(fontSize: 22),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.length > 0) {
                            return null;
                          } else
                            return "Lütfen ders adı girin.";
                        },
                        onSaved: (value) {
                          lessonName = value;
                          setState(() {
                            allLessons.add(Lesson(lessonName, lessonletterValue,
                                lessonCredit, randomColor()));
                            average = 0;
                            calculateAverage();
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                iconEnabledColor: Colors.white,
                                dropdownColor: Colors.purple,
                                items: creditItems(),
                                value: lessonCredit,
                                onChanged: (chosenValue) {
                                  setState(() {
                                    lessonCredit = chosenValue;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                iconEnabledColor: Colors.white,
                                dropdownColor: Colors.purple,
                                items: letterValuesItems(),
                                value: lessonletterValue,
                                onChanged: (chosenValue) {
                                  setState(() {
                                    lessonletterValue = chosenValue;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 26, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            decoration: BoxDecoration(
                color: Colors.purple,
                border: BorderDirectional(
                  top: BorderSide(color: Colors.purple.shade400, width: 2),
                  bottom: BorderSide(color: Colors.purple.shade600, width: 2),
                )),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: allLessons.length == 0
                            ? "Ortalama: 0.0 "
                            : "Ortalama: ",
                        style: TextStyle(fontSize: 26, color: Colors.white)),
                    TextSpan(
                        text: allLessons.length == 0
                            ? ""
                            : "${average.toStringAsFixed(2)}",
                        style: TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Card(
            elevation: 15,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListView.builder(
              itemBuilder: _createListItems,
              itemCount: allLessons.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget uiLandscape() {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                //color: Colors.pink.shade200,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ders Adı",
                          hintText: "Ders adını giriniz",
                          hintStyle: TextStyle(fontSize: 18),
                          labelStyle: TextStyle(fontSize: 22),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 3),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.purple, width: 3),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value.length > 0) {
                            return null;
                          } else
                            return "Lütfen ders adını girin.";
                        },
                        onSaved: (value) {
                          lessonName = value;
                          setState(() {
                            allLessons.add(Lesson(lessonName, lessonletterValue,
                                lessonCredit, randomColor()));
                            average = 0;
                            calculateAverage();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: creditItems(),
                                iconEnabledColor: Colors.white,
                                dropdownColor: Colors.purple,
                                value: lessonCredit,
                                onChanged: (chosenValue) {
                                  setState(() {
                                    lessonCredit = chosenValue;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                items: letterValuesItems(),
                                iconEnabledColor: Colors.white,
                                dropdownColor: Colors.purple,
                                value: lessonletterValue,
                                onChanged: (chosenValue) {
                                  setState(() {
                                    lessonletterValue = chosenValue;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                color: Colors.purple,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.purple,
                      border: BorderDirectional(
                        top: BorderSide(color: Colors.grey, width: 2),
                        bottom: BorderSide(color: Colors.grey, width: 2),
                      )),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: allLessons.length == 0
                                  ? "Ortalama: 0.0 "
                                  : "Ortalama: ",
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white)),
                          TextSpan(
                              text: allLessons.length == 0
                                  ? ""
                                  : "${average.toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 30,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          flex: 1,
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemBuilder: _createListItems,
              itemCount: allLessons.length,
            ),
          ),
        ),
      ],
    ));
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DropdownMenuItem<int>> creditItems() {
    List<DropdownMenuItem<int>> credits = [];

    for (int i = 1; i <= 10; i++) {
      credits.add(DropdownMenuItem<int>(
        value: i,
        child: Text(
          "$i Kredi",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ));
    }

    return credits;
  }

  List<DropdownMenuItem<double>> letterValuesItems() {
    List<DropdownMenuItem<double>> letters = [];
    letters.add(DropdownMenuItem(
      child: Text(
        " AA ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 4,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " BA ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 3.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " BB ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 3,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " CB ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 2.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " CC ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 2,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " DC ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 1.5,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " DD ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 1,
    ));
    letters.add(DropdownMenuItem(
      child: Text(
        " FF ",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      value: 0,
    ));

    return letters;
  }

  Widget _createListItems(BuildContext context, int index) {
    counter++;
    debugPrint(counter.toString());

    return Dismissible(
      key: Key(counter.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          allLessons.removeAt(index);
          calculateAverage();
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: allLessons[index].color, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.all(4),
        child: ListTile(
          leading: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Icon(
              Icons.circle,
              size: 20,
              color: allLessons[index].color,
            ),
          ),
          title: Text(allLessons[index].name),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: allLessons[index].color,
          ),
          subtitle: Text(allLessons[index].credit.toString() +
              " kredi dersin not değeri:" +
              allLessons[index].letterValue.toString()),
        ),
      ),
    );
  }

  void calculateAverage() {
    double totalPoint = 0;
    double totalCredit = 0;

    for (var nowLesson in allLessons) {
      //simdiki ders
      var credit = nowLesson.credit;
      var letterValue = nowLesson.letterValue;

      totalPoint = totalPoint + (letterValue * credit);
      totalCredit += credit;
    }

    average = totalPoint / totalCredit;
  }

  Color randomColor() {
    return Color.fromARGB(200 + Random().nextInt(55), Random().nextInt(255),
        Random().nextInt(255), Random().nextInt(255));
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // Offset in X direction
  double offsetY; // Offset in Y direction
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
