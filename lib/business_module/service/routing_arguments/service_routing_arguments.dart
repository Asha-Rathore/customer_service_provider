class ServiceScreenRoutingArgument {
  bool? isFromProfile, isEditService;
  int? serviceid;
  String? serviceName, serviceImage, location, description;

  ServiceScreenRoutingArgument({
    this.isEditService,
    this.isFromProfile,
    this.serviceid,
    this.serviceImage,
    this.description,
    this.location,
    this.serviceName
  });
}
