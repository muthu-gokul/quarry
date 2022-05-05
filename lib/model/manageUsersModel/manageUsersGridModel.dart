
class ManageUsersGridModel {
  ManageUsersGridModel({
    this.userId,
    this.userName,
    this.userGroupId,
    this.userGroupName,
    required this.userImage,
  });

  int? userId;
  String? userName;
  int? userGroupId;
  String? userGroupName;
  String userImage;

  factory ManageUsersGridModel.fromJson(Map<String, dynamic> json) => ManageUsersGridModel(
    userId: json["UserId"],
    userName: json["UserName"],
    userGroupId: json["UserGroupId"],
    userGroupName: json["UserGroupName"],
    userImage: json["UserImage"]??"",
  );

  Map<String, dynamic> toJson() => {
    "UserId": userId,
    "UserName": userName,
    "UserGroupId": userGroupId,
    "UserGroupName": userGroupName,
    "UserImage": userImage,
  };
}
