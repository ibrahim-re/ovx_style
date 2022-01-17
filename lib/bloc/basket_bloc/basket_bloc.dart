import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_events.dart';
import 'package:ovx_style/bloc/basket_bloc/basket_states.dart';
import 'package:ovx_style/helper/helper.dart';
import 'package:ovx_style/model/basket.dart';

class BasketBloc extends Bloc<BasketEvent, BasketState> {
  BasketBloc() : super(BasketInitialized());

  List<BasketItem> basketItems = [];

  @override
  Stream<BasketState> mapEventToState(BasketEvent event) async* {
    if (event is AddItemToBasketEvent) {
      basketItems.add(BasketItem(
          id: Helper().generateRandomName(),
          price: event.price,
          title: event.title,
          color: event.color,
          size: event.size));

      yield ItemAddedToBasket();
    } else if (event is RemoveItemFromBasketEvent) {

    }
  }
}
