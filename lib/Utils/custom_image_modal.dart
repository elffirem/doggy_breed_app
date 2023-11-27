import 'package:doggy_app/Data/app_constant.dart';
import 'package:flutter/material.dart';

class CustomImageModal extends StatefulWidget {
  final String? randomImageUrl;
  const CustomImageModal({super.key, this.randomImageUrl});

  @override
  State<CustomImageModal> createState() => _CustomImageModalState();
}

class _CustomImageModalState extends State<CustomImageModal> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor:
          Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 34),
            child: widget.randomImageUrl != null && widget.randomImageUrl != ''
                ? ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(kBorder)),
                    child:
                        Image.network(widget.randomImageUrl!, fit: BoxFit.cover),
                  )
                : const Center(child: Text("No images found")),
          ),
        
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0), 
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 32,
                height: 32,
                
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  color: kWhiteColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2)),
                ),
                child:  const Center(
                  child: Icon(
                    Icons.close,
                    color: kBlackColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
