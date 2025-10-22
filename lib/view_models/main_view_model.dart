import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sedefwpwebapp/contants.dart';
import 'package:sedefwpwebapp/models/get_all_message_for_main_phones_model/get_all_message_for_main_phones_model.dart';
import 'package:sedefwpwebapp/models/get_all_message_model/get_all_message_model.dart';
import 'package:sedefwpwebapp/models/message_model/message_model.dart';
import 'package:sedefwpwebapp/models/phone_number_model/phone_number_model.dart';
import 'package:sedefwpwebapp/models/response_model/response_model.dart';
import 'package:sedefwpwebapp/models/user_model/user_model.dart';
import 'package:sedefwpwebapp/services/main_service.dart';
import 'package:sedefwpwebapp/utilities/data_utilities.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MainViewModel {
  static final MainViewModel _MainViewModel = MainViewModel._private();
  MainViewModel._private();
  factory MainViewModel() => _MainViewModel;
  
  //Services 
  final MainService _mainService = MainService();
  
  //MAIN Variables
  final loggedUser = StateProvider<UserModel>((ref) => UserModel());
  final phoneNumbers = StateProvider<List<PhoneNumberModel>>((ref) => []);
  final allMessages = StateProvider<List<GetAllMessageForMainPhonesModel>>((ref) => []);
  final messages = StateProvider<List<MessageModel>>((ref) => []);
  final users = StateProvider<List<UserModel>>((ref) => []);
  late WebSocketChannel socket;
  //Colors

  //Functions


  Future<void> connectToSocket(WidgetRef ref, BuildContext context) async {
    try {
    socket = await WebSocketChannel.connect(Uri.parse('wss://sedefwpapi.codeflight.com.tr/ws?token='+loggedUserToken));
      socket.stream.listen((data) {
        print(data);
        MessageModel message;
        try {
          
            message = MessageModel.fromJson(jsonDecode(data));
          inspect(message); // --- IGNORE ---
       
      if(ref.read(messages).where((e) => e.senderPhoneNumber == message.senderPhoneNumber).isNotEmpty){
        ref.read(messages.notifier).state = [...ref.read(messages), message];
      }

        final allMessagesList = ref.read(allMessages);
        // final index =  allMessagesList.indexWhere((element) => element.phoneNumber == (message.isConversation == true ?  message.receiverPhoneNumber == "902163756781" ?  "Özel Mesajlar"  : message.receiverPhoneNumber : message.receiverPhoneNumber));
        inspect(allMessagesList);
        allMessagesList.forEach((element) {
                final currentMessages = List<GetAllMessageModel>.from(element.messages as List<GetAllMessageModel>);
          final messageIndex = currentMessages.indexWhere((msg) => msg.phoneNumber == (message.senderPhoneNumber == "902163756781" ? message.receiverPhoneNumber : message.senderPhoneNumber));
          
          if (messageIndex != -1) {
            // Mevcut mesajı güncelle
            currentMessages[messageIndex] = GetAllMessageModel(
              lastMessage: message.textBody ?? "",
              lastMessageDate: message.createdDate ?? DateTime.now(),
              phoneNumber: (message.senderPhoneNumber == "902163756781" ? message.receiverPhoneNumber : message.senderPhoneNumber) ?? "",
              phoneNumberNameSurname: message.senderNameSurname ?? "",
            );
          } else {
            // Yeni mesaj ekle
            currentMessages.add(GetAllMessageModel(
              lastMessage: message.textBody ?? "",
              lastMessageDate: message.createdDate ?? DateTime.now(),
              phoneNumber: (message.senderPhoneNumber == "902163756781" ? message.receiverPhoneNumber : message.senderPhoneNumber) ?? "",
              phoneNumberNameSurname: message.senderNameSurname ?? "",
            ));
          }

          final updatedAllMessages = List<GetAllMessageForMainPhonesModel>.from(ref.read(allMessages));
          var index = updatedAllMessages.indexWhere((e) => e.phoneNumber == element.phoneNumber);
          updatedAllMessages[index] = updatedAllMessages[index].copyWith(messages: currentMessages);

          ref.read(allMessages.notifier).state = updatedAllMessages;
  
        },);



        
        // if (index != -1) {
        //   // Mevcut phoneNumber için mesaj listesine ekle veya güncelle
          
      
        // } else {
        //   // Yeni phoneNumber için yeni bir kayıt oluştur
        //   ref.read(allMessages.notifier).state = [
        //     ...allMessagesList,
        //     GetAllMessageForMainPhonesModel(
        //       phoneNumber: message.receiverPhoneNumber ?? "",
        //       messages: [
        //         GetAllMessageModel(
        //           lastMessage: message.textBody ?? "",
        //           lastMessageDate: message.createdDate ?? DateTime.now(),
        //           phoneNumber: message.senderPhoneNumber ?? "",
        //           phoneNumberNameSurname: message.senderNameSurname ?? "",
        //         )
        //       ],
        //     ),
        //   ];
        // }

       } catch (e) {
         print(e);
       }
    });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }

  Future<void> sendMedia(WidgetRef ref, BuildContext context, String mainPhoneNumber, String to, XFile mediaFile, String caption, String phoneNumberId) async {
    try {
      ResponseModel res = await _mainService.sendMedia(mainPhoneNumber, to, mediaFile, caption, phoneNumberId);
      print(res);
      if(res.isSuccess ?? false){
        ref.read(messages.notifier).state.add(MessageModel.fromJson(res.data).copyWith(senderPhoneNumber:MessageModel.fromJson(res.data).senderPhoneNumber == "Özel Mesajlar" ?   "902163756781" : MessageModel.fromJson(res.data).senderPhoneNumber!));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
    }
  }

  Future<void> signIn(WidgetRef ref, BuildContext context,String username, String password) async {
    try {
    ResponseModel res =  await _mainService.signIn(username, password);
    if(res.isSuccess ?? false){
      if(res.data != null){
        loggedUserToken = res.message["AccessToken"].toString();
        saveSharedPrefs(4, "accessToken", loggedUserToken);
        ref.read(loggedUser.notifier).state = UserModel.fromJson(res.data);
        // await getListPhoneNumbers(ref, context);
        // await getAllMessages(ref, context);
        context.go("/chat");
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
    }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }
  Future<void> getMyUser(WidgetRef ref, BuildContext context, {bool needToGo = true}) async {
    try {
      ResponseModel res = await _mainService.getMyUser();
      if (res.isSuccess ?? false) {
        if (res.data != null) {
        ref.read(loggedUser.notifier).state = UserModel.fromJson(res.data);
        await getListPhoneNumbers(ref, context);
        await getAllMessages(ref, context);
        needToGo ? context.go("/chat"): null;
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
    }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }

  Future<void> getListPhoneNumbers(WidgetRef ref,BuildContext context) async {
    try {
      ResponseModel res = await _mainService.getAllPhoneNumbers();
      if(res.isSuccess ?? false){
          ref.read(phoneNumbers.notifier).state = List<PhoneNumberModel>.from(res.data.map((e) => PhoneNumberModel.fromJson(e)).toList());
          ref.read(loggedUser).role == "ADMIN" ? null : ref.read(phoneNumbers.notifier).state.insert(0, PhoneNumberModel(phoneNumber: "Özel Mesajlar",phoneNumberId: "835767242948963",status: true, title:"Sizin Konuşmalarınız",id: 1));
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }
  
    Future<void> addPhoneNumber(WidgetRef ref, BuildContext context, PhoneNumberModel phoneNumber) async {
    try {
      ResponseModel res = await _mainService.createPhoneNumber(phoneNumber.phoneNumber ?? "", phoneNumber.title ?? "", phoneNumber.phoneNumberId ?? "");
      if(res.isSuccess ?? false){
        // Yeni liste oluştur ve state'i güncelle
        final currentPhones = ref.read(phoneNumbers);
        final newPhone = PhoneNumberModel.fromJson(res.data);
        ref.read(phoneNumbers.notifier).state = [...currentPhones, newPhone];
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Telefon hattı başarıyla eklendi"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
    }
  }
  Future<void> updatePhoneNumber(WidgetRef ref, BuildContext context, PhoneNumberModel phoneNumber) async {
    try {
      ResponseModel res = await _mainService.updatePhoneNumber(phoneNumber);
      if(res.isSuccess ?? false){
        // Yeni liste oluştur ve güncelle
        final currentPhones = ref.read(phoneNumbers);
        final updatedPhone = PhoneNumberModel.fromJson(res.data);
        final newPhones = currentPhones.map((phone) {
          if (phone.id == phoneNumber.id) {
            return updatedPhone;
          }
          return phone;
        }).toList();
        ref.read(phoneNumbers.notifier).state = newPhones;
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Telefon hattı başarıyla güncellendi"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
    }
  }
  Future<void> updateConversationStatus(WidgetRef ref, BuildContext context, String phoneNumber, bool status) async {
    try {
      ResponseModel res = await _mainService.updateStatusConversation(phoneNumber,status);
      if(res.isSuccess ?? false){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Konuşma durumu başarıyla güncellendi"),
          backgroundColor: Colors.green,
        ));
        await getAllMessages(ref, context);
       
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
    }
  }
  Future<void> deletePhoneNumber(WidgetRef ref, BuildContext context, int phoneNumberId) async {
    try {
      ResponseModel res = await _mainService.deletePhoneNumber(phoneNumberId);
      if(res.isSuccess ?? false){
        // Yeni liste oluştur (silme işlemi)
        final currentPhones = ref.read(phoneNumbers);
        final newPhones = currentPhones.where((phone) => phone.id != phoneNumberId).toList();
        ref.read(phoneNumbers.notifier).state = newPhones;
        
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Telefon hattı başarıyla silindi"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
    }
  }

  Future<void> togglePhoneStatus(WidgetRef ref, BuildContext context, String phoneNumberId) async {
    try {
      // Önce mevcut hatı bul
      final currentPhones = ref.read(phoneNumbers);
      final phoneIndex = currentPhones.indexWhere((phone) => phone.phoneNumberId == phoneNumberId);
      
      if (phoneIndex == -1) return;
      
      final currentPhone = currentPhones[phoneIndex];
      final updatedPhone = currentPhone.copyWith(
        status: !(currentPhone.status ?? false),
        updatedDate: DateTime.now(),
      );
      
      // API çağrısını yap
      ResponseModel res = await _mainService.updatePhoneNumber(updatedPhone);
      if(res.isSuccess ?? false){
        // State'i güncelle
        final newPhones = currentPhones.map((phone) {
          if (phone.phoneNumberId == phoneNumberId) {
            return PhoneNumberModel.fromJson(res.data);
          }
          return phone;
        }).toList();
        ref.read(phoneNumbers.notifier).state = newPhones;
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Hat durumu ${updatedPhone.status! ? 'aktif' : 'pasif'} olarak güncellendi"),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Bir hata oluştu")));
    }
  }
  
  Future<void> getAllMessages(WidgetRef ref, BuildContext context) async {
    try {
      ResponseModel res = await _mainService.GetAllMessages();
      if(res.isSuccess ?? false){
          ref.read(allMessages.notifier).state = List<GetAllMessageForMainPhonesModel>.from(res.data.map((e) => GetAllMessageForMainPhonesModel.fromJson(e)).toList());
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }
  Future<void> GetMessagesByPhoneNumber(WidgetRef ref,BuildContext context,String phoneNumber, String mainPhoneNumber) async {
    try {
      ResponseModel res = await _mainService.GetMessage(phoneNumber, mainPhoneNumber);
      if(res.isSuccess ?? false){
          ref.read(messages.notifier).state = List<MessageModel>.from(res.data.map((e) => MessageModel.fromJson(e)).toList());
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }

   Future<void> createCustomerService(WidgetRef ref,BuildContext context,String name, String surname, String email, String password, String description) async {
    try {
      ResponseModel res = await _mainService.createCustomerService(name, surname, email, password, description);
      if(res.isSuccess ?? false){
        final newUser = res.data != null ? UserModel.fromJson(res.data) : UserModel();
        final currentUsers = ref.read(users);
        ref.read(users.notifier).state = [...currentUsers, newUser];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kullanıcı başarıyla eklendi")));
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }
   Future<void> updateCustomerService(WidgetRef ref,BuildContext context,int userId,String name, String surname, String email, String password,bool status,String phoneNumberList, String description) async {
    try {
      ResponseModel res = await _mainService.updateCustomerService(userId, name, surname, email, password,status, phoneNumberList, description);
      if(res.isSuccess ?? false){
          final currentUsers = ref.read(users);
        final updatedUser = UserModel.fromJson(res.data);
        final newUsers = currentUsers.map((user) {
          if (user.id == userId) {
            return updatedUser;
          }
          return user;
        }).toList();
        ref.read(users.notifier).state = newUsers;
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kullanıcı başarıyla güncellendi")));
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }
  Future<void> deleteCustomerService(WidgetRef ref,BuildContext context,int userId) async {
    try {
      ResponseModel res = await _mainService.deleteCustomerService(userId);
      if(res.isSuccess ?? false){
        final currentUsers = ref.read(users);
        final newUsers = currentUsers.where((user) => user.id != userId).toList();
        ref.read(users.notifier).state = newUsers;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kullanıcı başarıyla silindi")));
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }
     Future<void> getListUser(WidgetRef ref,BuildContext context) async {
    try {
      ResponseModel res = await _mainService.getListUser();
      if(res.isSuccess ?? false){
          ref.read(users.notifier).state = (res.data as List).map((e) => UserModel.fromJson(e)).toList();
      }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res.message ?? "Bir hata oluştu")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Bir hata oluştu")));
    }
  }

  Future<void> toggleUserStatus(WidgetRef ref, BuildContext context, int userId, bool currentStatus) async {
    try {
      // Kullanıcının mevcut verilerini al
      final currentUsers = ref.read(users);
      final user = currentUsers.firstWhere((u) => u.id == userId);
      
      // Status'u tersine çevir ve güncelle
      await updateCustomerService(
        ref, 
        context, 
        userId,
        user.name ?? '',
        user.surname ?? '',
        user.emailAddress ?? '',
        user.password ?? '',
        !currentStatus, // Status'u tersine çevir
        user.phoneNumberList ?? '',
        user.description ?? '', // Description ekle
      );
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Kullanıcı başarıyla güncellendi")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Status güncellenirken hata oluştu")));
    }
  }

}

