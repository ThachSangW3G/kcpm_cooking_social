
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/screens/recipe/recipe_ingredients_edit_screen.dart';
import 'package:kcpm/screens/recipe/recipe_intro_edit_screen.dart';
import 'package:kcpm/screens/recipe/recipe_steps_edit_screen.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import '../../constants/app_colors.dart';
import '../../providers/add_recipe_provider/intro_provider.dart';
import '../../providers/add_recipe_provider/material_provider.dart';
import '../../providers/add_recipe_provider/spice_provider.dart';
import '../../providers/add_recipe_provider/steps_provider.dart';
import '../../widgets/add_item_dialog.dart';
import '../../widgets/recipe_intro_add_view.dart';

class RecipeAddScreen extends StatefulWidget {
  const RecipeAddScreen({Key? key}) : super(key: key);

  @override
  State<RecipeAddScreen> createState() => _RecipeAddScreenState();
}

class _RecipeAddScreenState extends State<RecipeAddScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<RecipeIntroEditState> tab1Key =
  GlobalKey<RecipeIntroEditState>();
  final GlobalKey<RecipeIngredientsEditState> tab2Key =
  GlobalKey<RecipeIngredientsEditState>();
  final GlobalKey<RecipeStepsEditState> tab3Key =
  GlobalKey<RecipeStepsEditState>();
  String? _name;
  String? _url;
  int? _cookTime;
  int? _cookTimeHours;
  String? _description;
  String? _difficult;
  bool? _isPublic;
  int? _server;
  String? _source;
  List<Item>? _steps;
  List<Item>? _materials;
  List<Item>? _spices;
  Intro? _intro;
  String? _category;
  late TabController _tabController;
  int _selectedTabIndex = 0;
  Intro? introGet;

  // Choice selectedChoice = Choice.A;

  void getDataFromTabs() async {
    //get Data tab intro
    String? name = _intro?.name;
    String? source = _intro?.url;
    int? cookTime = _intro?.cookTime;
    int? cookTimeHours = _intro?.cookTimeHour;
    String? description = _intro?.description;
    String? difficult = _intro?.difficult;
    bool? isPublic = _intro?.isPublic;
    int? server = _intro?.server;
    File? getFile = _intro?.file;
    String? category = _intro!.category?.id;
    if (name == null ||
        source == null ||
        _steps == null ||
        _spices == null ||
        _materials == null ||
        cookTime == null ||
        cookTimeHours == null ||
        description == null ||
        difficult == null ||
        server == null ||
        category == null ||
        getFile == null) {
      _showDetailDialog();
      return;
    }
    if (!isURL(source)) {
      showValidationError(context);
      return;
    }
    String? url = await upLoadFileToFirebase(getFile);
    setState(() {
      _name = name;
      _source = source;
      _cookTime = cookTime;
      _description = description;
      _difficult = difficult;
      _isPublic = isPublic;
      _server = server;
      _url = url;
      _category = category;
      _cookTimeHours = cookTimeHours;
    });
    upLoadDataFirestore();
  }

  void upLoadDataFirestore() async {
    try {
      List<String> steps = _steps!.map((item) => item.name).toList();
      List<String> spice = _spices!.map((item) => item.name).toList();
      List<String> material = _materials!.map((item) => item.name).toList();
      // Khởi tạo Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      // Tạo một document reference và lấy ra ID ngẫu nhiên
      DocumentReference reviewRef = firestore.collection('recipes').doc();
      //
      Map<String, dynamic> recipe = {
        'id': reviewRef.id,
        'URL': _url,
        'cookTime': _cookTime! + _cookTimeHours! * 60,
        'description': _description,
        'difficult': _difficult,
        'isPublic': _isPublic,
        'name': _name,
        'numberLike': 0,
        'numberReview': 0,
        'category': _category,
        'serves': _server,
        'uidUser': FirebaseAuth.instance.currentUser?.uid,
        'source': _source,
        'spice': spice,
        'steps': steps,
        'material': material
      };

      await reviewRef.set(recipe).then((value) => showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Thông báo',
                  style: TextStyle(fontFamily: "CeraPro")),
              content: const Text('Thêm Dữ Liệu Thành Công',
                  style: TextStyle(fontFamily: "CeraPro")),
              actions: [
                TextButton(
                  onPressed: () async {
                    Provider.of<IntroProvider>(context, listen: false)
                        .clearData();
                    Provider.of<StepsProvider>(context, listen: false)
                        .cleardata();
                    Provider.of<SpiceProvider>(context, listen: false)
                        .cleardata();
                    Provider.of<MaterialProvider>(context, listen: false)
                        .cleardata();
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                        fontFamily: "CeraPro", color: AppColors.orangeCrusta),
                  ),
                ),
              ],
            );
          }));
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  Future<String> upLoadFileToFirebase(File file) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      // Tạo tham chiếu đến vị trí lưu trữ trên Firebase Storage
      String fileName = path.basename(file.path);
      Reference ref = storage.ref().child(
          'images/$fileName'); // Thay đổi 'images/image.jpg' thành đường dẫn bạn muốn lưu trữ tệp tin

      // Tải lên tệp tin lên Firebase Storage
      UploadTask uploadTask = ref.putFile(file);

      // Lắng nghe sự kiện tiến trình tải lên
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Progress: ${snapshot.bytesTransferred}/${snapshot.totalBytes}');
      }, onError: (Object e) {
        // Xử lý lỗi nếu có
        //print('Upload error: $e');
      });

      // Đợi cho đến khi quá trình tải lên hoàn thành
      await uploadTask.whenComplete(() {
        //print('Upload complete');
      });

      // Lấy URL của tệp tin đã tải lên
      String downloadURL = await ref.getDownloadURL();
      print('Download URL: $downloadURL');
      return downloadURL;
    } catch (e) {
      print('Error uploading file: $e');
      return "https://anestisxasapotaverna.gr/wp-content/uploads/2021/12/ARTICLE-1.jpg";
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Recipe Form",
          style: TextStyle(
              fontFamily: 'Recoleta',
              fontSize: 20,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
            size: 20,
          ),
          onPressed: () {
            _showGobackPopup(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              List<Item> steps =
                  Provider.of<StepsProvider>(context, listen: false).items;
              List<Item> spices =
                  Provider.of<SpiceProvider>(context, listen: false).items;
              List<Item> materials =
                  Provider.of<MaterialProvider>(context, listen: false).items;
              Intro intro =
                  Provider.of<IntroProvider>(context, listen: false).intro;
              setState(() {
                _steps = steps;
                _spices = spices;
                _materials = materials;
                _intro = intro;
              });
              getDataFromTabs();
              // Xử lý sự kiện khi người dùng nhấn vào nút
            },
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.orangeCrusta,
                fontFamily: "CeraPro",
                fontSize: 18.0,
              ),
            ),
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(
              25.0,
            ),
            color: AppColors.orangeCrusta,
          ),
          //labelColor: AppColors.orangeCrusta,
          labelColor: AppColors.greyShuttle,
          unselectedLabelColor: AppColors.greyShuttle,
          labelStyle: const TextStyle(
            fontFamily: 'CeraPro',
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
            //color: AppColors.greyBombay),
          ),
          dividerColor: Colors.white,
          tabs: [
            buildTab(0, 'Intro', 1),
            buildTab(1, 'Ingredients', 2),
            buildTab(2, 'Steps', 1),
          ],
        ),
        // systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          RecipeIntroAdd(key: tab1Key),
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 30),
            child: Stack(children: [
              RecipeIngredientsEdit(
                key: tab2Key,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      _showOptionMenu(context);
                    },
                    backgroundColor: AppColors.orangeCrusta,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Stack(children: [
              const Padding(
                padding: EdgeInsets.only(left: 35),
                child: Text(
                  'Cách Nấu Ăn',
                  style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'CeraPro',
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
              Column(
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  RecipeStepsEdit(
                    key: tab3Key,
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AddItemDialog(
                              onAddItem: (itemName) {
                                Provider.of<StepsProvider>(context,
                                    listen: false)
                                    .addNewItem(itemName);
                                Navigator.pop(context);
                              },
                            );
                          });
                      // Xử lý khi nút được nhấn
                    },
                    backgroundColor: AppColors.orangeCrusta,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: const Icon(Icons.add),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildTab(int index, String text, int type) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
        _tabController.animateTo(index);
      },
      child: SizedBox(
        height: 36,
        width: (type == 1 ? 103 : 120),
        // color: _selectedTabIndex == index ? AppColors.orangeCrusta : null,
        // padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: _selectedTabIndex == index
                  ? Colors.white
                  : AppColors.greyBombay,
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thông tin chi tiết',
              style: TextStyle(fontFamily: "CeraPro")),
          content: const Text('Vui lòng nhập đầy đủ thông tin',
              style: TextStyle(fontFamily: "CeraPro")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng',
                  style: TextStyle(
                      fontFamily: "CeraPro", color: AppColors.orangeCrusta)),
            ),
          ],
        );
      },
    );
  }

  void _showGobackPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure you want to go back?'),
          content: const Text('Any changes you made will be lost.'),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<IntroProvider>(context, listen: false).clearData();
                Provider.of<StepsProvider>(context, listen: false).cleardata();
                Provider.of<SpiceProvider>(context, listen: false).cleardata();
                Provider.of<MaterialProvider>(context, listen: false)
                    .cleardata();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK',
                  style: TextStyle(color: AppColors.orangeCrusta)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.orangeCrusta),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOptionMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentTextStyle: const TextStyle(
            fontFamily: 'CeraPro',
          ),
          title: const Text(
            'Option',
            style: TextStyle(
              fontFamily: 'CeraPro',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOptionItem('Spice', context),
              _buildOptionItem('Material', context),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng',
                  style: TextStyle(
                      fontFamily: 'CeraPro', color: AppColors.orangeCrusta)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildOptionItem(String option, BuildContext context) {
    Widget icon;
    String text;
    switch (option) {
      case 'Spice':
        icon = SvgPicture.asset(
          'assets/icon_svg/pencil.svg',
          height: 20,
          width: 20,
        );
        text = 'Add item Spice';
        break;
      case 'Material':
        icon = SvgPicture.asset(
          'assets/icon_svg/pencil.svg',
          height: 20,
          width: 20,
        );
        text = 'Add item Material';
        break;
      default:
        icon = SvgPicture.asset(
          'assets/icon_svg/pencil.svg',
          height: 20,
          width: 20,
        );
        text = 'Lỗi';
    }

    return ListTile(
      leading: icon,
      title: Text(
        text,
        style: const TextStyle(
          fontFamily: 'CeraPro',
        ),
      ),
      onTap: () {
        // Xử lý khi tùy chọn được chọn
        _handleOptionSelection(option, context);
      },
    );
  }

  void _handleOptionSelection(String option, BuildContext context) {
    if (option == 'Spice') {
      Navigator.pop(context);
      _handleAddSpice(context);
    } else {
      if (option == 'Material') {
        Navigator.pop(context);
        _handleAddMaterial(context);
      }
    }
  }

  void _handleAddSpice(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return AddItemDialog(onAddItem: (itemName) {
            Provider.of<SpiceProvider>(context, listen: false)
                .addNewItem(itemName);
            Navigator.pop(context);
          });
        }));
    // Xử lý
    // khi tùy chọn "Edit" được chọn
  }

  void _handleAddMaterial(BuildContext context) {
    showDialog(
        context: context,
        builder: ((context) {
          return AddItemDialog(onAddItem: (itemName) {
            Provider.of<MaterialProvider>(context, listen: false)
                .addNewItem(itemName);
            Navigator.pop(context);
          });
        }));
    // Xử lý
    // khi tùy chọn "Edit" được chọn
  }

  // Hàm kiểm tra giá trị nhập vào có phải là URL hay không
  bool isURL(String value) {
    // Biểu thức chính quy để kiểm tra URL
    final urlPattern = RegExp(
      r'^(http(s)?:\/\/)?'
      r'(([a-zA-Z0-9\-])+(\.)?)*[a-zA-Z0-9]+\.[a-zA-Z]{2,}(\.[a-zA-Z]{2,})?'
      r'(:[0-9]+)?(\/([\w#!:.?+=&%@!\-\/])*)?$',
    );

    return urlPattern.hasMatch(value);
  }

  void showValidationError(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Lỗi',
            style: TextStyle(fontFamily: "CeraPro"),
          ),
          content: const Text(
            'Giá trị nhập vào không phải là URL hợp lệ.',
            style: TextStyle(fontFamily: "CeraPro"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                    fontFamily: "CeraPro", color: AppColors.orangeCrusta),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
