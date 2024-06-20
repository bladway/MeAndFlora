import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_and_flora/core/theme/theme.dart';

import '../bloc/plant_search/plant_search.dart';

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
        selectedResult = query;
        callback(query);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(selectedResult),
    );
  }

  @override
  void showResults(BuildContext context) {
    selectedResult = query;
    callback(query);
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
          },
        );
      },
    );
  }

  Future<void> _search(context, String plantName) async {
    BlocProvider.of<PlantSearchBloc>(context).add(PlantSearchRequested(plantName));
  }
}
