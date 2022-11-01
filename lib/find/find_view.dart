import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:tswiri/find/filter_view.dart';
import 'package:tswiri_theme/widgets/cards/filled_card.dart';
import 'package:tswiri_theme/widgets/cards/text_field_card.dart';

class FindView extends StatefulWidget {
  const FindView({
    super.key,
  });

  @override
  State<FindView> createState() => _FindViewState();
}

class _FindViewState extends State<FindView> {
  bool isSearching = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        _sliverAppBar(),
        _sliverGrid(),
      ],
    );
  }

  SliverAppBar _sliverAppBar() {
    return SliverAppBar(
      floating: true,
      pinned: true,
      title: TextField(
        focusNode: focusNode,
        onTap: () {},
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          fillColor: Colors.transparent,
          suffixIcon: const Icon(Icons.search_rounded),
          prefixIcon: OpenContainer(
            openColor: Colors.transparent,
            closedColor: Colors.transparent,
            closedBuilder: (context, action) {
              return IconButton(
                onPressed: action,
                icon: const Icon(Icons.menu_rounded),
              );
            },
            openBuilder: (context, action) {
              return const FilterView();
            },
          ),
          hintText: 'Search',
        ),
      ),
    );
  }

  SliverGrid _sliverGrid() {
    return SliverGrid.count(
      crossAxisCount: 2,
      children: [
        for (var i = 0; i < 25; i++)
          const FilledCard(
            child: Center(
              child: Text('data'),
            ),
          ),
      ],
    );
  }
}
