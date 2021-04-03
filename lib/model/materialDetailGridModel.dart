class MaterialDetailGridModel{
  int MaterialId;
  int MaterialUnitId;
  String MaterialCode;
  String MaterialName;
  String UnitName;
  String MaterialDescription;
  String TaxName;
  double MaterialUnitPrice;
  double MaterialTaxValue;

  MaterialDetailGridModel({this.MaterialId,this.MaterialCode,this.MaterialName,this.MaterialUnitId,this.UnitName,
  this.MaterialUnitPrice,this.MaterialDescription,this.MaterialTaxValue,this.TaxName});

  factory MaterialDetailGridModel.fromJson(Map<dynamic, dynamic> json) {
    return new MaterialDetailGridModel(
      MaterialId: json['MaterialId'],
      MaterialCode: json['MaterialCode'],
      MaterialName: json['MaterialName'],
      MaterialUnitId: json['MaterialUnitId'],
      UnitName: json['UnitName'],
      MaterialUnitPrice: json['MaterialUnitPrice'],
      MaterialDescription: json['MaterialDescription'],
      MaterialTaxValue: json['MaterialTaxValue'],
      TaxName: json['TaxName'],

    );
  }


}