import 'dart:convert';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:sedefwpwebapp/contants.dart';
import 'package:sedefwpwebapp/models/phone_number_model/phone_number_model.dart';
import 'package:sedefwpwebapp/models/response_model/response_model.dart';
import 'package:sedefwpwebapp/utilities/data_utilities.dart';

class MainService {
  MainService._private();

  static final MainService _instance = MainService._private();
  factory MainService() {
    return _instance;
  }

  Future<ResponseModel> signIn(
      String username, String password) async {
    try {
      Uri address = Uri.parse("$envPath/Auth/signIn");
      var response =
          await http.post(address, headers: getGeneralHeaders(), body: json.encode({
        "emailAddress": username,
        "password": password
      }));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  
  Future<ResponseModel> createPhoneNumber(
      String phoneNumber, String title, String phoneNumberId) async {
    try {
      Uri address = Uri.parse("$envPath/PhoneNumber");
      var response =
          await http.post(address, headers: getGeneralHeaders(isAuth: true), body: json.encode({
        "phoneNumber": phoneNumber,
        "phoneNumberId": phoneNumberId,
        "title": title
      }));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
   Future<ResponseModel> sendMedia(
      String mainPhoneNumber, String to, XFile mediaFile, String caption, String phoneNumberId) async {
    try {
      Uri address = Uri.parse("$envPath/Message/SendMedia");
      var request = http.MultipartRequest('POST', address);
      request.headers.addAll(getGeneralHeaders(isAuth: true,isFile: true));
      request.fields['senderPhoneNumber'] = mainPhoneNumber;
      request.fields['To'] = to;
      request.fields['Caption'] = caption;
      request.fields['PhoneNumberId'] = phoneNumberId;
      
        final bytes = await mediaFile.readAsBytes();
        final contentType = _getContentType(mediaFile.name);
        request.files.add(http.MultipartFile.fromBytes(
          'File',
          bytes,
          filename: mediaFile.name,
          contentType: MediaType.parse(contentType),
        ));
      var response = await request.send();
      print("Response Code: "+ response.statusCode.toString());
      return ResponseModel.fromJson(json.decode(await response.stream.bytesToString()));
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  
    Future<ResponseModel> updatePhoneNumber(
      PhoneNumberModel phoneNumber) async {
    try {
      Uri address = Uri.parse("$envPath/PhoneNumber");
      var response =
          await http.put(address, headers: getGeneralHeaders(isAuth: true), body: json.encode(phoneNumber.toJson()));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
   Future<ResponseModel> updateStatusConversation(
      String phoneNumber, bool status) async {
    try {
      Uri address = Uri.parse("$envPath/Conversation/updateStatusConversation?phoneNumber=$phoneNumber&status=$status");
      var response =
          await http.put(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  
   Future<ResponseModel> updateConversation(int conversationId,
       bool status) async {
    try {
      Uri address = Uri.parse("$envPath/Conversation");
      var response =
          await http.put(address, headers: getGeneralHeaders(isAuth: true), body: json.encode({
        "id": conversationId,
        "conversationEndDate": DateTime.now().toIso8601String(),
        "status": status,
      }));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }

   Future<ResponseModel> getSettings() async {
    try {
      Uri address = Uri.parse("$envPath/Settings");
      var response =
          await http.get(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
    Future<ResponseModel> updateSettings(bool status) async {
    try {
      Uri address = Uri.parse("$envPath/Settings");
      var response =
          await http.put(address, headers: getGeneralHeaders(isAuth: true), body: json.encode({
       "id" : 1,
        "customerSelection": status,
      }));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  Future<ResponseModel> deletePhoneNumber(
      int phoneNumberId) async {
    try {
      Uri address = Uri.parse("$envPath/PhoneNumber?phoneNumberId=$phoneNumberId");
      var response =
          await http.delete(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
   Future<ResponseModel> getAllPhoneNumbers() async {
    try {
      Uri address = Uri.parse("$envPath/PhoneNumber");
      var response =
          await http.get(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  Future<ResponseModel> GetAllMessages() async {
    try {
      Uri address = Uri.parse("$envPath/Message/GetAllMessages");
      var response =
          await http.get(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  Future<ResponseModel> GetMessage(String phoneNumber, String mainPhoneNumber) async {
    try {
      Uri address;
      if(mainPhoneNumber == "Özel Mesajlar"){
        address = Uri.parse("$envPath/Message?phoneNumber=$phoneNumber&mainPhoneNumber=$mainPhoneNumber&conversationId=0");
      }else{
        address = Uri.parse("$envPath/Message?phoneNumber=$phoneNumber&mainPhoneNumber=$mainPhoneNumber");
      }
      
      var response =
          await http.get(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
    Future<ResponseModel> createCustomerService(String name, String surname,String email,String password, String description) async {
    try {
      Uri address = Uri.parse("$envPath/User/createCustomerService");
      var response =
          await http.post(address, headers: getGeneralHeaders(isAuth: true), body: json.encode({
        "name": name,
        "surname": surname,
        "emailAddress": email,
        "password": password,
        "description": description
      }));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
   Future<ResponseModel> updateCustomerService(int userId,String name, String surname,String email,String password,bool status, String phoneNumberList, String description) async {
    try {
      Uri address = Uri.parse("$envPath/User");
      var response =
          await http.put(address, headers: getGeneralHeaders(isAuth: true), body: json.encode({
        "id": userId,
        "name": name,
        "surname": surname,
        "emailAddress": email,
        "password": password,
        "phoneNumberList": phoneNumberList,
        "status": status,
        "description": description,
      }));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  Future<ResponseModel> deleteCustomerService(int userId) async {
    try {
      Uri address = Uri.parse("$envPath/User?customerId=$userId");
      var response =
          await http.delete(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
   Future<ResponseModel> getListUser() async {
    try {
      Uri address = Uri.parse("$envPath/User/GetAllUsers");
      var response =
          await http.get(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
     Future<ResponseModel> getListConversations() async {
    try {
      Uri address = Uri.parse("$envPath/Conversation/getListConversation");
      var response =
          await http.get(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  Future<ResponseModel> getMyUser() async {
    try {
      Uri address = Uri.parse("$envPath/User");
      var response =
          await http.get(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
  
  String _getContentType(String filename) {
    final extension = filename.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'xls':
        return 'application/vnd.ms-excel';
      case 'xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'ppt':
        return 'application/vnd.ms-powerpoint';
      case 'pptx':
        return 'application/vnd.openxmlformats-officedocument.presentationml.presentation';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'ogg':
        return 'audio/ogg';
      case 'mp4':
        return 'video/mp4';
      case 'avi':
        return 'video/avi';
      case 'mov':
        return 'video/quicktime';
      case 'txt':
        return 'text/plain';
      case 'csv':
        return 'text/csv';
      case 'zip':
        return 'application/zip';
      case 'rar':
        return 'application/x-rar-compressed';
      case '7z':
        return 'application/x-7z-compressed';
      default:
        return 'application/octet-stream';
    }
  }


}