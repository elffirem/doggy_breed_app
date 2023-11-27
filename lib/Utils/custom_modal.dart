import 'dart:convert';

import 'package:doggy_app/Data/app_constant.dart';
import 'package:doggy_app/Models/breed_model.dart';
import 'package:doggy_app/Utils/custom_image_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;


class CustomModal extends StatefulWidget {
  final BreedModel breed;
  const CustomModal({super.key, required this.breed});

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  String randomImageUrl='';
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height-98-56, //appbar+toolbar heights
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  widget.breed.imageUrl != null
                      ? ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(kBorder)),
                          child: Image.network(
                            widget.breed.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                  child: Icon(Icons.broken_image));
                            },
                          ),
                        )
                      : const Center(child: Icon(Icons.image_not_supported)),

                  _buildTitle("Breed"),
                  _buildSubtitle(widget.breed.name),
                  widget.breed.subBreeds.isNotEmpty
                      ? _buildTitle("Sub Breeds")
                      : const SizedBox(),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return _buildSubtitle(widget.breed.subBreeds[index]);
                      },
                      itemCount: widget.breed.subBreeds.length,
                    ),
                  ),
                  //search fonskiyonu düzenlenecek
                  //sistemsel özellikler çekilecek
                  //yazı tipi eklenecek
                ],
              ),
            ),
            Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 12,
                    top: 12,
                  ),
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const CircleAvatar(
                          backgroundColor: kWhiteColor,
                          child: Icon(Icons.close, color: kBlackColor))),
                )), Align( 
                  alignment:Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: MaterialButton(
                        color: kLightPrimaryColor,
                        minWidth: 312,
                        height: 56,
                        textColor: kWhiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Text("Generate"),
                        onPressed: () async{
                          await  fetchRandomImage();
                        },
                      ),
                    ),
                )
          ],
        ),
      ),
    );
  }
     Future<void> _showImage(String randomImageUrl) async {
    await showDialog(
        context: context,
        builder: (context) => CustomImageModal(randomImageUrl: randomImageUrl));
  } 

Future<void> fetchRandomImage() async {
  final breed = widget.breed.name;
  final url = Uri.parse('https://dog.ceo/api/breed/$breed/images/random');
  try {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final imageUrl = data['message'];
      if (await isValidImageUrl(imageUrl)) {
        setState(() {
          randomImageUrl = imageUrl;
        });
        _showImage(randomImageUrl);
      } else {
        handleInvalidImageUrl();
      }
    } else {
      handleInvalidImageUrl();
    }
  } catch (e) {
    debugPrint('Error fetching random image: $e');
    handleInvalidImageUrl();
  }
}

Future<bool> isValidImageUrl(String url) async {
  final response = await http.head(Uri.parse(url));
  return response.statusCode == 200;
}

void handleInvalidImageUrl() {
  // Kullanıcıya bir hata mesajı gösterin veya alternatif bir resim yükleyin
  debugPrint('Invalid image URL');
  // Örneğin: setState(() => randomImageUrl = 'default_image_url');
}


  Widget _buildSubtitle(String text) => Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Text(
          text,
          style: body.copyWith(color: kBlackColor),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildTitle(String text) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(text, style: title3.copyWith(color: kPrimaryColor)),
          ),
          const SizedBox(
            width: 280,
            child: Divider(
              color: kSystemGray,
              height: 2,
            ),
          )
        ],
      );
}
