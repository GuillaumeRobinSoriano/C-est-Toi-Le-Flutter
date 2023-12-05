import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:my_app/Elements/app_bar.dart';
import 'package:my_app/Models/item.dart';
import 'package:my_app/Repository/firestore_service.dart';
import 'package:my_app/Store/State/app_state.dart';
import 'package:my_app/Store/ViewModels/market_view_model.dart';
import 'package:my_app/Tools/color.dart';
import 'package:redux/redux.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => MarketPageState();
}

class MarketPageState extends State<MarketPage> {
  final GlobalKey<ScaffoldState> drawerScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MarketViewModel>(
      converter: (Store<AppState> store) =>
          MarketViewModel.factory(store, FirestoreService()),
      onInitialBuild: (MarketViewModel viewModel) {
        viewModel.loadItems();
      },
      builder: (BuildContext context, MarketViewModel viewModel) {
        return StoreConnector<AppState, MarketViewModel>(
          converter: (Store<AppState> store) =>
              MarketViewModel.factory(store, FirestoreService()),
          builder: (BuildContext context, MarketViewModel viewModel) {
            return Scaffold(
              key: drawerScaffoldKey,
              body: viewModel.items.isEmpty
                  ? const Text('ça charge....')
                  : ListView.builder(
                      itemCount: viewModel.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        debugPrint(
                          'this is the image $index ${viewModel.items.elementAt(index).images}',
                        );
                        return buildItem(viewModel.items.elementAt(index));
                      },
                    ),
              appBar: const MyAppBar(),
              backgroundColor: MyColor().myWhite,
            );
          },
        );
      },
    );
  }
// return Text(viewModel.items.elementAt(index).title);

  /// Widget item
  Widget buildItem(Item item) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 5),
        child: Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            border: Border.all(
              color: MyColor().myGrey,
            ),
            // color: const Color(0xFFE5E4E2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    item.images[0].isNotEmpty
                        ? item.images[0]
                        : 'https://picsum.photos/seed/502/600',
                    width: 200,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  item.title.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: Text(
                  '${item.price} €',
                ),
              ),
            ],
          ),
        ),
      );
}
