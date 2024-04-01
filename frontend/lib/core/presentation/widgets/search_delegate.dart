import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class MySearchDelegate extends SearchDelegate {
  late String selectedResult;
  final Function callback;

  MySearchDelegate(this.callback);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.close, size: 24, color: Colors.black,),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search_rounded, size: 24, color: Colors.black,),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(selectedResult),
    ); ///Поменять на страницу с информацией
  }

  @override
  void showResults(BuildContext context) {
    selectedResult = query;
    callback(query);
    close(context, query);
  }


  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchResults = ["Flower1", "Flower2", "Flower3", "Flower4", "Flower5", query]
        .where((element) => element.contains(query))
        .toList();

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
          leading: const Icon(
            Icons.search_rounded,
            size: 24,
            color: Color.fromARGB(100, 181, 181, 190),
          ),
          title: Text(searchResults[index]),
          onTap: () {
            selectedResult = searchResults[index];
            callback(selectedResult);
            AutoRouter.of(context).back();
          },
        );
      },
    );
  }
}