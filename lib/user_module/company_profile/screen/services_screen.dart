import 'package:customer_service_provider_hybrid/services_detail/routing_arguments/service_detail_routing_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_dialogs.dart';
import '../../../utils/app_navigation.dart';
import '../../../utils/app_route_name.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/asset_paths.dart';
import '../../../widgets/custom_error_widget.dart';
import '../../../widgets/custom_home_container.dart';
import '../bloc/company_services_bloc.dart';
import '../model/company_services_model.dart';

class ServicesScreen extends StatefulWidget {
  int? companyId;

  ServicesScreen({super.key, this.companyId});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  CompanyServicesBloc _companyServicesBloc = CompanyServicesBloc();

  @override
  void initState() {
    super.initState();
    _getCompanyServices();
  }

  Future<void> _getCompanyServices() async {
    await _companyServicesBloc?.companyServices(
        context: context, companyId: widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return _services();
  }

  Widget _services() {
    return StreamBuilder(
      stream: _companyServicesBloc.getCompanyServicesList(),
      builder: (BuildContext context,
          AsyncSnapshot<CompanyServices?>? servicesListSnapShot) {
        if (servicesListSnapShot?.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(top: 60.h),
            child: AppDialogs.circularProgressWidget(),
          );
        } else {
          return servicesListSnapShot?.data?.data != null
              ? _servicesGridView(
                  servicesListSnapShot: servicesListSnapShot)
              : Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: CustomErrorWidget(
                  errorImagePath: AssetPath.DATA_NOT_FOUND_ICON,
                  errorText: AppStrings.SERVICES_NOT_FOUND_ERROR,
                  imageSize: 70.h,
                ),
              );
        }
      },
    );
  }

  Widget _servicesGridView(
      {AsyncSnapshot<CompanyServices?>? servicesListSnapShot}) {
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 0.5.sw,
          childAspectRatio: 1.0,
          crossAxisSpacing: 22.0,
          mainAxisSpacing: 22.0,
        ),
        itemCount: servicesListSnapShot?.data?.data?.length,
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 8.0.h),
        itemBuilder: (BuildContext ctx, index) {
          return GestureDetector(
            onTap: () {
              AppNavigation.navigateTo(
                  context, AppRouteName.SERVICE_DETAIL_SCREEN_ROUTE,
                  arguments: ServiceDetailArguments(
                      serviceId: servicesListSnapShot?.data?.data?[index]?.id));
            },
            child: CustomHomeContainer(
              placeHolderImage: AssetPath.SERVICE_PLACEHOLDER_IMAGE,
              isViewAsset:
                  servicesListSnapShot?.data?.data?[index]?.serviceImage == null
                      ? true
                      : false,
              image: servicesListSnapShot?.data?.data?[index]?.serviceImage ?? "",
              mainText: servicesListSnapShot?.data?.data?[index]?.name ?? "",
              description:
                  servicesListSnapShot?.data?.data?[index]?.description ?? "",
            ),
          );
        },
      ),
    );
  }
}
