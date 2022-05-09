import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_events.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_states.dart';
import 'package:ovx_style/helper/basket_helper.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/basket.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  BasketBloc() : super(BasketInitialized());

  List<BasketItem> basketItems = [];


  @override
  Stream<BasketState> mapEventToState(BasketEvent event) async* {
    if (event is AddItemToBasketEvent) {
      print('price is ${event.shippingCost}');
      basketItems.add(
        BasketItem(
          id: Helper().generateRandomName(),
          productId: event.productId,
          productOwnerId: event.productOwnerId,
          imagePath: event.imagePath,
          price: event.price,
          productName: event.title,
          color: event.color,
          size: event.size,
          vat: event.vat,
          shippingCost: event.shippingCost,
          shipTo: event.shipTo,
        ),
      );

      yield ItemAddedToBasket();
    } else if (event is RemoveItemFromBasketEvent) {
      basketItems.removeWhere((basketItem) => basketItem.id == event.id);

      yield ItemRemovedFromBasket();
    } else if(event is ClearBasket){
      basketItems.clear();
      yield BasketCleared();
    }
  }
}
