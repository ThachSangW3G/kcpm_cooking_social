
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/models/user.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';
import '../../providers/user_provider.dart';
import '../../widgets/line_row.dart';

class EditProfileScreen extends StatefulWidget {
  final String idUser;
  const EditProfileScreen({super.key, required this.idUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late Future<UserInformation> _userModelFuture;

  late UserInformation tempUser;

  String? _name;
  String? _avatar;
  String? _email;
  String? _description;
  String? _bio;

  late String oldName;
  late String oldAvatar;
  late String oldEmail;
  late String oldDes;
  late String oldBio;

  //Get data
  String? getName() {
    return _name;
  }

  String? getEmail() {
    return _email;
  }

  String? getDes() {
    return _description;
  }

  String? getBio() {
    return _bio;
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider =
    Provider.of<UserProvider>(context, listen: false);
    // final Future<UserModel> userModel = AsyncSnapshot.waiting(userProvider.getUser(widget.idUser)) as Future<UserModel>;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          textAlign: TextAlign.center,
          style: TextStyle(
            // color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              fontFamily: 'Recoleta'),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
              // color: Colors.black,
              size: 20,
            )),
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(16.0), child: LineRow()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<UserInformation>(
                stream: userProvider.getUser(widget.idUser),
                builder:
                    ( context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final userModel = snapshot.data;
                    if (userModel != null) {
                      oldName = userModel!.name;
                      oldAvatar = userModel.avatar;
                      oldEmail = userModel.email;
                      oldBio = userModel.bio;
                      return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Row(
                                children: [
                                  Container(
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: CachedNetworkImageProvider(
                                                userModel!.avatar),
                                            fit: BoxFit.contain)),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      OneFrameImageStreamCompleter;
                                    },
                                    child: SvgPicture.asset(
                                      'assets/icon_svg/camera.svg',
                                      height: 24,
                                      width: 24,
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.orangeCrusta,
                                          BlendMode.srcIn),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  GestureDetector(
                                      onTap: () {},
                                      child: const Text(
                                        'Edit Photo',
                                        style: TextStyle(
                                            color: AppColors.orangeCrusta,
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'CeraPro'),
                                      ))
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const LineRow(),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Profile Name',
                                            style: TextStyle(),
                                          ),
                                          TextFormField(
                                            onChanged: (value) {
                                              // setState(() {
                                              _name = value;
                                              // });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 0.0),
                                                // labelText: 'Profile Name',
                                                labelStyle:
                                                kContentTextStyleProfile,
                                                hintText: userModel!.name,
                                                border: InputBorder.none),
                                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),

                                          const Text(
                                            'Email',
                                            style: TextStyle(),
                                          ),
                                          TextField(
                                            // controller: _textEditingController,
                                            onChanged: (value) {
                                              // setState(() {
                                              _email = value;

                                              // });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 0.0),
                                                // labelText: 'Email',
                                                labelStyle:
                                                kContentTextStyleProfile,
                                                hintText: userModel!.email,
                                                border: InputBorder.none,
                                                fillColor: Colors.amber,
                                                focusColor: Colors.amber),
                                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          const Text(
                                            'Bio',
                                            style: TextStyle(),
                                          ),
                                          TextField(
                                            onChanged: (value) {
                                              // setState(() {
                                              _bio = value;
                                              // });
                                            },
                                            decoration: InputDecoration(
                                                contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 0.0),
                                                // labelText: 'Bio',
                                                labelStyle:
                                                kContentTextStyleProfile,
                                                hintText: userModel!.bio,
                                                border: InputBorder.none),
                                            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          // TextField(
                                          //   decoration: InputDecoration(
                                          //     hintText: 'Recipe Title, Ingredient',
                                          //     hintStyle: const TextStyle(
                                          //         fontFamily: 'CeraPro',
                                          //         fontSize: 17,
                                          //         // color: AppColors.greyShuttle
                                          //     ),
                                          //     border: InputBorder.none,
                                          //     suffixIcon: IconButton(
                                          //       onPressed: (){},
                                          //       icon: SvgPicture.asset('assets/icon_svg/search.svg', height: 25, width: 25, color: AppColors.greyShuttle,
                                          //       ),
                                          //     ),

                                          //   ),
                                          //   onChanged: (value) {
                                          //     setState(() {
                                          //       if (value.isEmpty){
                                          //         _name = value;
                                          //       }else {
                                          //         _name = value;
                                          //       }
                                          //     });
                                          //     // recipeProvider!.search(value);
                                          //     // print(recipeProvider!.searchRecipe.length);
                                          //   }

                                          // ),
                                        ])))
                          ]);
                    }
                    return Container();
                  }
                })
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.all(20),
          child: GestureDetector(
            onTap: () async {
              if (_name != null ||
                  _email != null ||
                  _description != null ||
                  _bio != null) {
                UserInformation updatedUser = UserInformation(
                  uid: widget.idUser,
                  avatar: _avatar ?? oldAvatar,
                  email: _email ?? oldEmail,
                  name: _name ?? oldName,
                  bio: _bio ?? oldBio,
                );

                await userProvider.updateUser(updatedUser);

                Navigator.pop(context);
              }

              Navigator.pop(context);
            },
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                  color: AppColors.orangeCrusta,
                  borderRadius: BorderRadius.circular(7)),
              alignment: Alignment.center,
              child: const Text(
                'Save changes',
                style: TextStyle(
                    fontFamily: 'CeraPro', fontSize: 16, color: Colors.white),
              ),
            ),
          )),
    );
  }
}
