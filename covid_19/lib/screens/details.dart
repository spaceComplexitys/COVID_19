import 'package:covid19/screens/Home.dart';
import 'package:flutter/material.dart';
import 'package:covid19/widgets/my_header.dart';
import 'package:covid19/widgets/counter.dart';
import 'package:covid19/constant.dart';
import 'package:intl/intl.dart';
import 'package:covid19/networking/data.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final controller = ScrollController();
  double offset = 0;

  static DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMMM d').format(now);

  // String data for cases
  String confirmed;
  String death;
  String recover;

  String todayCases;
  String todayDeaths;

  String active;
  String critical;
  String tests;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(onScroll);
    getDataDetails();
    confirmed = Data.totalConfirm;
    death = Data.totalDeath;
    recover = Data.totalRecover;

    todayCases = Data.totalTodayCases;
    todayDeaths = Data.totalTodayDeaths;

    active = Data.totalActive;
    critical = Data.totalCritical;
    tests = Data.totalTests;

    getDataDetails();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  bool isWaiting = false;

  Map<String, String> coronaValues = {};

  void getDataDetails() async {
    isWaiting = true;
    try {
      var data = await Data().getCoronaData(HomeScreen.selectedCountry);
      isWaiting = false;
      setState(() {
        confirmed = Data.totalConfirm;
        death = Data.totalDeath;
        recover = Data.totalRecover;

        todayCases = Data.totalTodayCases;
        todayDeaths = Data.totalTodayDeaths;

        active = Data.totalActive;
        critical = Data.totalCritical;
        tests = Data.totalTests;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: controller,
        child: Column(
          children: <Widget>[
            MyHeader(
              image: "assets/icons/Drcorona.svg",
              textTop: "All you need",
              textBottom: "is stay at home.",
              offset: offset,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Case Update\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: 'As of ' + formattedDate, // TOdo
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: '$confirmed',
                          title: "Infected",
                        ),
                        Counter(
                          color: kDeathColor,
                          number: '$death',
                          title: "Deaths",
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: '$recover',
                          title: "Recovered",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Cases Update Today\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: 'As of ' + formattedDate, // TOdo
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: '$todayCases',
                          title: "todayCases",
                        ),
                        Counter(
                          color: kDeathColor,
                          number: '$todayDeaths',
                          title: "todayDeaths",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Status\n",
                              style: kTitleTextstyle,
                            ),
                            TextSpan(
                              text: 'As of ' + formattedDate, // TOdo
                              style: TextStyle(
                                color: kTextLightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Counter(
                          color: kInfectedColor,
                          number: '$tests',
                          title: "TotalTests",
                        ),
                        Counter(
                          color: kRecovercolor,
                          number: '$active',
                          title: "Active",
                        ),
                        Counter(
                          color: kDeathColor,
                          number: '$critical',
                          title: "Critical",
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
