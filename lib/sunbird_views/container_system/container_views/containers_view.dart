import 'package:flutter/material.dart';
import 'package:flutter_google_ml_kit/isar_database/container_entry/container_entry.dart';
import 'package:flutter_google_ml_kit/isar_database/container_relationship/container_relationship.dart';
import 'package:flutter_google_ml_kit/isar_database/container_type/container_type.dart';
import 'package:flutter_google_ml_kit/widgets/card_widgets/container_card_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:isar/isar.dart';

import '../../../functions/barcodeTools/hide_keyboard.dart';
import '../create_container_views/create_new_container_view.dart';
import '../../../isar_database/functions/isar_functions.dart';

import '../../../widgets/search_bar_widget.dart';
import 'container_view.dart';

class ContainersView extends StatefulWidget {
  const ContainersView({Key? key}) : super(key: key);

  @override
  _ContainersViewState createState() => _ContainersViewState();
}

class _ContainersViewState extends State<ContainersView> {
  List<ContainerEntry> searchResults = [];
  Isar? database;
  String enteredKeyword = '';

  @override
  void initState() {
    database = openIsar();

    if (database!.containerTypes.where().findAllSync().isEmpty) {
      createBasicContainerTypes();
    }

    super.initState();
  }

  @override
  void dispose() {
    database = closeIsar(database);
    super.dispose();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          "Containers",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [_infoButton()],
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0), child: _newContainerButton()),
      body: GestureDetector(
        onTap: () {
          hideKeyboard(context);
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///Search Bar.
              _searchBar(),
              const SizedBox(height: 10),
              _optionsText(),
              const SizedBox(height: 5),
              _buildListView()
            ],
          ),
        ),
      ),
    );
  }

  Widget _newContainerButton() {
    return FloatingActionButton(
      heroTag: null,
      onPressed: () async {
        await createNewContainer(context);
        setState(() {});
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _searchBar() {
    return SearchBarWidget(
      onChanged: (value) {
        setState(() {
          enteredKeyword = value;
        });
      },
    );
  }

  Widget _optionsText() {
    return const Text(
      'Swipe for more options',
      style: TextStyle(fontSize: 12),
    );
  }

  Widget _infoButton() {
    return IconButton(
      onPressed: () {
        showInfoDialog();
      },
      icon: const Icon(Icons.info_outline_rounded),
    );
  }

  Widget _buildListView() {
    return Builder(
      builder: (context) {
        List<ContainerEntry> results = database!.containerEntrys
            .filter()
            .nameContains(enteredKeyword, caseSensitive: false)
            .or()
            .containerTypeContains(enteredKeyword)
            .sortByBarcodeUID()
            .findAllSync();

        return Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: ((context, index) {
              ContainerEntry containerEntry = results[index];
              return InkWell(
                onTap: () async {
                  //Push ContainerView
                  await Navigator.push(
                    context,
                    (MaterialPageRoute(
                      builder: (context) => ContainerView(
                        database: database,
                        containerUID: containerEntry.containerUID,
                      ),
                    )),
                  );
                  //Update all entires
                  setState(() {});
                },
                //Allows for slide action/options.
                child: Slidable(
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      // An action can be bigger than the others.
                      flex: 1,
                      onPressed: (context) {
                        database!.writeTxnSync(
                          (isar) {
                            isar.containerEntrys.deleteSync(containerEntry.id);

                            isar.containerRelationships
                                .filter()
                                .containerUIDMatches(
                                    containerEntry.containerUID)
                                .deleteAllSync();
                          },
                        );
                        refresh();
                      },
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      icon: Icons.archive,
                      label: 'Delete',
                    ),
                  ]),
                  child: ContainerCardWidget(
                      containerEntry: containerEntry, database: database!),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  ///Navigate to NewContainerView on return update filter
  Future<void> createNewContainer(BuildContext context) async {
    await Navigator.push(
      context,
      (MaterialPageRoute(
        builder: (context) => CreateNewContainerView(
          database: database!,
        ),
      )),
    );
    setState(() {});
  }

  ///Show the info Dialog.
  void showInfoDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Area ?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [Text('Info Here')],
        ),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.pop(_);
              },
              child: const Text('ok'))
        ],
      ),
    );
  }

  void createBasicContainerTypes() {
    database!.writeTxnSync((database) {
      database.containerTypes.putSync(
          ContainerType()
            ..id = 1
            ..containerType = 'area'
            ..canContain = ['shelf', 'box', 'drawer']
            ..structured = true
            ..containerColor = const Color(0xFFff420e).value.toString(),
          replaceOnConflict: true);

      database.containerTypes.putSync(
          ContainerType()
            ..id = 2
            ..containerType = 'shelf'
            ..canContain = ['box', 'drawer']
            ..structured = true
            ..containerColor = const Color(0xFF89da59).value.toString(),
          replaceOnConflict: true);

      database.containerTypes.putSync(
          ContainerType()
            ..id = 3
            ..containerType = 'drawer'
            ..canContain = ['box', 'shelf']
            ..structured = true
            ..containerColor = Colors.blue.value.toString(),
          replaceOnConflict: true);

      database.containerTypes.putSync(
          ContainerType()
            ..id = 4
            ..containerType = 'box'
            ..canContain = ['box', 'shelf']
            ..structured = true
            ..containerColor = const Color(0xFFF98866).value.toString(),
          replaceOnConflict: true);
    });
  }
}
