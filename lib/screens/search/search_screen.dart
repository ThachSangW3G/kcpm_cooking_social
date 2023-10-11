
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kcpm/providers/recipe_provider.dart';
import 'package:provider/provider.dart';

import '../../constants/app_colors.dart';
import '../../models/recipe.dart';
import '../../widgets/recipe_item_unpublished.dart';

class SearchRecipeScreen extends StatefulWidget {
  const SearchRecipeScreen({super.key});

  @override
  State<SearchRecipeScreen> createState() => _SearchRecipeScreenState();
}

class _SearchRecipeScreenState extends State<SearchRecipeScreen> {

  bool _isSearch = false;
  // RecipeProvider? recipeProvider;
  // RecentSearchProvider? recentSearchProvider;

  String searchText = "";


  Widget _buildSearch(){
      return
        StreamBuilder<List<Recipe>>(
          stream: RecipeProvider().getSearchRecipe(searchText),
          builder: (context, snapshot) {

            if(snapshot.connectionState == ConnectionState.waiting){
              return const CircularProgressIndicator();
            }
            else {
              final recipes = snapshot.data;
              return Expanded(
                child: ListView.builder(
                  itemCount: recipes!.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index){
                    return RecipeItemUnPublishedWidget(
                      recipe: recipes[index],
                    );
                  },
                ),
              );
            }

          }
        );
  }

  @override
  Widget build(BuildContext context) {
    // recipeProvider = Provider.of<RecipeProvider>(context);
    // recentSearchProvider = Provider.of<RecentSearchProvider>(context)..getListRecentSearch(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Recipe',
          style: TextStyle(
              fontFamily: 'Recoleta',
              fontSize: 20,
              fontWeight: FontWeight.w800
          ),
        ),
        leading: Container(),
        centerTitle: true,
        bottom:  PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: AppColors.greyIron,
            width: double.infinity,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [

          const SizedBox(height: 15.0,),
          Container(
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                color: AppColors.greyIron
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(

                  decoration: InputDecoration(
                    hintText: 'Recipe title',
                    hintStyle: const TextStyle(
                      fontFamily: 'CeraPro',
                      fontSize: 17,
                      // color: AppColors.greyShuttle
                    ),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: (){},
                      icon: SvgPicture.asset('assets/icon_svg/search.svg', height: 25, width: 25, color: AppColors.greyShuttle,
                      ),
                    ),

                  ),
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty){
                        _isSearch = false;
                      }else {
                        _isSearch = true;
                      }
                      searchText = value;
                    });

                    //print(recipeProvider!.searchRecipe.length);
                  }
              ),
            ),
          ),
          _buildSearch()

        ],
      ),
    );
  }
}



class RecentSearchWidget extends StatelessWidget {
  final String search;
  const RecentSearchWidget({
    super.key, required this.search,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                width: 1,
                color: AppColors.greyIron,

              )
          )
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric( vertical: 10, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              search,
              style: const TextStyle(
                  fontFamily: 'CeraPro',
                  fontWeight: FontWeight.w500,
                  fontSize: 16
              ),
            ),
            SvgPicture.asset(
              'assets/icon_svg/x.svg',
              height: 24,
              width: 24,
            )
          ],
        ),
      ),
    );
  }
}