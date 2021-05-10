class SupplierCategoryModel {
  SupplierCategoryModel({
    this.supplierCategoryId,
    this.supplierCategoryName,
  });

  int supplierCategoryId;
  String supplierCategoryName;

  factory SupplierCategoryModel.fromJson(Map<String, dynamic> json) => SupplierCategoryModel(
    supplierCategoryId: json["SupplierCategoryId"],
    supplierCategoryName: json["SupplierCategoryName"],
  );

  Map<String, dynamic> toJson() => {
    "SupplierCategoryId": supplierCategoryId,
    "SupplierCategoryName": supplierCategoryName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}
