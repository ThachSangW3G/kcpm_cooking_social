class FollowModel{
  final String id;
  final String idUserOwner;
  final String idUserFollower;

  FollowModel({required this.id, required this.idUserOwner, required this.idUserFollower});

  factory FollowModel.fromJson(Map<String, dynamic> json){
    return FollowModel(
        id: json['id'],
        idUserOwner: json['idUserOwner'],
        idUserFollower: json['idUserFollower']
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'idUserOwner': idUserOwner,
      'idUserFollower': idUserFollower
    };
  }

}