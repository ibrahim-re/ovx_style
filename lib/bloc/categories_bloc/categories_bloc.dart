import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/api/offers/offers_repository.dart';
import 'package:ovx_style/bloc/categories_bloc/categories_states.dart';
import 'package:ovx_style/model/category.dart';
import 'categories_events.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc() : super(CategoriesStateInitial());

OffersRepositoryImpl offersRepositoryImpl = OffersRepositoryImpl();



@override
Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
  if (event is FetchCategories) {
    yield CategoriesLoading();
    try {
      List<Category> fetchedCategories = await offersRepositoryImpl.getCategories();
      yield CategoriesFetched(fetchedCategories);
    } catch (e) {
      yield FetchCategoriesFailed('error occurred'.tr());
    }
  }
}
}
