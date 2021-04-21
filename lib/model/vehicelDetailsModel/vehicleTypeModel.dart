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


}