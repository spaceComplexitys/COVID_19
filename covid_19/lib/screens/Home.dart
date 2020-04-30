import 'package:covid19/constant.dart';
import 'package:covid19/widgets/counter.dart';
import 'package:covid19/widgets/my_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:core';
import 'package:number_display/number_display.dart';
import 'package:covid19/networking/data.dart';
import 'package:intl/intl.dart';
import 'package:covid19/screens/details.dart';
import 'package:covid19/user.dart';
import 'package:covid19/widgets/row.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:covid19/screens/details.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  static String selectedCountry = "World";
}

class _HomeScreenState extends State<HomeScreen> {
  AutoCompleteTextField searchTextField;
  GlobalKey<AutoCompleteTextFieldState<User>> key = new GlobalKey();
  static List<User> loadUsers(String jsonString) {
    final parsed = json.decode(jsonString).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  static List<User> users = new List<User>();
  bool loading = true;

  void getUsers() async {
    try {
      final response =
          await http.get("https://coronavirus-19-api.herokuapp.com/countries");
      if (response.statusCode == 200) {
        users = loadUsers(response.body);
        print('Users: ${users.length}');
        setState(() {
          loading = false;
        });
      } else {
        print("Error getting users.");
      }
    } catch (e) {
      print("Error getting users.");
    }
  }

  final controller = ScrollController();
  double offset = 0;
  int total = 0;
  final display = createDisplay(length: 4);
//  static String selectedItem = "USA";
  TextEditingController emailController = new TextEditingController();

  String confirmed;
  String death;
  String recover;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsers();
    controller.addListener(onScroll);
    getData();
    confirmed = Data.totalConfirm;
    death = Data.totalDeath;
    recover = Data.totalRecover;
    getData();

    print(confirmed);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }

  bool isWaiting = false;

  Map<String, String> coronaValues = {};

  void getData() async {
    isWaiting = true;
    try {
      var data = await Data().getCoronaData(HomeScreen.selectedCountry);
      isWaiting = false;
      setState(() {
        confirmed = Data.totalConfirm;
        death = Data.totalDeath;
        recover = Data.totalRecover;
      });
    } catch (e) {
      print(e);
    }
  }

  static DateTime now = DateTime.now();
  String formattedDate = DateFormat('MMMM d').format(now);

  int number;

  final List<DropdownMenuItem> items = [];

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
            SizedBox(height: 5.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                loading
                    ? CircularProgressIndicator()
                    : searchTextField = AutoCompleteTextField<User>(
                        key: key,
                        clearOnSubmit: false,
                        suggestions: users,
                        style: TextStyle(color: Colors.black, fontSize: 16.0),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(1.0),
                              ),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 4.0,
                              )),
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding:
                              EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
                          hintText: "Ex: USA",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        itemFilter: (item, query) {
                          return item.name
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        },
                        itemSorter: (a, b) {
                          return a.name.compareTo(b.name);
                        },
                        itemSubmitted: (item) {
                          setState(() {
                            searchTextField.textField.controller.text =
                                item.name;
                            HomeScreen.selectedCountry =
                                searchTextField.textField.controller.text;
                            print(HomeScreen.selectedCountry);
                            getData();
                            confirmed = Data.totalConfirm;
                            death = Data.totalDeath;
                            recover = Data.totalRecover;
                            getData();
                          });
                        },
                        itemBuilder: (context, item) {
                          // ui for the autocompelete row
                          return row(item);
                        },
                      ),
              ],
            ),
            SizedBox(height: 20),
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
                      FlatButton(
                        child: Text(
                          "See details",
                          style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          print('Clicked');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details()), // Todo
                          );
                        },
                      )
//                      Text(
//                        "See details",
//                        style: TextStyle(
//                          color: kPrimaryColor,
//                          fontWeight: FontWeight.w600,
//                        ),
//                      ),
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
                      Text(
                        "Spread of Virus",
                        style: kTitleTextstyle,
                      ),
                      Text(
                        "See details",
                        style: TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    height: 178,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 10),
                          blurRadius: 30,
                          color: kShadowColor,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      "assets/images/map.png",
                      fit: BoxFit.contain,
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
