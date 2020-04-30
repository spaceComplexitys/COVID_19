import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:number_display/number_display.dart';
import 'package:covid19/user.dart';

const List<String> fields = ['cases', 'deaths', 'recovered'];

const coronaAPIURL = 'https://coronavirus-19-api.herokuapp.com/countries';

int index = 0;
int total;
int death;
int recover;

int todayCases;
int todayDeaths;

int active;
int critical;
int tests;
final display = createDisplay(length: 4);

class Data {
  static String totalConfirm = "";
  static String totalDeath = "";
  static String totalRecover = "";

  static String totalTodayCases = "";
  static String totalTodayDeaths = "";

  static String totalActive = "";
  static String totalCritical = "";
  static String totalTests = "";

  static List<String> countryList = ['World', "USA", 'Japan'];

  Future<String> getCoronaData(String countries) async {
    Map<String, String> coronaNumbers = {};
    for (String corona in countryList) {
      String requestURL = '$coronaAPIURL/$countries';
      http.Response response = await http.get(requestURL);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        total = decodedData['cases'];
        totalConfirm = display(total);
        death = decodedData['deaths'];
        totalDeath = display(death);
        recover = decodedData['recovered'];
        totalRecover = display(recover);

        todayCases = decodedData['todayCases'];
        totalTodayCases = display(todayCases);
        todayDeaths = decodedData['todayDeaths'];
        totalTodayDeaths = display(todayDeaths);

        active = decodedData['active'];
        totalActive = display(active);
        critical = decodedData['critical'];
        totalCritical = display(critical);
        tests = decodedData['totalTests'];
        totalTests = display(tests);
      } else {
        print(response.statusCode);
        throw 'Problem with the get request';
      }
    }
    return totalConfirm;
  }
}
