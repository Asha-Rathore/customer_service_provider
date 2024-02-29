import 'dart:io';

import 'package:customer_service_provider_hybrid/business_module/home/provider/services_provider.dart';
import 'package:customer_service_provider_hybrid/business_module/service/model/add_service_model.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/model/service_detail_model.dart';
import 'package:customer_service_provider_hybrid/user_module/company_profile/provider/service_detail_provider.dart';
import 'package:customer_service_provider_hybrid/utils/app_dialogs.dart';
import 'package:customer_service_provider_hybrid/utils/app_navigation.dart';
import 'package:customer_service_provider_hybrid/utils/network_strings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as getImagePath;

import '../../../main_screen/routing_arguments/main_screen_routing_arguments.dart';
import '../../../services/network/network.dart';
import '../../../utils/app_route_name.dart';

class AddServiceBloc {
  FormData? _formData;
  Response? _response;
  VoidCallback? _onSuccess, _onFailure;
  ServiceResponseModel? _addServiceResponse;
  String? imagePath;
  String? imageName;
  File? _userFileImage;
  ServiceDetailProvider? _serviceDetailProvider;
  ServicesProvider? _servicesProvider;

  void addServiceBlocMethod({
    required BuildContext context,
    int? serviceId,
    String? serviceImage,
    String? name,
    String? location,
    String? description,
    bool? isEdit,
    required VoidCallback setProgressBar,
  }) async {
    setProgressBar();
    //FORM DATA
    print("IS EDIT ${isEdit}");
    Map<String, dynamic> formDataMap = {
      if (isEdit == true) "service_id": serviceId,
      "service_image": serviceImage,
      "name": name,
      "location": location,
      "description": description,
    };

    if (serviceImage != null) {
      _userFileImage = File(serviceImage);
      imagePath = _userFileImage!.path;
      imageName = getImagePath.basename(_userFileImage!.path);
      formDataMap["service_image"] =
          await MultipartFile.fromFile(imagePath!, filename: imageName);
    }

    _formData = FormData.fromMap(formDataMap);

    print({
      "service_id": serviceId,
      "service_image": serviceImage,
      "name": name,
      "location": location,
      "description": description,
    });

    _onFailure = () {
      Logger().e("On error");
      AppNavigation.navigatorPop(context);
    };

    await _postRequest(
        endPoint: NetworkStrings.ADD_SERVICE_ENDPOINT, context: context);

    _onSuccess = () {
      AppNavigation.navigatorPop(context);
      _addServiceResponseMethod(
          context: context, isEdit: isEdit, serviceId: serviceId);
    };
    _validateResponse();
  }

  //----------------------------------- Post Request -----------------------------------
  Future<void> _postRequest(
      {required String endPoint, required BuildContext context}) async {
    _response = await Network().postRequest(
        endPoint: endPoint,
        formData: _formData,
        context: context,
        onFailure: _onFailure,
        isHeaderRequire: true);
  }

  //----------------------------------- Validate Response -----------------------------------
  void _validateResponse() {
    if (_response != null) {
      Network().validateResponse(
          response: _response, onSuccess: _onSuccess, onFailure: _onFailure);
    }
  }

  void _addServiceResponseMethod(
      {required BuildContext context, bool? isEdit, int? serviceId}) async {
    try {
      _addServiceResponse = ServiceResponseModel.fromJson(_response?.data);
      if (_addServiceResponse != null) {
        //print("Add service response method:${_response?.data}");
        if (isEdit == true) {
          //this will add in service detail
          _serviceDetailProvider =
              Provider.of<ServiceDetailProvider>(context, listen: false);

          _serviceDetailProvider?.updateServiceDetailMethod(
              context: context, serviceResponseModel: _addServiceResponse);

          _servicesProvider =
              Provider.of<ServicesProvider>(context, listen: false);

          _servicesProvider?.updateServiceMethodMethod(
              serviceId: serviceId, serviceResponse: _response?.data["data"]);

          AppNavigation.navigatorPop(context);
        } else {
          AppNavigation.navigateTo(context, AppRouteName.MAIN_SCREEN_ROUTE,
              arguments: MainScreenRoutingArgument(index: 0));
        }
      }
    } catch (error) {
      AppDialogs.showToast(message: NetworkStrings.SOMETHING_WENT_WRONG);
    }
  }
}
