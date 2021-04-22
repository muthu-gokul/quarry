class SupplierGridModel {
  SupplierGridModel({
    this.supplierId,
    this.supplierName,
    this.supplierCategoryId,
    this.supplierCategoryName,
    this.location,
    this.supplierContactNumber,
    this.supplierEmail,
  });

  int supplierId;
  String supplierName;
  int supplierCategoryId;
  String supplierCategoryName;
  String location;
  String supplierContactNumber;
  String supplierEmail;

  factory SupplierGridModel.fromJson(Map<String, dynamic> json) => SupplierGridModel(
    supplierId: json["SupplierId"],
    supplierName: json["SupplierName"],
    supplierCategoryId: json["SupplierCategoryId"],
    supplierCategoryName: json["SupplierCategoryName"],
    location: json["Location"],
    supplierContactNumber: json["SupplierContactNumber"],
    supplierEmail: json["SupplierEmail"],
  );

  Map<String, dynamic> toJson() => {
    "SupplierId": supplierId,
    "SupplierName": supplierName,
    "SupplierCategoryId": supplierCategoryId,
    "SupplierCategoryName": supplierCategoryName,
    "Location": location,
    "SupplierContactNumber": supplierContactNumber,
    "SupplierEmail": supplierEmail,
  };
}
