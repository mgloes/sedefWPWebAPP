import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sedefwpwebapp/contants.dart';

startProgress(BuildContext context) {
  try {
  final progress = ProgressHUD.of(context);
  progress?.show();
  } catch (e) {
      return;
  }
  
}

stopProgress(BuildContext context) {
  try {
        final progress = ProgressHUD.of(context);
  progress?.dismiss();
  } catch (e) {
    return;
  }

}


Future<String> networkImageconvertToBase64Image(String url) async {
  final response = await NetworkAssetBundle(Uri.parse(url)).load(url);
  final bytes = response.buffer.asUint8List();
  final base64Str = base64Encode(bytes);
  return base64Str;
}



// Future<ImageProvider> getOfflineImage(String url) async {
//   try {
//     // önce internetten yüklemeyi dene
//     return NetworkImage(url);
//   } catch (_) {
//     // internet yoksa localden getir
//     final prefs = await SharedPreferences.getInstance();
//     final base64Str = prefs.getString("offline_image");
//     if (base64Str != null) {
//       Uint8List bytes = base64Decode(base64Str);
//       return MemoryImage(bytes);
//     } else {
//       throw Exception("Offline resim bulunamadı");
//     }
//   }
// }



customProgressHUD(BuildContext? context,WidgetRef ref, dynamic page, {bool hasText = false}) {
  return ProgressHUD(
    
    borderColor: Colors.white,
    indicatorWidget:
          Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(height: 40,width: 40,
                  child: CircularProgressIndicator(
                    color: mainColor
                  ),
                ),
            
              ],
            ),
          ),
    backgroundColor: Colors.black.withOpacity(0.4),

    child: page,
  );
}

Image imageFromBase64String(String base64String,double width) {
  return Image.memory(base64Decode(base64String),width:width,);
}

// String getIconPath(int i){
// return i == 1 ? menu1ICON: i == 2 ? menu2ICON :  i == 3? menu3ICON :menu4ICON;
// }

// NumberFormat priceFormat(int n){
//   NumberFormat priceFormat;
//   if(n == 0){
//   priceFormat = NumberFormat("#,##0", "tr_TR");
//   }else if (n == 1){
//   priceFormat = NumberFormat("#,##0.0", "tr_TR");
//   }else if (n == 2){
//   priceFormat = NumberFormat("#,##0.00", "tr_TR");
//   }else if (n == 3){
//   priceFormat = NumberFormat("#,##0.000", "tr_TR");
//   }else if (n == 4){
//   priceFormat = NumberFormat("#,##0.0000", "tr_TR");
//   }else if (n == 5){
//   priceFormat = NumberFormat("#,##0.00000", "tr_TR");
//   }else{
//   priceFormat = NumberFormat("#,##0.0000", "tr_TR");
//   }
//   return priceFormat ;
// }




