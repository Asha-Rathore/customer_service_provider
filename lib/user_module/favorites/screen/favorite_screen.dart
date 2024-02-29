import 'package:customer_service_provider_hybrid/user_module/company_profile/arguments/company_profile_arguments.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/bloc/favorite_list_bloc.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/model/favorite_list_model.dart';
import 'package:customer_service_provider_hybrid/user_module/favorites/provider/favorite_list_provider.dart';
import 'package:customer_service_provider_hybrid/user_module/home/provider/get_compaines_list_provider.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/app_route_name.dart';
import 'package:customer_service_provider_hybrid/utils/app_strings.dart';
import 'package:customer_service_provider_hybrid/utils/asset_paths.dart';
import 'package:customer_service_provider_hybrid/utils/constants.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_app_template.dart';
import 'package:customer_service_provider_hybrid/widgets/custom_refresh_indicator_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/app_dialogs.dart';
import '../../../widgets/custom_error_widget.dart';
import '../../../widgets/custom_home_container.dart';
import '../../../widgets/custom_not_found_text_refresh_indicator_widget.dart';
import '../../../widgets/custom_padding.dart';
import '../../../widgets/custom_search_textfield.dart';
import '../../../widgets/custom_sizebox.dart';
import '../../home/bloc/add_to_favorite_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  int userid;

  FavoriteScreen({Key? key, required this.userid}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final _searchCtrl = TextEditingController();
  FavoriteListBloc _favoriteListBloc = FavoriteListBloc();
  AddToFavoriteBloc _addToFavoriteBloc = AddToFavoriteBloc();
  Future? _getFavoriteList;

  GetFavoriteListProvider? _getFavoriteListProvider;
  GetCompaniesListProvider? _companiesListProvider;

  bool _searchEnable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavoriteList();
    // _getFavoriteListMethod();
  }

  Future<void> getFavoriteList() async {
    _companiesListProvider = context.read<GetCompaniesListProvider>();
    _getFavoriteListProvider = context.read<GetFavoriteListProvider>();
    await _getFavoriteListProvider?.getFavoriteListProviderMethod(
        context: context, userId: widget.userid);
  }

  void _initializeProvider() {
    _getFavoriteListProvider = context.watch<GetFavoriteListProvider>();
  }

  @override
  Widget build(BuildContext context) {
    _initializeProvider();
    return CustomAppTemplate(
      title: AppStrings.FAVOURITES,
      child: Column(
        children: [
          CustomSizeBox(),
          _searchField(),
          Expanded(
            child: CustomRefreshIndicatorWidget(
                onRefresh: getFavoriteList,
                child: Container(
                  width: 1.sw,
                  height: 1.sh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    child: _getFavoriteListProvider?.waitingStatus == true
                        ? Center(child: Padding(
                        padding: EdgeInsets.only(top: 0.5.sw),
                        child: AppDialogs.circularProgressWidget()))
                        : _buildList(),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    _searchEnable = true;
    return _getFavoriteListProvider?.waitingStatus == true
        ? AppDialogs.circularProgressWidget()
        : (_getFavoriteListProvider?.getFavoriteListData?.data?.length ?? 0) > 0
            ? _customColumn()
            : CustomDataNotFoundForRefreshIndicatorTextWidget(
                notFoundText: AppStrings.FAVORITE_COMPANIES_NOT_FOUND_ERROR,isSingleChildEnable: false);
  }

  Widget _customColumn() {
    return _gridView(
        favoriteData: _getFavoriteListProvider?.getFavoriteListData?.data);
  }

  Widget _searchField() {
    return CustomPadding(
      child: CustomSearchBar(
        controller: _searchCtrl,
        hintText: AppStrings.SEARCH_HERE,
        onChange: (String? text) {

          if (_searchEnable == true) {
            _getFavoriteListProvider?.searchFavouriteMethod(searchText: text);
          } else {
            _searchCtrl.text = "";
            AppDialogs.showToast(message: AppStrings.SEARCH_INBOX_ERROR);
          }



        },
      ),
    );
  }

  Widget _gridView({List<FavoriteListData?>? favoriteData}) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 0.5.sw,
          childAspectRatio: 0.8,
          crossAxisSpacing: 22.0,
          mainAxisSpacing: 22.0,
        ),
        padding: EdgeInsets.symmetric(vertical: 15.h),
        itemCount: favoriteData?.length,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext ctx, index) {
          return Padding(
              padding: EdgeInsets.only(
                  left: index.isEven ? 20.w : 0.w,
                  right: index.isOdd ? 20.w : 0.w),
              child: InkWell(
                onTap: () {
                  Constants.unFocusKeyboardMethod(context: context);
                  AppNavigation.navigateTo(
                      context, AppRouteName.COMPANY_PROFILE_SCREEN_ROUTE,
                      arguments: CompanyProfileArguments(
                        isFavourite: true,
                        companyId: favoriteData?[index]?.id,
                      ));

                  _searchCtrl.text = "";
                  _getFavoriteListProvider?.searchFavouriteMethod(
                      searchText: "");
                },
                child: CustomHomeContainer(
                  showHeartIcon: true,
                  placeHolderImage: AssetPath.BUSINESS_PLACEHOLDER_IMAGE,
                  image: favoriteData?[index]?.profileImage ?? "",
                  mainText: favoriteData?[index]?.companyName ?? "",
                  subText:
                      "${favoriteData?[index]?.phoneCode ?? ""} ${favoriteData?[index]?.phoneNumber ?? ""}",
                  description: favoriteData?[index]?.companyDescription ?? "",
                  isFilled: true,
                  subTextImage: AssetPath.PHONE_ICON,
                  onHeartTap: () {
                    Constants.unFocusKeyboardMethod(context: context);

                    _addToFavoriteBloc.addToFavBlocMethod(
                        context: context,
                        companyId: favoriteData?[index]?.id,
                        setProgressBar: () {
                          AppDialogs.progressAlertDialog(context: context);
                        },
                        onApiSuccess: (isFav) {
                          print("Is fav:${isFav}");
                          int? companyId = favoriteData?[index]?.id;
                          _getFavoriteListProvider?.removeFavorite(
                              companyId: companyId);
                          _companiesListProvider?.addOrRemoveFavorite(
                              index: index,
                              isFav: isFav,
                              companyId: companyId);
                        });
                  },
                ),
              ));
        });
  }

// void _getFavoriteListMethod() {
//   print("USER ID:${widget.userid}");
//   _getFavoriteList = _favoriteListBloc.favoriteList(
//       context: context, userId: widget.userid);
//
// }
}
