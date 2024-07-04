import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pagination_demo_flutter/api_end_points.dart';
import 'package:pagination_demo_flutter/universitymodel.dart';
import 'package:scroll_pagination_flutter/pagination_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final PagingController<int, UniversityModel> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await get(Uri.parse(ApiEndPoint.universityList
          .replaceAll("{LIMIT}", "10")
          .replaceAll("{PAGE}", "$pageKey")));
      if (kDebugMode) {
        print(response.statusCode);
      }
      if (kDebugMode) {
        print(response.body);
      }
      pageKey++;
      if (response.statusCode == 200) {
        var newItems = universityModelFromJson((response.body));

        if (newItems.isEmpty) {
          _pagingController.appendLastPage(newItems);
        } else {
          _pagingController.appendPage(newItems, pageKey);
        }
      } else {
        throw "not found";
      }
    } catch (error) {
      _pagingController.error = error;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Scaffold(
          appBar: AppBar(
            title: const Text("Pagination demo"),
          ),
          body: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => _pagingController.refresh(),
            ),
            child: PagedListView<int, UniversityModel>.separated(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<UniversityModel>(
                  animateTransitions: true,
                  singleitemBuilder: (context, item, index) => ListTile(
                        leading: CircleAvatar(
                          child: Text(item.alphaTwoCode),
                        ),
                        title: Text(item.name),
                        subtitle: Text(item.domains.toString()),
                      ),
                  firstPageErrorIndicatorWidget: (_) => Center(
                          child: Column(
                        children: [
                          const Text("Error"),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                _pagingController.refresh();
                              },
                              child: const Text("Try Again.."))
                        ],
                      )),
                  noItemsFoundIndicatorWidget: (_) =>
                      const Center(child: Text("No data"))),
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
