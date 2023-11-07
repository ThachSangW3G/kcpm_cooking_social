class FollowModel{
  final String id;
  final String idUserOwner;
  final String idUserFollower;

  FollowModel({required this.id, required this.idUserOwner, required this.idUserFollower});


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FollowModel &&
              runtimeType == other.runtimeType &&
              id == other.id &&
              idUserOwner == other.idUserOwner &&
              idUserFollower == other.idUserFollower;

  @override
  int get hashCode => id.hashCode;


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