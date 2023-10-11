
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class InterfaceSettingScreen extends StatefulWidget {
  const InterfaceSettingScreen({super.key});


  @override
  State<InterfaceSettingScreen> createState() => _InterfaceSettingScreenSate();

}

class _InterfaceSettingScreenSate extends State<InterfaceSettingScreen> {
  int _selectedIndex = 0;

  void _handleRadioValueChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // setThemeState(() {

    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Interface Setting',
            style: TextStyle(
              // color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                fontFamily: 'Recoleta'
            ),
          ),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_outlined,
                // color: Colors.black,
                size: 20,
              )),
        ),
        body: Scaffold(
            body: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    //   MyRadioListTile(
                    //   title: 'Light',
                    //   value: ThemeData.light(),
                    //   groupValue: context.watch<ThemeProvider>().themeData,
                    //   isSelected: _selectedIndex == 0,
                    //   onChanged: (value) {
                    //     // Xử lý khi lựa chọn thay đổi
                    //     // _handleRadioValueChanged(0);
                    //     final themeProvider = context.read()<ThemeProvider>();
                    //     themeProvider.setThemeData(value as ThemeData);
                    //   },
                    // ),
                    // MyRadioListTile(
                    //   title: 'Dark',
                    //   isSelected: _selectedIndex == 1,
                    //   onChanged: (value) {
                    //     // Xử lý khi lựa chọn thay đổi
                    //     _handleRadioValueChanged(1);
                    //   },
                    // ),


                    RadioListTile(
                      title: const Text('Light'),
                      value: ThemeData(
                        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
                        useMaterial3: true,
                      ),
                      groupValue: context.watch<ThemeProvider>().themeData,
                      onChanged: (value) {
                        final themeProvider = context.read<ThemeProvider>();
                        themeProvider.setThemeData(value as ThemeData);
                      },
                    ),
                    RadioListTile(
                      title: const Text('Dark'),
                      // value: ThemeData(
                      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.black54),
                      //   useMaterial3: true,
                      // ),
                      value: ThemeData.dark(),
                      groupValue: context.watch<ThemeProvider>().themeData,
                      onChanged: (value) {
                        final themeProvider = context.read<ThemeProvider>();
                        themeProvider.setThemeData(value as ThemeData);
                      },
                    )
                  ],


                )
            )
        )
    );
  }
}
