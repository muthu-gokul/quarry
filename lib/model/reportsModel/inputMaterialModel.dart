class InputMaterialModel {
  InputMaterialModel({
    this.inputMaterialId,
    this.inputMaterialName,
    this.isActive,
  });

  int inputMaterialId;
  String inputMaterialName;
  bool isActive;

  factory InputMaterialModel.fromJson(Map<String, dynamic> json) => InputMaterialModel(
    inputMaterialId: json["InputMaterialId"],
    inputMaterialName: json["InputMaterialName"],
    isActive: true,
  );

  Map<String, dynamic> toGridJson() => {
    "InputMaterialId": inputMaterialId,
    "InputMaterialName": inputMaterialName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toGridJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}