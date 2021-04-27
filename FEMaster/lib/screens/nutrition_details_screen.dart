import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:random_color/random_color.dart';
import 'package:food_app/components/expansion_tile_widget.dart' as custom;


class NutritionDetailsScreen extends StatefulWidget {
  static final id = "nutrition_details_screen";

  @override
  _NutritionDetailsScreenState createState() => _NutritionDetailsScreenState();
}

class _NutritionDetailsScreenState extends State<NutritionDetailsScreen> {
  RandomColor _randomColor = RandomColor();

  Map<String, double> dataMap = {
    "Fat": 4,
    "Protein": 7,
    "Carbohydrate": 2,
  };
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF58B76E),
          toolbarHeight: MediaQuery.of(context).size.height * .07,
          centerTitle: true,
          title: Text('Full Nutrition Details'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * .93,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      height:
                      MediaQuery.of(context).size.height * .25,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        children: [
                          Text(
                            '1299 Calories',
                            style: TextStyle(
                                color: _randomColor.randomColor(
                                    colorBrightness:
                                    ColorBrightness.dark)),
                          ),
                          Text(
                            '137gm Carbs',
                            style: TextStyle(
                                color: _randomColor.randomColor(
                                    colorBrightness:
                                    ColorBrightness.dark)),
                          ),
                          Text(
                            '72.8 Fat',
                            style: TextStyle(
                                color: _randomColor.randomColor(
                                    colorBrightness:
                                    ColorBrightness.dark)),
                          ),
                          Text(
                            '183gm Protein',
                            style: TextStyle(
                                color: _randomColor.randomColor(
                                    colorBrightness:
                                    ColorBrightness.dark)),
                          ),
                          Text(
                            '1000gm Sodium',
                            style: TextStyle(
                                color: _randomColor.randomColor(
                                    colorBrightness:
                                    ColorBrightness.dark)),
                          ),
                          Text(
                            '100mg Cholesterol',
                            style: TextStyle(
                                color: _randomColor.randomColor(
                                    colorBrightness:
                                    ColorBrightness.light)),
                          ),

                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('% Calories of each Macro'),
                          PieChart(
                            dataMap: dataMap,
                            animationDuration: Duration(milliseconds: 800),
                            chartLegendSpacing: 40,
                            chartRadius: MediaQuery.of(context).size.width / 3,
                            colorList: [Colors.red,Colors.blue,Colors.green],
                            initialAngleInDegree: 0,
                            chartType: ChartType.disc,
                            ringStrokeWidth: 40,
                            //centerText: "Diet",
                            legendOptions: LegendOptions(
                              showLegendsInRow: false,
                              legendPosition: LegendPosition.bottom,
                              showLegends: false,
                              //legendShape: _BoxShape.circle,
                              legendTextStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValueBackground: true,
                              showChartValues: true,
                              showChartValuesInPercentage: false,
                              showChartValuesOutside: false,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Image.asset('images/border_line.png'),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: custom.ExpansionTile(
                  headerBackgroundColor: Colors.grey.shade300,
                  title: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Nutrition Facts",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF58B76E),
                          ),
                        ),
                        Text(
                          "% Daily Value*",
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF535252)),
                        ),
                      ],
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Fat 72.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Saturated Fat 27.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cholesterol 12.1gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Solium 100mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Potassium 752mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Carbohydrates 128gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Protein 183gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: custom.ExpansionTile(
                  headerBackgroundColor: Colors.grey.shade300,
                  title: Container(
                    child: Text(
                      "Vitamins And Minerals",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF58B76E),
                      ),
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Fat 72.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Saturated Fat 27.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cholesterol 12.1gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Solium 100mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Potassium 752mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Carbohydrates 128gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Protein 183gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: custom.ExpansionTile(
                  headerBackgroundColor: Colors.grey.shade300,
                  title: Container(
                    child: Text(
                      "Fatty Acids",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF58B76E),
                      ),
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Fat 72.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Saturated Fat 27.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cholesterol 12.1gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Solium 100mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Potassium 752mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Carbohydrates 128gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Protein 183gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: custom.ExpansionTile(
                  headerBackgroundColor: Colors.grey.shade300,
                  title: Container(
                    child: Text(
                      "Amino Acids",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF58B76E),
                      ),
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Fat 72.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Saturated Fat 27.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cholesterol 12.1gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Solium 100mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Potassium 752mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Carbohydrates 128gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Protein 183gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                //padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: custom.ExpansionTile(
                  headerBackgroundColor: Colors.grey.shade300,
                  title: Container(
                    child: Text(
                      "Sugar",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF58B76E),
                      ),
                    ),
                  ),
                  children: <Widget>[
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Fat 72.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Saturated Fat 27.8gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cholesterol 12.1gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Solium 100mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Potassium 752mg'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Carbohydrates 128gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                    Container(
                      height: 30.0,
                      padding: EdgeInsets.only(left: 15.0, right: 15.0,top: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Protein 183gm'),
                          Image.asset('images/border_line.png'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
