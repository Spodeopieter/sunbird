import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunbird/views/tutorial/getting_started_view.dart';
import 'globals/globals_export.dart';
import 'isar/isar_database.dart';
import 'views/containers/containers_view/containers_view.dart';
import 'views/search/search_view.dart';
import 'views/settings/settings_view.dart';
import 'views/utilities/utilities_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Force portraitUp.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //TODO: Implement Firebase.

  //Get Camera descriptions.
  cameras = await availableCameras();

  //Request Permissions.
  var storageStatus = await Permission.storage.status;
  if (storageStatus.isDenied) {
    Permission.storage.request();
  }

  //Initiate Isar
  isarDirectory = await getApplicationSupportDirectory();
  isar = initiateIsar(inspector: false);
  createBasicContainerTypes();
  await initiatePhotoStorage();

  //Load Settigns.
  loadAppSettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeData(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isSearching = false;

  @override
  void initState() {
    _tabController = TabController(
      vsync: this,
      length: 4,
      initialIndex: 1,
    );

    // _showMyDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabBarView(),
      bottomSheet: isSearching ? const SizedBox.shrink() : _bottomSheet(),
    );
  }

  Widget _tabBarView() {
    return TabBarView(
      physics: isSearching ? const NeverScrollableScrollPhysics() : null,
      controller: _tabController,
      children: [
        ContainersView(
          isSearching: (value) => setState(() {
            isSearching = value;
          }),
        ),
        SearchView(
          isSearching: (value) => setState(() {
            isSearching = value;
          }),
        ),
        const UtilitiesView(),
        const SettingsView(),
      ],
    );
  }

  Widget _bottomSheet() {
    return TabBar(
      // isScrollable: !isSearching,
      controller: _tabController,
      labelPadding: const EdgeInsets.all(2.5),
      tabs: const [
        Tooltip(
          message: "Containers",
          child: Tab(
            icon: Icon(
              Icons.account_tree_sharp,
            ),
          ),
        ),
        Tooltip(
          message: "Search",
          child: Tab(
            icon: Icon(
              Icons.search_sharp,
            ),
          ),
        ),
        Tooltip(
          message: "Utilities",
          child: Tab(
            icon: Icon(Icons.build_sharp),
          ),
        ),
        Tooltip(
          message: "Settings",
          child: Tab(
            icon: Icon(
              Icons.settings_sharp,
            ),
          ),
        ),
      ],
    );
  }
}
