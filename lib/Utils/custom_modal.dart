import 'package:doggy_app/Data/app_constant.dart';
import 'package:doggy_app/Models/breed_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomModal extends StatefulWidget {
  final BreedModel breed;
  const CustomModal({super.key, required this.breed});

  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      content: Column(
        children: [
          widget.breed.imageUrl != null
              ? ClipRRect(
                  borderRadius:
                      const BorderRadius.all(Radius.circular(kBorder)),
                  child: Image.network(
                    widget.breed.imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.broken_image));
                    },
                  ),
                )
              : const Center(child: Icon(Icons.image_not_supported)),
             
               _buildTitle("Breed"),
               _buildSubtitle(widget.breed.name),
               _buildTitle("Sub Breeds"),
               //List.generate(widget.breed.subBreeds.length, (index) =>_buildSubtitle(widget.breed.name) ) liste dönecek
               //modalın boyutu ayarlanacak
               //generate butonuna basılınca random köpeği pop-up olarak çıkarak
               //çarpılara basıldığında kapatılabilecek
               //search fonskiyonu düzenlenecek
               //splash screen eklenecek
               //sistemsel özellikler çekilecek


        ],
      ),
    );
  }

  Widget _buildSubtitle(String text) =>  Padding(
    padding: const EdgeInsets.only(top:8.0),
    child: Text(text,style: body.copyWith(color:kBlackColor)),
  );

  Widget _buildTitle(String text) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical:12),
        child: Text(text,style: title3.copyWith(color: kPrimaryColor)),
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
