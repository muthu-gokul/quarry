class PurchaseSupplierType {
  PurchaseSupplierType({
    this.supplierType,
  });

  String? supplierType;

  factory PurchaseSupplierType.fromJson(Map<String, dynamic> json) => PurchaseSupplierType(
    supplierType: json["SupplierType"],
  );

  Map<String, dynamic> toJson() => {
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