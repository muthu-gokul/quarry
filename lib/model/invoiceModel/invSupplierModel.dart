class InvoiceSupplierModel {
  InvoiceSupplierModel({
    this.supplierId,
    this.supplierName,
    this.supplierType,
  });

  int? supplierId;
  String? supplierName;
  String? supplierType;

  factory InvoiceSupplierModel.fromJson(Map<String, dynamic> json) => InvoiceSupplierModel(
    supplierId: json["SupplierId"],
    supplierName: json["SupplierName"],
    supplierType: json["SupplierType"],
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