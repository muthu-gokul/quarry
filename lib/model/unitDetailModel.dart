class UnitDetailModel{
  int? UnitId;
  String? UnitName;

  UnitDetailModel({this.UnitId, this.UnitName});


  factory UnitDetailModel.fromJson(Map<String,dynamic> json){
    return UnitDetailModel(
      UnitId: json['UnitId'],
      UnitName: json['UnitName'],
    );
  }
  Map<String, dynamic> toJson() => {
    "UnitId": UnitId,
    "UnitName": UnitName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}