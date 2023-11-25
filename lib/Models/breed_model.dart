import 'package:equatable/equatable.dart';

class BreedModel extends Equatable {
  final String name; 
  final List<String> subBreeds; 
  String? imageUrl; 

  BreedModel({required this.name, this.subBreeds = const [], this.imageUrl});


  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      name: json['name'],
      subBreeds: List<String>.from(json['subBreeds'] ?? []),
      imageUrl: json['imageUrl'],
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
