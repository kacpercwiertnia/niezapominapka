class ShopItem {
  final int? id;
  final int groupId;
  final String name;

  const ShopItem({this.id, required this.groupId, required this.name});

  factory ShopItem.fromMap(Map<String, dynamic> map){
    return ShopItem(
        id: map['id'] as int,
        groupId: map['group_id'] as int,
        name: map['name'] as String
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'group_id': groupId,
      'name': name
    };
  }

}