class InvoiceTypeModel {
  InvoiceTypeModel({
    this.invoiceType,
    this.isActive,
  });

  String invoiceType;
  bool isActive;
  factory InvoiceTypeModel.fromJson(Map<String, dynamic> json) => InvoiceTypeModel(
    invoiceType: json["InvoiceType"],
    isActive: true,
  );

  Map<String, dynamic> toGridJson() => {
    "InvoiceType": invoiceType,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}