import 'package:intl/intl.dart';

class ProductionReportGridModel {
  ProductionReportGridModel({
    this.productionId,
    this.plantId,
    this.plantName,
    this.productionDate,
    this.machineId,
    this.machineName,
    this.unitId,
    this.inputMaterialId,
    this.inputMaterialName,
    this.showInputMaterialQuantity,
    this.inputMaterialQuantity,
    this.showTotalOutputMaterialQuantity,
    this.totalOutputMaterialQuantity,
    this.totalOutputMaterial,
    this.outputMaterialId,
    this.outputMaterialName,
    this.showOutputMaterialQuantity,
    this.outputMaterialQuantity,
  });

  int productionId;
  int plantId;
  String plantName;
  DateTime productionDate;
  int machineId;
  String machineName;
  int unitId;
  int inputMaterialId;
  String inputMaterialName;
  String showInputMaterialQuantity;
  double inputMaterialQuantity;
  String showTotalOutputMaterialQuantity;
  double totalOutputMaterialQuantity;
  int totalOutputMaterial;
  int outputMaterialId;
  String outputMaterialName;
  String showOutputMaterialQuantity;
  double outputMaterialQuantity;

  factory ProductionReportGridModel.fromJson(Map<String, dynamic> json) => ProductionReportGridModel(
    productionId: json["ProductionId"],
    plantId: json["PlantId"],
    plantName: json["PlantName"],
    productionDate: DateTime.parse(json["ProductionDate"]),
    machineId: json["MachineId"],
    machineName: json["MachineName"],
    unitId: json["UnitId"],
    inputMaterialId: json["InputMaterialId"],
    inputMaterialName: json["InputMaterialName"],
    showInputMaterialQuantity: json["ShowInputMaterialQuantity"],
    inputMaterialQuantity: json["InputMaterialQuantity"],
    showTotalOutputMaterialQuantity: json["ShowTotalOutputMaterialQuantity"],
    totalOutputMaterialQuantity: json["TotalOutputMaterialQuantity"],
    totalOutputMaterial: json["TotalOutputMaterial"],
    outputMaterialId: json["OutputMaterialId"],
    outputMaterialName: json["OutputMaterialName"],
    showOutputMaterialQuantity: json["ShowOutputMaterialQuantity"],
    outputMaterialQuantity: json["OutputMaterialQuantity"],
  );

  Map<String, dynamic> toGridJson() => {
    "Date": productionDate!=null?DateFormat("dd-MM-yyyy").format(productionDate):" ",
    "Machine Name": machineName,
    "Input Material Name": inputMaterialName,
    "Input Material Qty": showInputMaterialQuantity,
    "Total Output Material": totalOutputMaterial,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}
