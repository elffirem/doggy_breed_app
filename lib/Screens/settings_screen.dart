import 'package:doggy_app/Data/app_constant.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  

  @override
  Widget build(BuildContext context) {
    List<Map<String,String>> settings=[
    {"leadingPath":"help","title":"Help"},
    {"leadingPath":"rate","title":"Rate Us"},
    {"leadingPath":"share","title":"Share With Friends"},
    {"leadingPath":"terms","title":"Terms Of Use"},
    {"leadingPath":"privacy","title":"Privacy Policy"},
   
    ];
    return  Scaffold(
      backgroundColor: kSecondarySystemBackgroundGray,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0,vertical: toolbarHeight),
        child: ListView.separated(
          itemCount: settings.length,
          separatorBuilder: (context, index) {
            return const Divider( 
              color: kSystemGray,
            );
          },
         itemBuilder: (context, index) {
           return   _buildListTile(settings[index]);
      
            
            
         },
        ),
      )
    );
  }

  ListTile _buildListTile(var item) {
    String leadingPath=item["leadingPath"];
    String title=item["title"];
    return ListTile(
          leading: SizedBox(height:32 ,width: 32, child: Image.asset("assets/$leadingPath.png")),
            title:  Text(title),
          );
  }
}