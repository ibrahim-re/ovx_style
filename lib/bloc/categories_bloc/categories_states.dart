
import 'package:ovx_style/model/category.dart';

abstract class CategoriesState {}

class CategoriesStateInitial extends CategoriesState {}

class CategoriesFetched extends CategoriesState {
  List<Category> categories;

  CategoriesFetched(this.categories);
}

class CategoriesLoading extends CategoriesState {}

class FetchCategoriesFailed extends CategoriesState {
  String message;

  FetchCategoriesFailed(this.message);
}