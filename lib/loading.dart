import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:indodax_trading/services/indodax.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setupIndodaxData() async {
    Map data = {};
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      await Indodax.getTickers().then((value) {
        data = value.tickers;
        // print(indodax.tickers);
        if (data.isNotEmpty) {
          timer.cancel();
          // ignore: use_build_context_synchronously
          Navigator.pushReplacementNamed(context, '/home', arguments: {
            'tickers': data,
          });
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupIndodaxData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 46, 48, 71),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Center(
                      child: SpinKitFadingFour(
                        color: Color.fromARGB(255, 59, 186, 156),
                        size: 80.0,
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Loading...',
                        style: TextStyle(
                          color: Color.fromARGB(255, 59, 186, 156),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 20.0),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    Text(
                      //copyright text
                      '© 2022 Gilang Fathur Rachman',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Color.fromARGB(255, 59, 186, 156),
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
