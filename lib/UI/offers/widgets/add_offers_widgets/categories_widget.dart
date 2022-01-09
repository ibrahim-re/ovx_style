import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:ovx_style/UI/widgets/custom_redirect_widget.dart';
import 'package:ovx_style/UI/widgets/space_widget.dart';
import 'package:ovx_style/Utiles/colors.dart';
import 'package:ovx_style/Utiles/constants.dart';
import 'package:ovx_style/Utiles/navigation/named_navigator_impl.dart';
import 'package:ovx_style/bloc/add_offer_bloc/add_offer_bloc.dart';
import 'package:ovx_style/bloc/categories_bloc/categories_bloc.dart';
import 'package:ovx_style/bloc/categories_bloc/categories_events.dart';
import 'package:ovx_style/bloc/categories_bloc/categories_states.dart';
import 'package:ovx_style/helper/offer_helper.dart';

class CategoriesWidget extends StatelessWidget {

  //this is a variable used to tell Categories Widget where to save categories picked by user (for Filtering or for Add Offer)
  final String whereToUse;

  CategoriesWidget({required this.whereToUse});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>(
      create: (context) => CategoriesBloc(),
      child: CategoriesChild(whereToUse: whereToUse),
    );
  }
}

class CategoriesChild extends StatelessWidget {
  final String whereToUse;

  CategoriesChild({required this.whereToUse});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.read<CategoriesBloc>().add(FetchCategories());
        showCategoriesPicker(context, whereToUse);
      },
      child: CustomRedirectWidget(
        iconName: 'category',
        title: "${'category'.tr()} *",
      ),
    );
  }

  showCategoriesPicker(BuildContext context, String whereToUse) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<CategoriesBloc>(context),
        child: BlocBuilder<CategoriesBloc, CategoriesState>(
          builder: (_, state) {
            if (state is CategoriesLoading)
              return Center(child: CircularProgressIndicator());
            else if (state is CategoriesFetched)
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'categories'.tr(),
                      style: Constants.TEXT_STYLE2.copyWith(fontSize: 18),
                    ),
                    VerticalSpaceWidget(heightPercentage: 0.02),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.categories.length,
                        itemBuilder: (ctx, index) => InkWell(
                          onTap: () {
                            showSubCategoriesPicker(
                                context,
                                whereToUse,
                                state.categories[index].subCategories ?? [],
                                state.categories[index].name ?? '');
                          },
                          child: ListTile(
                            title: Text(
                              state.categories[index].name ?? '',
                              style: Constants.TEXT_STYLE3,
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: MyColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            else if (state is FetchCategoriesFailed)
              return Center(
                child: Text(
                  state.message,
                  style: Constants.TEXT_STYLE1,
                ),
              );
            else
              return Container();
          },
        ),
      ),
    );
  }

  showSubCategoriesPicker(BuildContext context, String whereToUse, List<dynamic> subCategories, String categoryName) {
    showModalBottomSheet(
        isDismissible: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        context: context,
        builder: (ctx) => StatefulBuilder(
              builder: (ctx, setNewState) => Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      categoryName,
                      style: Constants.TEXT_STYLE2.copyWith(fontSize: 18),
                    ),
                    VerticalSpaceWidget(heightPercentage: 0.02),
                    Expanded(
                      child: ListView.builder(
                        itemCount: subCategories.length,
                        itemBuilder: (ctx, index) => InkWell(
                          onTap: () {
                            if(whereToUse == 'Add Offer')
                              setNewState(() {
                              context.read<AddOfferBloc>().updateCategories(subCategories[index]);
                            });
                            else
                              setNewState(() {
                                OfferHelper.updateCategories(subCategories[index]);
                              });
                          },
                          child: ListTile(
                            title: Text(
                              subCategories[index] ?? '',
                              style: Constants.TEXT_STYLE3,
                            ),
                            trailing: whereToUse == 'Add Offer' ? context
                                    .read<AddOfferBloc>()
                                    .categories
                                    .contains(subCategories[index])
                                ? Icon(
                                    Icons.done,
                                    size: 20,
                                    color: MyColors.secondaryColor,
                                  )
                                : Icon(
                                    Icons.close,
                                    size: 20,
                                    color: MyColors.secondaryColor,
                                  ) : OfferHelper.categories.contains(subCategories[index]) ? Icon(
                              Icons.done,
                              size: 20,
                              color: MyColors.secondaryColor,
                            )
                                : Icon(
                              Icons.close,
                              size: 20,
                              color: MyColors.secondaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          NamedNavigatorImpl().pop();
                        },
                        child: Text(
                          'Ok',
                          style: Constants.TEXT_STYLE3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
