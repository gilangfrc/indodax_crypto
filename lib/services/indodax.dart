import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class Indodax {
  Map tickers = {};

  Indodax({
    this.tickers = const {},
  });

  factory Indodax.getIndodax(Map<String, dynamic> data) {
    return Indodax(
      tickers: data,
    );
  }

  get isEmpty => null;

  static Future<Indodax> getTickers() async {
    try {
      // Make the request
      Response response =
          await get(Uri.parse('https://indodax.com/api/tickers'));
      Map result = jsonDecode(response.body);

      return Indodax.getIndodax(result['tickers']);
      // print(result);
    } catch (e) {
      // print(e);
      return Indodax.getIndodax({});
    }
  }

  static Future<Map> getTicker() async {
    try {
      // Make the request
      Response response =
          await get(Uri.parse('https://indodax.com/api/tickers'));
      Map result = jsonDecode(response.body);

      return result['tickers'];
      // print(result);
    } catch (e) {
      // print(e);
      return {};
    }
  }

  Map getStrength(String last_, String high_, String low_) {
    double last = double.parse(last_);
    double high = double.parse(high_);
    double low = double.parse(low_);
    double warm = high - low;
    int coinPercentage;
    double middleBottom = (warm / 3) + low;
    double middleTop = (warm / 3) + middleBottom;
    // List<Widget> position;
    Widget position;
    Widget icon;
    Widget percentage;
    Map result;

    try {
      if (last >= middleTop) {
        coinPercentage =
            ((last - middleTop) / (high - middleTop) * 100).round();
        position = const Text(
          'SELL',
          style: TextStyle(
            color: Color.fromARGB(255, 50, 226, 55),
            fontSize: 16,
          ),
        );
        icon = const Icon(Icons.arrow_drop_up,
            color: Color.fromARGB(255, 50, 226, 55));
        percentage = Text('$coinPercentage%',
            style: const TextStyle(
              color: Color.fromARGB(255, 50, 226, 55),
              fontSize: 22,
              fontFamily: 'Poppins',
              shadows: [
                Shadow(
                  blurRadius: 10.0,
                  color: Color.fromARGB(255, 50, 226, 55),
                  offset: Offset(0.5, 0.5),
                ),
              ],
            ));
      } else if (last >= middleBottom && last < middleTop) {
        coinPercentage =
            ((last - middleBottom) / (middleTop - middleBottom) * 100).round();
        position = const Text(
          'HOLD',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 226, 55),
            fontSize: 16,
          ),
        );
        icon = const Icon(Icons.arrow_right,
            color: Color.fromARGB(255, 255, 226, 55));
        percentage = Text(
          '$coinPercentage%',
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 226, 55),
            fontSize: 22,
            fontFamily: 'Poppins',
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Color.fromARGB(255, 255, 226, 55),
                offset: Offset(0.5, 0.5),
              ),
            ],
          ),
        );
      } else {
        coinPercentage =
            (100 - (last - low) / (middleBottom - low) * 100).round();
        position = const Text(
          'BUY',
          style: TextStyle(
            color: Color.fromARGB(255, 241, 66, 53),
            fontSize: 16,
          ),
        );
        icon = const Icon(
          Icons.arrow_drop_down,
          color: Color.fromARGB(255, 241, 66, 53),
        );
        percentage = Text(
          '$coinPercentage%',
          style: const TextStyle(
            color: Color.fromARGB(255, 241, 66, 53),
            fontSize: 22,
            fontFamily: 'Poppins',
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Color.fromARGB(255, 241, 66, 53),
                offset: Offset(0.5, 0.5),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      coinPercentage = 0;
      //Icon(Icons.restart_alt, color: Color.fromARGB(255, 145, 155, 192))
      position = const Text(
        'N/A',
        style: TextStyle(
          color: Color.fromARGB(255, 145, 155, 192),
          fontSize: 16,
        ),
      );
      icon = const Text('- ',
          style: TextStyle(
            color: Color.fromARGB(255, 145, 155, 192),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ));
      percentage = Text('$coinPercentage%',
          style: const TextStyle(
            color: Color.fromARGB(255, 145, 155, 192),
            fontFamily: 'Poppins',
            fontSize: 22,
          ));
    }

    result = {
      'position': position,
      'icon': icon,
      'percentage': percentage,
    };

    return result;
  }

  String checkCurrencyType(String currency) {
    if (currency.contains('_idr')) {
      return currency.replaceAll('_idr', '').toUpperCase();
    } else {
      return currency.replaceAll('_usdt', '').toUpperCase();
    }
  }

  //format rupiah
  String formatRupiah(String price) {
    var number = double.parse(price);
    var format =
        NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 0);
    return format.format(number);
  }

  String checkCurrency(String type, String price) {
    if (type.contains('idr')) {
      return formatRupiah(price);
    } else {
      return '\$$price';
    }
  }

  String checkNull(Map map, String key, String key2) {
    // print(map[key][key2]);
    if (map.isEmpty) {
      return 'Loading...';
    } else {
      // return Indodax().formatRupiah(map[key][key2]);
      return Indodax().checkCurrency(key, map[key][key2]);
    }
  }
}

// Row(
//                                 children: [
//                                   Icon(
//                                     Icons.arrow_drop_up,
//                                     color: Colors.green,
//                                   ),
//                                   Text(e[5] + '%'),
//                                 ],
//                               ),