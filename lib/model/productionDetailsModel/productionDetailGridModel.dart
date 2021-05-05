class ProductionDetailGridModel {
  ProductionDetailGridModel({
    this.productionId,
    this.machineId,
    this.machineName,
    this.unitId,
    this.unitName,
    this.inputMaterialId,
    this.inputMaterialName,
    this.inputMaterialQuantity,
    this.outputMaterialCount,
    this.outPutMaterialQuantity,
    this.isDustWastage,
    this.dustQuantity,
    this.wastageQuantity,
  });

  int productionId;
  int machineId;
  String machineName;
  int unitId;
  String unitName;
  int inputMaterialId;
  String inputMaterialName;
  double inputMaterialQuantity;
  int outputMaterialCount;
  double outPutMaterialQuantity;
  int isDustWastage;
  double dustQuantity;
  double wastageQuantity;

  factory ProductionDetailGridModel.fromJson(Map<String, dynamic> json) => ProductionDetailGridModel(
    productionId: json["ProductionId"],
    machineId: json["MachineId"],
    machineName: json["MachineName"],
    unitId: json["UnitId"],
    unitName: json["UnitName"],
    inputMaterialId: json["InputMaterialId"],
    inputMaterialName: json["InputMaterialName"],
    inputMaterialQuantity: json["InputMaterialQuantity"],
    outputMaterialCount: json["OutputMaterialCount"],
    outPutMaterialQuantity: json["OutPutMaterialQuantity"],
    isDustWastage: json["IsDustWastage"],
    dustQuantity: json["DustQuantity"],
    wastageQuantity: json["WastageQuantity"],
  );

  Map<String, dynamic> toJson() => {
    "ProductionId": productionId,
    "MachineId": machineId,
    "MachineName": machineName,
    "UnitId": unitId,
    "UnitName": unitName,
    "InputMaterialId": inputMaterialId,
    "InputMaterialName": inputMaterialName,
    "InputMaterialQuantity": inputMaterialQuantity,
    "OutputMaterialCount": outputMaterialCount,
    "OutPutMaterialQuantity": outPutMaterialQuantity,
    "IsDustWastage": isDustWastage,
    "DustQuantity": dustQuantity,
    "WastageQuantity": wastageQuantity,
  };
}