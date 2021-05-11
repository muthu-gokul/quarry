class OutputMaterialModel {
  OutputMaterialModel({
    this.OutputMaterialId,
    this.OutputMaterialName,
    this.isActive,
  });

  int OutputMaterialId;
  String OutputMaterialName;
  bool isActive;

  factory OutputMaterialModel.fromJson(Map<String, dynamic> json) => OutputMaterialModel(
    OutputMaterialId: json["OutputMaterialId"],
    OutputMaterialName: json["OutputMaterialName"],
    isActive: true,
  );

  Map<String, dynamic> toGridJson() => {
    "OutputMaterialId": OutputMaterialId,
    "OutputMaterialName": OutputMaterialName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}