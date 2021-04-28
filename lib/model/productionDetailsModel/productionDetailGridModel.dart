class ProductionDetailGridModel{
  int ProductionId;
  int MachineId;
  String MachineName;
  int InputMaterialID;
  String InputMaterialName;
  String InputMaterialQuantity;
  String OutputMaterialCount;
  String OutputMaterialQuantity;
  String IsDustWastage;
  String DustQuantity;
  String WastageQuantity;

  ProductionDetailGridModel({this.ProductionId,this.MachineId,this.MachineName,this.InputMaterialID,this.InputMaterialQuantity,this.InputMaterialName,this.DustQuantity,this.IsDustWastage,this.OutputMaterialCount,this.OutputMaterialQuantity,this.WastageQuantity});


  factory ProductionDetailGridModel.fromJson(Map<dynamic, dynamic> json) {
    return new ProductionDetailGridModel(
      ProductionId: json['ProductionId'],
      MachineId: json['MachineId'],
      MachineName: json['MachineName'],
      InputMaterialID: json['InputMaterialID'],
      InputMaterialName: json['InputMaterialName'],
      InputMaterialQuantity: json['InputMaterialQuantity'],
      OutputMaterialCount: json['OutputMaterialCount'],
      IsDustWastage: json['IsDustWastage'],
      DustQuantity: json['DustQuantity'],
      WastageQuantity: json['WastageQuantity'],

    );
  }


}