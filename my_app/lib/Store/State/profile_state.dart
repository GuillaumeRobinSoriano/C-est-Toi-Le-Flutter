import 'package:my_app/Models/item.dart';
import 'package:my_app/Models/my_orders.dart';
import 'package:my_app/Models/user_infos.dart';

/// The profile state
class ProfileState {
  /// The profile state
  ProfileState({
    this.lastItemsBought,
    this.userInfos,
    this.uuid = ' ',
    this.orders,
    this.sellingItems,
    this.isSeller = false,
    // this.uuid = 'CI6MG2mmRnfz2uNCCFmNrW8Z1J83',
  });

  /// The profile state initial
  factory ProfileState.initial() => ProfileState(
        lastItemsBought: <Item>[],
        userInfos: UserInfos(
          uuid: ' ',
          email: '',
          profilePicture: '',
          isSeller: false,
          formatedEmail: '',
        ),
        orders: <MyOrder>[],
        sellingItems: <Item>[],
      );

  /// The last items bought
  List<Item>? lastItemsBought;

  /// The user infos
  UserInfos? userInfos;

  /// The uuid
  String uuid;

  /// The orders
  OrderList? orders;

  /// The seller items
  List<Item>? sellingItems;

  /// If the user is a seller => true
  bool isSeller;
}
