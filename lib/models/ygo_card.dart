class YgoCard {
  final int id;
  final String cardName;
  final String cardType;
  final String? attribute;
  final String description;
  final String archetype;
  final int atk;
  final int def;
  final int cardLevel;
  final String race;
  final int linkval;
  final List<String>? linkmarkers;
  final int cardScale;
  final List<String> imageUrl;
  final List<String> imageUrlSmall;

  YgoCard({
    required this.id,
    required this.cardName,
    required this.cardType,
    required this.attribute,
    required this.description,
    required this.archetype,
    required this.atk,
    required this.def,
    required this.cardLevel,
    required this.race,
    required this.linkval,
    required this.linkmarkers,
    required this.cardScale,
    required this.imageUrl,
    required this.imageUrlSmall,
  });

  factory YgoCard.fromJson(Map<String, dynamic> json) {
    final linkmark = json['linkmarkers'] != null ? List<String>.from(json['linkmarkers']) : null;
    final imgUrl = List<String>.from(json['image_url']);
    final imgUrlSmall = List<String>.from(json['image_url_small']);

    return YgoCard(
      id: json['id'],
      cardName: json['card_name'],
      attribute: json['attribute'],
      cardType: json['card_type'],
      description: json['description'],
      archetype: json['archetype'],
      atk: json['atk'],
      def: json['def'],
      cardLevel: json['card_level'],
      race: json['race'],
      linkval: json['linkval'],
      linkmarkers: linkmark,
      cardScale: json['card_scale'],
      imageUrl: imgUrl,
      imageUrlSmall: imgUrlSmall,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'card_name': cardName,
      'card_type': cardType,
      'attribute': attribute,
      'description': description,
      'archetype': archetype,
      'atk': atk,
      'def': def,
      'card_level': cardLevel,
      'race': race,
      'linkval': linkval,
      'linkmarkers': linkmarkers,
      'card_scale': cardScale,
      'image_url': imageUrl,
      'image_url_small': imageUrlSmall
    };
  }

}