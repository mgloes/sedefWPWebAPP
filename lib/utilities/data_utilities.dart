import 'dart:math';

import 'package:sedefwpwebapp/contants.dart';
import 'package:shared_preferences/shared_preferences.dart';


sharedPrefsClear(String key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(key);
}


saveSharedPrefs(int type, var key, var value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (type == 1) {
    //Bool
    await prefs.setBool(key, value);
  } else if (type == 2) {
    //Double
    await prefs.setDouble(key, value);
  } else if (type == 3) {
    //Int
    await prefs.setInt(key, value);
  } else if (type == 4) {
    //String
    await prefs.setString(key, value);
  } else if (type == 5) {
    //String List
    await prefs.setStringList(key, value);
  }
}

getSharedPrefs(int type, var key) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (type == 1) {
    //Bool
    return prefs.getBool(key);
  } else if (type == 2) {
    //Double
    return prefs.getDouble(key);
  } else if (type == 3) {
    //Int
    return prefs.getInt(key);
  } else if (type == 4) {
    //String
    return prefs.getString(key);
  } else if (type == 5) {
    //String List
    return prefs.getStringList(key);
  }
}

  int createRandomNumber() {
    Random random = Random();
    int min = 1000;
    int max = 9999;
    return min + random.nextInt(max - min + 1);
  }

  int createRandomNumberSecond() {
    Random random = Random();
    int min = 100;
    int max = 999;
    return min + random.nextInt(max - min + 1);
  }
String turkishCharacterToEnglish(String text)
{
   List<String> turkishChars = ['ı', 'ğ', 'İ', 'Ğ', 'ç', 'Ç', 'ş', 'Ş', 'ö', 'Ö', 'ü', 'Ü'];
    List<String> englishChars = ['i', 'g', 'I', 'G', 'c', 'C', 's', 'S', 'o', 'O', 'u', 'U'];
    
    // Match chars
    for (int i = 0; i < turkishChars.length; i++)
        text = text.replaceAll(turkishChars[i], englishChars[i]);
    return text;
}


// String generateToken() {
//   const String secretKey = "E45TYuh678eMjOpgSd34567t90tGbHkdS";

//   // Rastgele 8 bayt (16 karakter hex) salt oluştur
//   final Random random = Random.secure();
//   final List<int> saltBytes = List<int>.generate(8, (_) => random.nextInt(256));
//   final String randomSalt = base16Encode(saltBytes);

//   // HMAC-SHA256 ile salt ve secret key'i birleştirerek hash oluştur
//   final Hmac hmacSha256 = Hmac(sha256, utf8.encode(randomSalt));
//   final List<int> maskedKey = hmacSha256.convert(utf8.encode(secretKey)).bytes;

//   // Salt ve hash’i birleştir ve Base64 ile encode et
//   final List<int> combined = [...utf8.encode(randomSalt), ...maskedKey];
//   return base64Encode(combined);
// }

// Helper function: Hex encoding
String base16Encode(List<int> bytes) {
  return bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
}

// bool validateToken(String token, String secretKey) {
//   try {
//     // Base64 decode işlemi
//     final List<int> decodedBytes = base64Decode(token);
//     if (decodedBytes.length < 40) {
//       return false; // Geçersiz formatta token
//     }

//     // İlk 16 bayt salt olarak alınır
//     final String randomSalt = utf8.decode(decodedBytes.sublist(0, 16));

//     // Beklenen masked key oluşturulur
//     final Hmac hmacSha256 = Hmac(sha256, utf8.encode(randomSalt));
//     final List<int> expectedMaskedKey = hmacSha256.convert(utf8.encode(secretKey)).bytes;

//     // Gelen token içindeki masked key ile karşılaştırılır
//     final List<int> receivedMaskedKey = decodedBytes.sublist(16);
//     return listEquals(expectedMaskedKey, receivedMaskedKey);
//   } catch (e) {
//     return false; // Base64 decoding hatası veya başka bir hata olursa false döndür
//   }
// }

// Helper function: List<int> karşılaştırması
bool listEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

Map<String, String> getGeneralHeaders(
    {bool isAuth = false, bool isFile = false, bool isWhatsappFile = false}) {
  Map<String, String> headers = {};
  if (isFile) {
    headers.addAll({"Content-Type": "multipart/form-data"});
  } else {
    headers.addAll({"Content-Type": "application/json"});
  }
  if (isAuth) {
     headers.addAll({'Authorization': 'Bearer $loggedUserToken'});
  }
  if (isWhatsappFile) {
     headers.addAll({'Authorization': 'Bearer $wpAccessToken'});
  }
  
  return headers;
}
