import 'package:my_app/Models/item.dart';
import 'package:my_app/Store/Actions/basket_actions.dart';
import 'package:my_app/Store/State/app_state.dart';
import 'package:redux/redux.dart';

class BasketViewModel {
  BasketViewModel({
    required this.items,
    required this.addCart,
  });

  factory BasketViewModel.factory(Store<AppState> store) {
    return BasketViewModel(
      items: store.state.basket.items,
      addCart: (Item item) {
        store.dispatch(BasketAddItemAction(item: item));
      },
    );
  }

  final List<Item>? items;
  final Function addCart;
}
