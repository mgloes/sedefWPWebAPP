import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sedefwpwebapp/contants.dart';
import 'package:sedefwpwebapp/models/phone_number_model/phone_number_model.dart';
import 'package:sedefwpwebapp/models/response_model/response_model.dart';
import 'package:sedefwpwebapp/models/user_model/user_model.dart';
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
        "username": username,
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
      Uri address = Uri.parse("$envPath/Message?phoneNumber=$phoneNumber&mainPhoneNumber=$mainPhoneNumber");
      var response =
          await http.get(address, headers: getGeneralHeaders(isAuth: true));
      debugPrint("${response.statusCode}");
      debugPrint(response.body);
      return ResponseModel.fromJson(json.decode(response.body)) ;
    } catch (e) {
      return ResponseModel(isSuccess: false,message: "Bir hata oluştu: $e");
    }
  }
    Future<ResponseModel> createCustomerService(String name, String surname) async {
    try {
      Uri address = Uri.parse("$envPath/User");
      var response =
          await http.post(address, headers: getGeneralHeaders(isAuth: true), body: json.encode({
        "name": name,
        "surname": surname
      }));
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
  
  

}
