class MaterialCategoryModel{
  int? MaterialCategoryId;
  String? MaterialCategoryName;

  MaterialCategoryModel(
  {this.MaterialCategoryId, this.MaterialCategoryName});

  factory MaterialCategoryModel.fromJson(Map<String,dynamic> json){
    return MaterialCategoryModel(
      MaterialCategoryId: json['MaterialCategoryId'],
      MaterialCategoryName: json['MaterialCategoryName'],
    );
  }

  Map<String, dynamic> toJson() => {
    "MaterialCategoryId": MaterialCategoryId,
    "MaterialCategoryName": MaterialCategoryName,
  };
  dynamic get(String propertyName) {
    var _mapRep = toJson();
    if (_mapRep.containsKey(propertyName)) {
      return _mapRep[propertyName];
    }
    throw ArgumentError('property not found');
  }
}