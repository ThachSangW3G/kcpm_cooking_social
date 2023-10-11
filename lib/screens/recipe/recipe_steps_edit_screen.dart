
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/add_recipe_provider/steps_provider.dart';
import '../../widgets/step_edit_card.dart';

class RecipeStepsEdit extends StatefulWidget {
  const RecipeStepsEdit({Key? key}) : super(key: key);

  @override
  State<RecipeStepsEdit> createState() => RecipeStepsEditState();
}

class RecipeStepsEditState extends State<RecipeStepsEdit> {
  List<String> steps = ['Cooking A', 'Cooking B', 'Cooking C', 'Cooking D'];

  @override
  Widget build(BuildContext context) {
    return Consumer<StepsProvider>(
      builder: (context, itemProvider, _) {
        return itemProvider.items.isEmpty
            ? const Center()
            : ReorderableListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shrinkWrap: true,
          children: [
            for (int index = 0;
            index < itemProvider.items.length;
            index++)
              StepEditCard(
                  key: ValueKey(itemProvider.items[index].id),
                  step: itemProvider.items[index])
          ],
          onReorder: (int oldIndex, int newIndex) {
            itemProvider.reorderItems(oldIndex, newIndex);
          },
        );
      },
    );
    // return ReorderableListView(
    //   padding: const EdgeInsets.symmetric(horizontal: 20),
    //   shrinkWrap: true,
    //   physics: const NeverScrollableScrollPhysics(),
    //   onReorder: (int oldIndex, int newIndex) {
    //     setState(() {
    //       if (newIndex > oldIndex) newIndex -= 1;
    //       final String step = steps.removeAt(oldIndex);
    //       steps.insert(newIndex, step);
    //     });
    //   },
    //   children: steps
    //       .asMap()
    //       .map((index, step) {
    //         return MapEntry(
    //           index,
    //           StepEditCard(
    //             key: ValueKey(index),
    //             step: step,
    //           ),
    //         );
    //       })
    //       .values
    //       .toList(),
    // );
  }
}
