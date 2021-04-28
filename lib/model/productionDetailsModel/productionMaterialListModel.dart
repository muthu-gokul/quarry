class ProductionMaterialListModel{
  int materialId;
  String materialName;


  ProductionMaterialListModel({this.materialName,this.materialId});

  factory ProductionMaterialListModel.fromJson(Map<String, dynamic> json) => ProductionMaterialListModel(
    materialId: json["MaterialId"],
    materialName: json["MaterialName"],

  );

  Map<String, dynamic> toJson() => {
    "MaterialId":   materialId,
    "MaterialName": materialName,


};

}