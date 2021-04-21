class MaterialCategoryModel{
  int MaterialCategoryId;
  String MaterialCategoryName;

  MaterialCategoryModel(
  {this.MaterialCategoryId, this.MaterialCategoryName});

  factory MaterialCategoryModel.fromJson(Map<String,dynamic> json){
    return MaterialCategoryModel(
      MaterialCategoryId: json['MaterialCategoryId'],
      MaterialCategoryName: json['MaterialCategoryName'],
    );
  }

}