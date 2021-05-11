class SupplierModel {
  SupplierModel({
    this.supplierId,
    this.supplierName,
    this.supplierType,
    this.isActive
  });

  int supplierId;
  String supplierName;
  String supplierType;
  bool isActive;

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
    supplierId: json["SupplierId"],
    supplierName: json["SupplierName"],
    supplierType: json["SupplierType"],
    isActive: true
  );

  Map<String, dynamic> toJson() => {
    "SupplierId": supplierId,
    "SupplierName": supplierName,
    "SupplierType": supplierType,
  };

  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }


}
