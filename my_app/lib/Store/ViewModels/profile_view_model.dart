import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/Models/item.dart';
import 'package:my_app/Models/my_orders.dart';
import 'package:my_app/Models/user_infos.dart';
import 'package:my_app/Repository/firestore_service.dart';
import 'package:my_app/Store/Actions/profile_actions.dart';
import 'package:my_app/Store/State/app_state.dart';
import 'package:redux/redux.dart';

/// The profile view model
class ProfileViewModel {
  /// The profile view model
  ProfileViewModel({
    required this.userInfos,
    required this.loadUserInfo,
    required this.changeUserPicture,
    required this.uuid,
    required this.orders,
    required this.signOut,
    required this.deleteItem,
    required this.sellingItems,
    required this.isSeller,
  });

  /// The profile view model factory
  factory ProfileViewModel.factory(
    Store<AppState> store,
    FirestoreService firestore,
  ) {
    final String userUUID = firestore.getCurrentUserUUID();

    return ProfileViewModel(
      uuid: (store.state.profile.uuid == ' ')
          ? userUUID
          : store.state.profile.uuid,
      loadUserInfo: () async {
        final UserInfos response = await firestore.getUserInfos(
          (store.state.profile.uuid == ' ')
              ? userUUID
              : store.state.profile.uuid,
        );
        if (response.isSeller) {
          store.dispatch(ProfileIsSellerAction(isSeller: true));
        } else {
          store.dispatch(ProfileIsSellerAction(isSeller: false));
        }
        store.dispatch(ProfileUserInfosAction(userInfos: response));
        final OrderList orders = await firestore.getOrders(
          store.state.profile.uuid == ' ' ? userUUID : store.state.profile.uuid,
        );
        store.dispatch(ProfileLastOrdersAction(orders: orders));
        final List<Item> onSaleItems = await firestore.getSellingItems(
          store.state.profile.uuid == ' ' ? userUUID : store.state.profile.uuid,
        );
        store.dispatch(ProfileSellingItemsAction(sellingItems: onSaleItems));
      },
      signOut: () async {
        await FirebaseAuth.instance.signOut();
        store.dispatch(ProfileSetUserUUIDAction(uuid: ' '));
      },
      changeUserPicture: () async {
        final ImagePicker picker = ImagePicker();
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          final (bool, String) res = await firestore.addPictureToStorage(image);
          if (res.$1 == true) {
            final bool res2 = await firestore.changeUserProfilePicture(
              store.state.profile.uuid == ' '
                  ? userUUID
                  : store.state.profile.uuid,
              res.$2,
            );
            if (res2) {
              store.dispatch(ProfileChangeUserPictureAction(picture: res.$2));
              debugPrint('User profile picture changed');
            }
          }
        }
      },
      deleteItem: (String itemUUID) async {
        final bool res = await firestore.deleteItem(itemUUID);
        if (res) {
          final List<Item> newSellingItems = store.state.profile.sellingItems!
              .where((Item item) => item.id != itemUUID)
              .toList();
          store.dispatch(
            ProfileSellingItemsAction(sellingItems: newSellingItems),
          );
        }
      },
      orders: store.state.profile.orders,
      userInfos: store.state.profile.userInfos!,
      sellingItems: store.state.profile.sellingItems!,
      isSeller: store.state.profile.isSeller,
    );
  }

  /// The user infos
  final UserInfos? userInfos;
  // final List<String> foo;
  /// The load user info
  final Function loadUserInfo;

  /// The change user picture
  final Function changeUserPicture;

  /// The sign out function
  final Function signOut;

  /// The delete item function
  final Function deleteItem;

  /// The is seller
  final bool isSeller;

  /// The uuid
  final String uuid;

  /// The orders
  final OrderList? orders;

  /// The items that the user is selling
  final List<Item>? sellingItems;
}
