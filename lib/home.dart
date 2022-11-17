import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'services/indodax.dart';
import 'dart:async';
import 'package:external_app_launcher/external_app_launcher.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Indodax indodax = Indodax();
  Map strength = {};
  late List<Widget> widgetStrength;
  bool isFromLoading = true;
  Map dataFromLoading = {};

  setUpTimedFetch() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!isFromLoading) {
        Indodax.getTickers().then((value) {
          setState(() {
            indodax = value;
          });
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // ignore: todo
    setUpTimedFetch();
  }

  @override
  Widget build(BuildContext context) {
    //get data from loading screen
    if (dataFromLoading.isEmpty) {
      dataFromLoading = ModalRoute.of(context)!.settings.arguments as Map;
      indodax.tickers = dataFromLoading['tickers'];
      isFromLoading = false;
    }
    // dataFromLoading = dataFromLoading.isNotEmpty
    //     ? dataFromLoading
    //     : (ModalRoute.of(context)?.settings.arguments ?? <String, dynamic>{})
    //         as Map;
    // indodax.tickers = dataFromLoading['tickers'];
    // dataFromLoading = {};
    // isFromLoading = false;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 46, 48, 71),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 60, 63, 88),
          foregroundColor: const Color.fromARGB(255, 145, 155, 192),
          // foregroundColor: Color.fromARGB(255, 59, 186, 156),
          title: const Text('Indodax Crypto',
              style: TextStyle(fontFamily: 'Poppins')),

          actions: const [
            DropdownMenu(),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await LaunchApp.openApp(
              androidPackageName: 'id.co.bitcoin',
              openStore: true,
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          label: const Text(
            'Open Indodax',
            style: TextStyle(
              fontSize: 14,
              letterSpacing: 0.7,
            ),
          ),
          foregroundColor: const Color.fromARGB(255, 46, 48, 71),
          backgroundColor: const Color.fromARGB(255, 59, 186, 156),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 80.0),
            child: Column(
              children: indodax.tickers.keys.map((key) {
                // print(indodax.tickers['btc_idr']['server_time']);
                if (key.isNotEmpty) {
                  strength = Indodax().getStrength(
                      indodax.tickers[key]['last'],
                      indodax.tickers[key]['high'],
                      indodax.tickers[key]['low']);
                  widgetStrength = [
                    strength['percentage'],
                    strength['icon'],
                    strength['position']
                  ];
                } else {
                  widgetStrength = [
                    const Text('0', style: TextStyle(fontFamily: 'Poppins'))
                  ];
                }
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  color: const Color.fromARGB(255, 60, 63, 88),
                  margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                key.isEmpty
                                    ? 'Loading...'
                                    : Indodax().checkCurrencyType(key),
                                style: const TextStyle(
                                  letterSpacing: 0.7,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 65, 206, 173),
                                  // shadows: [
                                  //   Shadow(
                                  //     blurRadius: 10.0,
                                  //     color: Color.fromARGB(255, 65, 206, 173),
                                  //     offset: Offset(0.1, 0.1),
                                  //   ),
                                  // ],
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Last',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 145, 155, 192),
                                ),
                              ),
                              Text(
                                Indodax()
                                    .checkNull(indodax.tickers, key, 'last'),
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 145, 155, 192),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'High',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 145, 155, 192),
                                ),
                              ),
                              Text(
                                Indodax()
                                    .checkNull(indodax.tickers, key, 'high'),
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 145, 155, 192),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              const Text(
                                'Low',
                                style: TextStyle(
                                  fontSize: 11.0,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 145, 155, 192),
                                ),
                              ),
                              Text(
                                Indodax()
                                    .checkNull(indodax.tickers, key, 'low'),
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Poppins',
                                  color: Color.fromARGB(255, 145, 155, 192),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      widgetStrength[1],
                                      widgetStrength[0],
                                    ],
                                  ),
                                  widgetStrength[2],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class DropdownMenu extends StatelessWidget {
  const DropdownMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      splashRadius: 20.0,
      tooltip: '',
      icon: const Icon(Icons.more_vert),
      color: const Color.fromARGB(255, 60, 63, 88),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          child: const Text('About',
              style: TextStyle(color: Color.fromARGB(255, 145, 155, 192))),
          onTap: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              //dialog menu
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: const Color.fromARGB(255, 60, 63, 88),
                    title: const Text('About',
                        style: TextStyle(
                            color: Color.fromARGB(255, 145, 155, 192))),
                    content: const Text(
                        'Indodax buy or sell strength indicator is a simple app that shows the strength of the buy or sell price of the cryptocurrency on the Indodax exchange. This app is made by using the Flutter framework and the Indodax API.',
                        style: TextStyle(
                            color: Color.fromARGB(255, 145, 155, 192))),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 97, 102, 143)),
                        ),
                        child: const Text('Close',
                            style: TextStyle(
                                color: Color.fromARGB(255, 145, 155, 192))),
                      ),
                    ],
                  );
                },
              );
            });
          },
        ),
        PopupMenuItem(
          child: const Text('Exit',
              style: TextStyle(color: Color.fromARGB(255, 145, 155, 192))),
          onTap: () {
            SystemNavigator.pop();
          },
        ),
      ],
    );
  }
}
