import 'dart:convert';

import 'package:doggy_app/Models/breed_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

part 'breed_event.dart';
part 'breed_state.dart';

class BreedBloc extends Bloc<BreedEvent, BreedState> {
  BreedBloc() : super(BreedInitial()) {
    on<FetchBreeds>(_onFetchBreeds);
  }

  void _onFetchBreeds(FetchBreeds event, Emitter<BreedState> emit) async {
    emit(BreedLoading());
    try {
      var breedsResponse =
          await http.get(Uri.parse("https://dog.ceo/api/breeds/list/all"));
      var breedsData = jsonDecode(breedsResponse.body);
      var breeds = breedsData["message"] as Map<String, dynamic>;

      List<BreedModel> breedModels = [];
      for (var breed in breeds.keys) {
         List<String> subBreeds = List<String>.from(breeds[breed]);
        String imageUrl = '';

        http.Response imageUrlResponse = await http
            .get(Uri.parse("https://dog.ceo/api/breed/$breed/images"));

        if (imageUrlResponse.statusCode == 200) {
          var imageUrlData = jsonDecode(imageUrlResponse.body);

          List<String> imageUrlList = imageUrlData["message"].cast<String>();

          final String validImageUrl = await _getValidImageUrl(imageUrlList);

          imageUrl = validImageUrl;
        } else {
          debugPrint("${imageUrlResponse.statusCode}: imageUrlResponse:"
              " ${imageUrlResponse.bodyBytes}}");
        }

        /// If the imageUrl is not empty, add it to the list
        if (imageUrl.isNotEmpty) {
          breedModels.add(BreedModel(name: breed, imageUrl: imageUrl, subBreeds: subBreeds));
        }
      }

      emit(BreedLoaded(breedModels));
    } catch (e) {
      emit(BreedError(e.toString()));
    }
  }

  /// Returns an imageUrl from the given list
  /// if it is valid, otherwise returns empty string
  Future<String> _getValidImageUrl(List<String> imageUrlList) async {
    /// Keeps trying until a valid image is found and
    /// breaks the loop if it is found
    /// or when the last element of the list is reached.
    try {
      /// Default value of [isValid] is false
      String currentImageUrl = '';

      for (String imageUrl in imageUrlList) {
        http.Response imageResponse = await http.head(Uri.parse(imageUrl));
        if (imageResponse.statusCode == 200) {
          currentImageUrl = imageUrl;
          break;
        }
      }

      /// Return the image
      ///
      /// Note: it can be empty string if no valid image is found
      return currentImageUrl;
    } catch (e) {
      /// If an error occurs, return empty string
      return '';
    }
  }
}