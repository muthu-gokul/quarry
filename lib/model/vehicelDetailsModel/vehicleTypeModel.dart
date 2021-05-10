class VehicleTypeModel{
  int VehicleTypeId;
  String VehicleTypeName;


  VehicleTypeModel({this.VehicleTypeId,this.VehicleTypeName});
  factory VehicleTypeModel.fromJson(Map<dynamic, dynamic> json){
    return new VehicleTypeModel(

      VehicleTypeId: json['VehicleTypeId'],
      VehicleTypeName: json['VehicleTypeName'],
    );
  }
  Map<String, dynamic> toJson() => {
    "VehicleTypeId": VehicleTypeId,
    "VehicleTypeName": VehicleTypeName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }

}