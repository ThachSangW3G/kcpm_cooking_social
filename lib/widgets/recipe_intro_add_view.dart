
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../constants/app_colors.dart';
import '../models/category.dart';
import '../providers/add_recipe_provider/intro_provider.dart';
import '../providers/category_provider.dart';

enum Difficulty { Difficult, Medium, Easy }

class RecipeIntroAdd extends StatefulWidget {
  const RecipeIntroAdd({Key? key}) : super(key: key);
  @override
  State<RecipeIntroAdd> createState() => RecipeIntroAddState();
}

class RecipeIntroAddState extends State<RecipeIntroAdd> {
  //Data
  // String? _name;
  // String? _url;
  // int _cookTime = 0;
  // // String? _description;
  // bool _isPublic = false;
  // int? _server;
  // //String? _source;
  // Difficulty selectedDifficulty = Difficulty.Difficult;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final categotyProvider = Provider.of<CategoryProvider>(context);
    final categoty = categotyProvider.listCategories;
    return Consumer<IntroProvider>(
      builder: (context, introProvider, _) {
        return SingleChildScrollView(
            child: Container(
              padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    //initialValue: intro.name,
                    validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Title is required' : null,
                    onChanged: (value) {
                      introProvider.updateIntro(name: value);
                    },
                    decoration: const InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      labelText: 'Title',
                      enabledBorder: UnderlineInputBorder(
                        // viền dưới khi không có focus
                        borderSide: BorderSide(color: AppColors.greyIron),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        // viền dưới khi có focus
                        borderSide: BorderSide(color: AppColors.greyShuttle),
                      ),

                      // errorText: _textEditingController.text.isEmpty
                      //     ? 'Giá trị không được để trống'
                      //     : null,
                      labelStyle: TextStyle(
                          fontFamily: 'CeraPro',
                          // fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),

                  // COOK TIME--------------------------------------------
                  const SizedBox(height: 24),
                  const Text(
                    'Cooking Time',
                    style: TextStyle(
                        fontFamily: 'CeraPro',
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          // controller: TextEditingController(
                          //     text: introProvider.intro.cookTime == null
                          //         ? ''
                          //         : introProvider.intro.cookTime.toString()),
                          initialValue: introProvider.intro.cookTime == null
                              ? ''
                              : introProvider.intro.cookTime.toString(),
                          onChanged: (value) {
                            introProvider.updateIntro(cookTime: int.parse(value));
                          },
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                // viền dưới khi không có focus
                                borderSide: BorderSide(color: AppColors.greyIron),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                // viền dưới khi có focus
                                borderSide:
                                BorderSide(color: AppColors.greyShuttle),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              labelText: 'minutes',
                              labelStyle: TextStyle(
                                  fontFamily: 'CeraPro',
                                  // fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: TextFormField(
                          // controller: TextEditingController(
                          //   text: introProvider.intro.cookTimeHour == null
                          //       ? ''
                          //       : introProvider.intro.cookTimeHour.toString(),
                          // ),
                          // initialValue: introProvider.intro.cookTimeHour ==
                          //         null
                          //     ? ''
                          //     : introProvider.intro.cookTimeHour.toString(),
                          onChanged: (value) {
                            introProvider.updateIntro(
                                cookTimeHour: int.parse(value));
                          },
                          decoration: const InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                // viền dưới khi không có focus
                                borderSide: BorderSide(color: AppColors.greyIron),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                // viền dưới khi có focus
                                borderSide:
                                BorderSide(color: AppColors.greyShuttle),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0.0),
                              labelText: 'hours',
                              labelStyle: TextStyle(
                                  fontFamily: 'CeraPro',
                                  // fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),

                  // IMAGE -------------------------------------
                  const SizedBox(
                    height: 24,
                  ),
                  Stack(children: [
                    ClipRRect(
                      child: introProvider.intro.file != null
                          ? Image.file(
                        introProvider.intro.file!,
                        width: MediaQuery.of(context).size.width,
                        height: 208,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/images/image_background.png',
                        width: MediaQuery.of(context).size.width,
                        height: 208,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 16.0,
                      right: 16.0,
                      child: InkWell(
                        onTap: () async {
                          try {
                            XFile? pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              File file = File(pickedFile.path);
                              introProvider.updateIntro(file: file);
                              // Thực hiện các thao tác tiếp theo với file...
                            }
                          } catch (e) {
                            print('Error picking image: $e');
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            // shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                          child: SvgPicture.asset(
                            'assets/icon_svg/pencil.svg',
                            color: Colors.grey[800],
                            height: 10,
                            width: 10,
                          ),
                        ),
                      ),
                    ),
                  ]),

                  // DESCRIPTION -------------------------------
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    // controller: TextEditingController(
                    //     text: introProvider.intro.description),
                    // initialValue: introProvider.intro.description,
                    onChanged: (value) {
                      introProvider.updateIntro(description: value);
                    },
                    decoration: const InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        labelText: 'Description',
                        enabledBorder: UnderlineInputBorder(
                          // viền dưới khi không có focus
                          borderSide: BorderSide(color: AppColors.greyIron),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          // viền dưới khi có focus
                          borderSide: BorderSide(color: AppColors.greyShuttle),
                        ),
                        labelStyle: TextStyle(
                            fontFamily: 'CeraPro',
                            // fontSize: 14,
                            fontWeight: FontWeight.w400)),
                    inputFormatters: [
                      FilteringTextInputFormatter.singleLineFormatter
                    ],
                    maxLines: null, // Cho phép hiển thị nhiều dòng văn bản
                    keyboardType:
                    TextInputType.multiline, // Bàn phím hiển thị dạng đa dòng
                    textInputAction: TextInputAction.newline,
                  ),

                  //-------------------------------------------
                  const SizedBox(
                    height: 24,
                  ),

                  Row(
                    children: [
                      Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Difficulty',
                                style: TextStyle(fontFamily: "CeraPro"),
                              ),
                              SizedBox(
                                width: 160,
                                child: DropdownButton<String>(
                                  value: introProvider.intro.difficult,
                                  underline: const Divider(
                                    thickness: 1.5,
                                    color: AppColors.greyIron,
                                  ),
                                  elevation: 16,
                                  isExpanded: true,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 8),
                                  icon: Align(
                                    alignment: Alignment.centerRight,
                                    child: SvgPicture.asset(
                                      'assets/icon_svg/chevron-circle-down.svg',
                                      height: 15,
                                      width: 8,
                                    ),
                                  ),
                                  onChanged: (String? value) {
                                    introProvider.updateIntro(difficult: value);
                                  },
                                  items: const [
                                    DropdownMenuItem<String>(
                                      value: "Easy",
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text('Easy',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'CeraPro',
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.right)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Medium',
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text('Medium',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'CeraPro',
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.right)),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'Difficult',
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text('Difficult',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontFamily: 'CeraPro',
                                                fontSize: 16,
                                              ),
                                              textAlign: TextAlign.right)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      // const SizedBox(
                      //   width: 16,
                      // ),
                      Expanded(
                        child: TextFormField(
                          // controller: TextEditingController(
                          //   text: introProvider.intro.server == null
                          //       ? ''
                          //       : introProvider.intro.server.toString(),
                          // ),
                          // initialValue: introProvider.intro.server == null
                          //     ? ''
                          //     : introProvider.intro.server.toString(),
                          onChanged: (value) {
                            introProvider.updateIntro(server: int.parse(value));
                          },
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              // viền dưới khi không có focus
                              borderSide: BorderSide(color: AppColors.greyIron),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              // viền dưới khi có focus
                              borderSide: BorderSide(color: AppColors.greyShuttle),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 0.0),
                            labelText: 'Serve',
                          ),
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),

                  //---------------------
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Publish to Community?',
                                style: TextStyle(
                                    fontFamily: 'CeraPro',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400),
                              ),
                              Switch(
                                value: introProvider.intro.isPublic!,
                                onChanged: (bool newValue) {
                                  introProvider.updateIntro(isPublic: newValue);
                                },
                                activeColor: AppColors.orangeCrusta,
                                inactiveTrackColor: AppColors.greyDark,
                                inactiveThumbColor: AppColors.white,
                              ),
                              // const SizedBox(
                              //   width: 20,
                              // )
                            ],
                          )),
                    ],
                  ),
                  //---------------
                  const SizedBox(
                    height: 24,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Category',
                        style: TextStyle(fontFamily: "CeraPro"),
                      ),
                      SizedBox(
                        width: 160,
                        child: DropdownButton<Category>(
                            value: introProvider.intro.category,
                            underline: const Divider(
                              thickness: 1.5,
                              color: AppColors.greyIron,
                            ),
                            elevation: 16,
                            isExpanded: true,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 8),
                            icon: Align(
                              alignment: Alignment.centerRight,
                              child: SvgPicture.asset(
                                'assets/icon_svg/chevron-circle-down.svg',
                                height: 15,
                                width: 8,
                              ),
                            ),
                            onChanged: (Category? value) {
                              introProvider.updateIntro(category: value);
                            },
                            items: [
                              for (int index = 0; index < categoty.length; index++)
                                DropdownMenuItem<Category>(
                                  key: ValueKey(categoty[index].id),
                                  value: categoty[index],
                                  child: Align(
                                      alignment: Alignment.center,
                                      child: Text(categoty[index].name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'CeraPro',
                                            fontSize: 16,
                                          ),
                                          textAlign: TextAlign.right)),
                                ),
                            ]),
                      ),
                    ],
                  ),
                  //---------------
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    // controller: TextEditingController(
                    //     text: introProvider.intro.source),
                    //initialValue: introProvider.intro.source,
                    onChanged: (value) {
                      introProvider.updateIntro(source: value);
                    },
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          // viền dưới khi không có focus
                          borderSide: BorderSide(color: AppColors.greyIron),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          // viền dưới khi có focus
                          borderSide: BorderSide(color: AppColors.greyShuttle),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        labelText: 'Source',
                        labelStyle: TextStyle(
                            fontFamily: 'CeraPro',
                            // fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ),

                  //-----------------
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    //initialValue: introProvider.intro.url,
                    // controller:
                    //     TextEditingController(text: introProvider.intro.url),
                    onChanged: (value) {
                      introProvider.updateIntro(url: value);
                    },
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          // viền dưới khi không có focus
                          borderSide: BorderSide(color: AppColors.greyIron),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          // viền dưới khi có focus
                          borderSide: BorderSide(color: AppColors.greyShuttle),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                        labelText: 'URL',
                        labelStyle: TextStyle(
                            fontFamily: 'CeraPro',
                            // fontSize: 14,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
