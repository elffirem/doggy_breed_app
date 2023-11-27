import 'package:equatable/equatable.dart';

class BreedModel extends Equatable {
  final String name;
  final List<String> subBreeds;
  String? imageUrl;

  BreedModel({required this.name, this.subBreeds = const [], this.imageUrl});

    BreedModel.copy(BreedModel breed) 
    : name = breed.name,
      subBreeds = List<String>.from(breed.subBreeds),
      imageUrl = breed.imageUrl;

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      name: json['name'] as String? ?? '', 
      subBreeds: (json['subBreeds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'subBreeds': subBreeds,
      'imageUrl': imageUrl,
    };
  }

  void setImageUrl(String url) {
    imageUrl = url;
  }

  @override
  List<Object?> get props => [name, subBreeds, imageUrl];

  @override
  bool get stringify => true;
}
