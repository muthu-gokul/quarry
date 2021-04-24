
class ManageUserGroupModel {
  ManageUserGroupModel({
    this.userGroupId,
    this.userGroupName,
  });

  int userGroupId;
  String userGroupName;

  factory ManageUserGroupModel.fromJson(Map<String, dynamic> json) => ManageUserGroupModel(
    userGroupId: json["UserGroupId"],
    userGroupName: json["UserGroupName"],
  );

  Map<String, dynamic> toJson() => {
    "UserGroupId": userGroupId,
    "UserGroupName": userGroupName,
  };
}