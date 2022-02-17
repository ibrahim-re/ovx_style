
import 'package:ovx_style/model/gift.dart';

class GiftsState {}

class GiftsInitialized extends GiftsState {}

class FetchGiftsLoading extends GiftsState {}

class FetchGiftsSucceed extends GiftsState {
  List<Gift> gifts;

  FetchGiftsSucceed(this.gifts);
}

class FetchGiftsFailed extends GiftsState {
  String message;

  FetchGiftsFailed(this.message);
}

class SendGiftLoading extends GiftsState {}

class SendGiftSucceed extends GiftsState {}

class SendGiftFailed extends GiftsState {
  String message;

  SendGiftFailed(this.message);
}