import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:sedefwpwebapp/utilities/data_utilities.dart';

class ImageHelper {
  static Future<String?> fetchImageAsBase64(String imageUrl) async {
    try {
      if (kIsWeb) {
        // Web için özel çözüm
        return await _fetchImageAsBase64Web(imageUrl);
      } else {
        // Mobil için normal yöntem
        return imageUrl;
      }
    } catch (e) {
      print('Image fetch error: $e');
      return null;
    }
  }

  static Future<String?> _fetchImageAsBase64Web(String imageUrl) async {
    try {
      // XMLHttpRequest ile resmi çek
      final request = html.HttpRequest();
      request.open('GET', imageUrl);
      
      // Headers ekle
      final headers = getGeneralHeaders(isWhatsappFile: true);
      headers.forEach((key, value) {
        request.setRequestHeader(key, value);
      });
      
      request.responseType = 'blob';
      
      final completer = Completer<String?>();
      
      request.onLoad.listen((e) {
        if (request.status == 200) {
          final blob = request.response as html.Blob;
          final reader = html.FileReader();
          
          reader.onLoad.listen((e) {
            final result = reader.result as String;
            completer.complete(result);
          });
          
          reader.onError.listen((e) {
            print('FileReader error: $e');
            completer.complete(null);
          });
          
          reader.readAsDataUrl(blob);
        } else {
          print('HTTP Error: ${request.status}');
          completer.complete(null);
        }
      });
      
      request.onError.listen((e) {
        print('Request error: $e');
        completer.complete(null);
      });
      
      request.send();
      
      return await completer.future;
    } catch (e) {
      print('_fetchImageAsBase64Web error: $e');
      return null;
    }
  }
}

class Completer<T> {
  bool _isCompleted = false;
  T? _value;
  
  Future<T> get future async {
    while (!_isCompleted) {
      await Future.delayed(const Duration(milliseconds: 10));
    }
    return _value!;
  }
  
  void complete(T value) {
    _value = value;
    _isCompleted = true;
  }
}