class UnitDetailModel{
  int UnitId;
  String UnitName;

  UnitDetailModel({this.UnitId, this.UnitName});


  factory UnitDetailModel.fromJson(Map<String,dynamic> json){
    return UnitDetailModel(
      UnitId: json['UnitId'],
      UnitName: json['UnitName'],
    );
  }

}