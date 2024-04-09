import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:me_and_flora/core/app_router/app_router.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../../domain/models/models.dart';

class MySearchDelegate extends SearchDelegate {
  late String selectedResult;
  final Function callback;

  MySearchDelegate(this.callback);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      hintColor: colors.white,
      scaffoldBackgroundColor: colors.black,
      brightness: Brightness.dark,
      primaryColor: colors.black,
      //textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
      textTheme: Theme.of(context).textTheme
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.close,
          size: 24,
          color: Colors.white,
        ),
        onPressed: () {
          AutoRouter.of(context).pop();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.search_rounded,
        size: 24,
        color: Colors.white,
      ),
      onPressed: () {
        AutoRouter.of(context).push(PlantDetailsRoute(
            plant: Plant(
                name: selectedResult.toString(),
                type: "Дерево",
                description:
                "fvjnsjnsdjfnsjkfnsjdbkjbilnbknlknjlkmlmjljmlknjknjkbjkbhnv kbjlkjbnlknklnjcnsdjcnscjsdc",
                isTracked: true,
                imageUrl: "something")));
        //Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(selectedResult),
    );

    ///Поменять на страницу с информацией
  }

  @override
  void showResults(BuildContext context) {
    selectedResult = query;
    callback(query);
    AutoRouter.of(context).push(PlantDetailsRoute(
        plant: Plant(
            name: selectedResult.toString(),
            type: "Дерево",
            description:
            "fvjnsjnsdjfnsjkfnsjdbkjbilnbknlknjlkmlmjljmlknjknjkbjkbhnv kbjlkjbnlknklnjcnsdjcnscjsdc",
            isTracked: true,
            imageUrl: "something")));
    //close(context, query);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchResults = [
      "Flower1",
      "Flower2",
      "Flower3",
      "Flower4",
      "Flower5",
      query
    ].where((element) => element.contains(query)).toList();

    return ListView.separated(
      itemCount: searchResults.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 1,
        thickness: 1,
        indent: 60,
        color: Color.fromARGB(100, 241, 241, 245),
      ),
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Icon(
            Icons.search_rounded,
            size: 24,
            color: colors.white,
          ),
          title: Text(searchResults[index], style: Theme.of(context).textTheme.labelLarge,),
          onTap: () {
            selectedResult = searchResults[index];
            callback(selectedResult);
            AutoRouter.of(context).push(PlantDetailsRoute(
                plant: Plant(
                    name: selectedResult.toString(),
                    type: "Дерево",
                    description:
                        "fvjnsjnsdjfnsjkfnsjdbkjbilnbknlknjlkmlmjljmlknjknjkbjkbhnv kbjlkjbnlknklnjcnsdjcnscjsdc",
                    isTracked: true,
                    imageUrl: "something")));
            //AutoRouter.of(context).back();
          },
        );
      },
    );
  }
}
