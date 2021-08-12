
class ManageUsersGridModel {
  ManageUsersGridModel({
    this.userId,
    this.userName,
    this.userGroupId,
    this.userGroupName,
  });

  int? userId;
  String? userName;
  int? userGroupId;
  String? userGroupName;

  factory ManageUsersGridModel.fromJson(Map<String, dynamic> json) => ManageUsersGridModel(
    userId: json["UserId"],
    userName: json["UserName"],
    userGroupId: json["UserGroupId"],
    userGroupName: json["UserGroupName"],
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "UserName": userName,
    "UserGroupId": userGroupId,
    "UserGroupName": userGroupName,
  };
}
