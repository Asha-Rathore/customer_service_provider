import 'dart:developer';

import 'package:customer_service_provider_hybrid/user_module/company_profile/arguments/company_profile_arguments.dart';
import 'package:customer_service_provider_hybrid/user_module/home/bloc/add_to_favorite_bloc.dart';
import 'package:customer_service_provider_hybrid/user_module/home/model/companies_list_model.dart';
import 'package:customer_service_provider_hybrid/user_module/home/provider/get_compaines_list_provider.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_home_container.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_padding.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_refresh_indicator_widget.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_search_textfield.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_sizebox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dialogs.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/app_route_name.dart';
import '../../../utils/app_strings.dart';
import '../../../widgets/custom_error_widget.dart';
import '../../../widgets/custom_not_found_text_refresh_indicator_widget.dart';

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final _searchCtrl = TextEditingController();
  AddToFavoriteBloc _addToFavoriteBloc = AddToFavoriteBloc();
  Future? _getCompaniesData;

  GetCompaniesListProvider? _companiesListProvider;
  List<CompaniesListData?>? searchList = [];
  bool _searchEnable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getCompaniesMethod();
    _getCompaniesList();
  }

  Future<void> _getCompaniesList() async {
    _companiesListProvider = context.read<GetCompaniesListProvider>();
    await _companiesListProvider?.getCompaniesListProviderMethod(
        context: context);
  }

  void _initializeProvider() {
    _companiesListProvider = context.watch<GetCompaniesListProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _initializeProvider();
    return Column(
      children: [
        _searchField(),
        CustomSizeBox(
          height: 7.h,
        ),
        Expanded(
          child: CustomRefreshIndicatorWidget(
              onRefresh: _getCompaniesList,
              child: _companiesListProvider?.waitingStatus == true
                  ? Center(child: AppDialogs.circularProgressWidget())
                  : _buildList()),
        ),
      ],
    );
  }

  Widget _searchField() {
    return CustomPadding(
      child: CustomSearchBar(
        controller: _searchCtrl,
        hintText: AppStrings.SEARCH_HERE,
        onChange: (String? text) {
          if (_searchEnable == true) {
            _companiesListProvider?.searchCompaniesMethod(searchText: text);
          } else {
            _searchCtrl.text = "";
            AppDialogs.showToast(message: AppStrings.SEARCH_INBOX_ERROR);
          }
        },
      ),
    );
  }

  Widget _buildList() {
    _searchEnable = true;
    return _companiesListProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : _companiesListProvider?.getCurrentMyCompaniesListData != null
            ? _customColumn()
            : Container(
                width: 1.sw,
                height: 1.sh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  child: CustomDataNotFoundForRefreshIndicatorTextWidget(
                      notFoundText: AppStrings.COMPANIES_NOT_FOUND_ERROR,
                      isSingleChildEnable: false),
                ),
              );
  }

  Widget _customColumn() {
    return _companiesList(
        companiesData:
            _companiesListProvider?.getCurrentMyCompaniesListData?.data);
  }

  // Widget _listView() {
  //   if (_searchCtrl.text.isNotEmpty == true) {
  //     searchOperation(
  //         companiesData:
  //             _companiesListProvider?.getCurrentMyCompaniesListData?.data);
  //   }
  //   return (searchList?.isNotEmpty == true &&
  //           _searchCtrl.text.isNotEmpty == true)
  //       ? _companiesList(companiesData: searchList)
  //       : (searchList?.isEmpty == true && _searchCtrl.text.isNotEmpty == true)
  //           ? CustomDataNotFoundForRefreshIndicatorTextWidget(
  //               height: 400.h,
  //               notFoundText: AppStrings.COMPANIES_NOT_FOUND_ERROR)
  //           : _companiesList(
  //               companiesData: _companiesListProvider
  //                   ?.getCurrentMyCompaniesListData?.data);
  // }

  Widget _companiesList({List<CompaniesListData?>? companiesData}) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 0.5.sw,
          childAspectRatio: 0.8,
          crossAxisSpacing: 22.0,
          mainAxisSpacing: 22.0,
        ),
        itemCount: companiesData?.length,
        padding: EdgeInsets.only(bottom: 36.0, top: 20.0),
        physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        itemBuilder: (BuildContext ctx, index) {
          return Padding(
            padding: EdgeInsets.only(
                left: index.isEven ? 20.w : 0.w,
                right: index.isOdd ? 20.w : 0.w),
            child: GestureDetector(
              onTap: () {
                print("ON TAP");

                Constants.unFocusKeyboardMethod(context: context);

                AppNavigation.navigateTo(
                    context, AppRouteName.COMPANY_PROFILE_SCREEN_ROUTE,
                    arguments: CompanyProfileArguments(
                        isFavourite: companiesData?[index]?.isFavoriteCount ==
                                NetworkStrings.IS_FAVORITE
                            ? true
                            : false,
                        index: index,
                        companyId: companiesData?[index]?.id));

                _searchCtrl.text = "";

                _companiesListProvider?.searchCompaniesMethod(searchText: "");
              },
              child: CustomHomeContainer(
                showHeartIcon: true,
                placeHolderImage: AssetPath.BUSINESS_PLACEHOLDER_IMAGE,
                isViewAsset:
                    companiesData?[index]?.profileImage == null ? true : false,
                image: companiesData?[index]?.profileImage ?? "",
                mainText: companiesData?[index]?.companyName ?? "",
                subText:
                    "${companiesData?[index]?.phoneCode ?? ""} ${companiesData?[index]?.phoneNumber ?? ""}",
                description: companiesData?[index]?.companyDescription ?? "",
                isFilled: companiesData?[index]?.isFavoriteCount ==
                        NetworkStrings.IS_FAVORITE
                    ? true
                    : false,
                subTextImage: AssetPath.PHONE_ICON,
                onHeartTap: () {
                  Constants.unFocusKeyboardMethod(context: context);
                  _addToFavoriteBloc.addToFavBlocMethod(
                      context: context,
                      companyId: companiesData?[index]?.id,
                      setProgressBar: () {
                        AppDialogs.progressAlertDialog(context: context);
                      },
                      onApiSuccess: (isFav) {
                        _companiesListProvider?.addOrRemoveFavorite(
                            index: index,
                            isFav: isFav,
                            companyId: companiesData?[index]?.id);
                      });
                },
              ),
            ),
          );
        });
  }
}
