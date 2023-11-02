
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/providers/grocery_provider.dart';
import 'package:kcpm/providers/recipe_provider.dart';

import '../../constants/app_colors.dart';
import '../../models/grocery.dart';
import '../../models/recipe.dart';
import '../../widgets/grocery_item_uncheck.dart';

class GroceryScreen extends StatefulWidget {
  // final String? idUser;
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}



class _GroceryScreenState extends State<GroceryScreen> {


  bool deleted = false;


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grocery',
          style: TextStyle(
              fontFamily: 'Recoleta',
              fontSize: 20,
              fontWeight: FontWeight.w800
          ),
        ),
        leading: Container(),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () async {
              final bool? delete = await openDialog();

              if(delete == null) return;
              if(delete == true){
                await GroceryProvider().deleteGrocery();
              }


            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SvgPicture.asset(
                'assets/icon_svg/trash.svg',
                width: 24,
                height: 24,
              ),
            ),
          )
        ],
        bottom:  PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.greyIron,
            width: double.infinity,
            height: 1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: !deleted ? Column(
            children: [
              // const SizedBox(height: 20.0,),
              // Container(
              //   height: 48,
              //   decoration: const BoxDecoration(
              //       borderRadius: BorderRadius.all(Radius.circular(16.0)),
              //       color: AppColors.greyIron
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
              //     child: TextField(
              //       decoration: InputDecoration(
              //         hintText: context.localize('addNewItem'),
              //         hintStyle: const TextStyle(
              //             fontFamily: 'CeraPro',
              //             fontSize: 17,
              //             color: AppColors.greyShuttle
              //         ),
              //         border: InputBorder.none,
              //
              //
              //       ),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 10.0,),
              // Container(
              //   height: 1,
              //   color: AppColors.greyIron,
              // ),
              const SizedBox(height: 20.0,),
              FutureBuilder<List<Grocery>>(
                  future: GroceryProvider().getListGroceries(),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }else {
                      final listGrocery = snapshot.data;
                      return Column(
                          children: listGrocery!.map((grocery) => FutureBuilder<Recipe>(
                            future: RecipeProvider(firestore: FirebaseFirestore.instance).getRecipe(grocery.recipeId),
                            builder: (context, snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }else {
                                final recipe = snapshot.data;
                                return Column(
                                    children:[
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              recipe!.name,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontFamily: 'CeraPro',
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,

                                              ),
                                            ),
                                          ),
                                          SvgPicture.asset(
                                            'assets/icon_svg/chevron-circle-up.svg',
                                            height: 24,
                                            width: 24,
                                            color: AppColors.greyBombay,
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: grocery.ingredients.map((e) => GroceryItemUncheck(title: e)).toList(),
                                      ),
                                      const SizedBox(height: 30,)
                                    ]
                                );
                              }
                            },
                          )).toList()
                      );
                    }
                  }
              )
            ],
          ) : Column(
            children: [
              const SizedBox(height: 20.0,),
              Container(
                height: 48,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16.0)),
                    color: AppColors.greyIron
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Add new item',
                      hintStyle: TextStyle(
                          fontFamily: 'CeraPro',
                          fontSize: 17,
                          color: AppColors.greyShuttle
                      ),
                      border: InputBorder.none,


                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0,),
              Container(
                height: 1,
                color: AppColors.greyIron,
              ),
              const SizedBox(height: 40.0,),
              SvgPicture.asset(
                'assets/icon_svg/cart.svg',
                height: 40,
                width: 40,
                color: AppColors.greyBombay,
              ),
              const SizedBox(height: 20.0,),
              const Text(
                'Grocery Empty',
                style: TextStyle(
                    fontFamily: 'CeraPro',
                    fontSize: 20,
                    fontWeight: FontWeight.w700
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> openDialog() => showDialog<bool>(context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0)
        ),
        child:  Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            height: 165,
            child: Column(
              children: [
                const Text(
                  'Are you sure you want to go remove all item?',
                  style: TextStyle(
                      fontFamily: 'CeraPro',
                      fontSize: 20,
                      fontWeight: FontWeight.w700
                  ),
                ),
                const SizedBox(height: 10.0,),
                const Text(
                  'Any changes you made will be lost.',
                  style: TextStyle(
                      fontFamily: 'CeraPro',
                      fontSize: 16,
                      fontWeight: FontWeight.w500
                  ),
                ),
                const SizedBox(height: 20.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: 'CeraPro',
                            fontSize: 20,
                            color: AppColors.orangeCrusta,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                    const SizedBox(width: 40.0,),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).pop(true);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontFamily: 'CeraPro',
                            fontSize: 20,
                            color: AppColors.orangeCrusta,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      )

  );
}
