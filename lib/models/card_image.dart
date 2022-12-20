class CardImage {
  final int id;
  final List<String> imageUrl;
  final List<String> imageUrlSmall;

  CardImage({
    required this.id,
    required this.imageUrl,
    required this.imageUrlSmall,
  });

  factory CardImage.fromJson(Map<String, dynamic> json) {
    final imgUrl = List<String>.from(json['image_url']);
    final imgUrlSmall = List<String>.from(json['image_url_small']);

    return CardImage(
      id: json['id'],
      imageUrl: imgUrl,
      imageUrlSmall: imgUrlSmall,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'image_url_small': imageUrlSmall,
    };
  }
}