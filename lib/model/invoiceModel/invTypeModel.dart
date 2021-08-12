class InvoiceTypeModel {
  InvoiceTypeModel({
    this.invoiceType,
  });

  String? invoiceType;

  factory InvoiceTypeModel.fromJson(Map<String, dynamic> json) => InvoiceTypeModel(
    invoiceType: json["InvoiceType"],
  );

  Map<String, dynamic> toJson() => {
    "InvoiceType": invoiceType,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}