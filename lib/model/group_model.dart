

class GroupModel {
  String? groupId;
  String? groupAdminId;
  List<String>? usersId;
  String? groupName;

  GroupModel({
    this.groupId,
    required this.groupAdminId,
    required this.usersId,
    required this.groupName,
});


  GroupModel.fromJson(Map<String, dynamic> json){
    groupAdminId = json['groupAdminId'];
    usersId = (json['usersId'] as List<dynamic>).map((id) => id.toString()).toList();
    groupId = json['groupId'];
    groupName = json['groupName'];
  }

  Map<String, dynamic> toMap() => {
    'groupId': groupId,
    'groupAdminId': groupAdminId,
    'usersId': usersId,
    'groupName': groupName,
  };
}