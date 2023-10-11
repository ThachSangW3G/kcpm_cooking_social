
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import 'interface_setting_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});


  @override
  State<StatefulWidget> createState() => _SettingScreenSate();

}

class _SettingScreenSate extends State<SettingScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
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
              ElevatedButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Interface Style',
                    style: TextStyle(
                        fontFamily: 'CeraPro',
                        fontWeight: FontWeight.w500,
                        fontSize: 17
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  // shadowColor: AppColors.appPrimaryColor,
                  backgroundColor: AppColors.yellowOrange,
                  // foregroundColor: AppColors.black,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => InterfaceSettingScreen()));
                },
              ),
              const SizedBox(height: 18,),

              // ElevatedButton(
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Text(
              //       'Notifications',
              //       style: TextStyle(
              //         fontFamily: 'CeraPro',
              //         fontWeight: FontWeight.w500,
              //         fontSize: 17,
              //       ),
              //     ),
              //   ),
              //   style: ElevatedButton.styleFrom(
              //     shadowColor: AppColors.appPrimaryColor,
              //     backgroundColor: AppColors.yellowOrange,
              //     // foregroundColor: AppColors.black,
              //     elevation: 3,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     fixedSize: Size(MediaQuery.of(context).size.width, 50),
              //   ),
              //   onPressed: () {
              //     Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotiSettingScreen()));
              //   },
              // ),
              // const SizedBox(height: 18,),


              ElevatedButton(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Language',
                    style: TextStyle(
                        fontFamily: 'CeraPro',
                        fontWeight: FontWeight.w500,
                        fontSize: 17
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  shadowColor: AppColors.appPrimaryColor,
                  backgroundColor: AppColors.yellowOrange,
                  // foregroundColor: AppColors.black,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  fixedSize: Size(MediaQuery.of(context).size.width, 50),
                ),
                onPressed: () {
                 // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LanguageSettingScreen()));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}