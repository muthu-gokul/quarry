class UserAccessModel {
 late int actionId;
 late String moduleName;
 late String moduleAction;
 late bool isHasAccess;

  UserAccessModel(
      {required this.actionId, required this.moduleName,required this.moduleAction,required this.isHasAccess});

  UserAccessModel.fromJson(Map<String, dynamic> json) {
    actionId = json['ActionId'];
    moduleName = json['ModuleName'];
    moduleAction = json['ModuleAction'];
    isHasAccess = json['IsHasAccess']==1?true:false;
    //isHasAccess = json['IsHasAccess'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActionId'] = this.actionId;
    data['ModuleName'] = this.moduleName;
    data['ModuleAction'] = this.moduleAction;
    data['IsHasAccess'] = this.isHasAccess;
    return data;
  }
}