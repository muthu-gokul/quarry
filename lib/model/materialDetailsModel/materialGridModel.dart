class MaterialGridModel {

  MaterialGridModel({
    this.materialId,
    this.materialCode,
    this.materialName,
    this.materialCategoryId,
    this.materialCategoryName,
    this.materialUnitId,
    this.unitName,
    this.materialUnitPrice,
    this.materialDescription,
    this.materialHsnCode,
    this.taxValue,
  });

  int materialId;
  String materialCode;
  String materialName;
  int materialCategoryId;
  String materialCategoryName;
  int materialUnitId;
  String unitName;
  double materialUnitPrice;
  String materialDescription;
  String materialHsnCode;
  double taxValue;

  factory MaterialGridModel.fromJson(Map<String, dynamic> json) => MaterialGridModel(
    materialId: json["MaterialId"],
    materialCode: json["MaterialCode"],
    materialName: json["MaterialName"],
    materialCategoryId: json["MaterialCategoryId"],
    materialCategoryName: json["MaterialCategoryName"],
    materialUnitId: json["MaterialUnitId"],
    unitName: json["UnitName"],
    materialUnitPrice: json["MaterialUnitPrice"],
    materialDescription: json["MaterialDescription"],
    materialHsnCode: json["MaterialHSNCode"],
    taxValue: json["TaxValue"],
  );

  Map<String, dynamic> toJson() => {
    "MaterialId": materialId,
    "MaterialCode": materialCode,
    "MaterialName": materialName,
    "MaterialCategoryId": materialCategoryId,
    "MaterialCategoryName": materialCategoryName,
    "MaterialUnitId": materialUnitId,
    "UnitName": unitName,
    "MaterialUnitPrice": materialUnitPrice,
    "MaterialDescription": materialDescription,
    "MaterialHSNCode": materialHsnCode,
    "TaxValue": taxValue,
  };




  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('propery not found');
  }


}