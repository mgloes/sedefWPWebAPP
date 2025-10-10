// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sedefwpwebapp/view_models/main_view_model.dart';
// import '../models/models.dart';
// import '../contants.dart';

// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   final _phoneController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _editPhoneController = TextEditingController();
//   final _editNameController = TextEditingController();
//   final MainViewModel _mainViewModel = MainViewModel();
//   // Mock user data
//   Map<String, String> userInfo = {
//     'name': 'Müşteri Hizmetleri',
//     'email': ref.read(_mainViewModel.loggedUser).username ?? "",
//     'phone': '+90 555 123 4567',
//     'role': 'Sistem Yöneticisi',
//     'lastLogin': '9 Ekim 2025, 14:30',
//   };

//   // Mock phone numbers
//   // List<PhoneNumber> phoneNumbers = [
//   //   PhoneNumber(
//   //     id: '1',
//   //     number: '+90 555 123 4567',
//   //     displayName: 'İş Hattı',
//   //     isActive: true,
//   //     lastActivity: DateTime.now(),
//   //   ),
//   //   PhoneNumber(
//   //     id: '2',
//   //     number: '+90 555 987 6543',
//   //     displayName: 'Kişisel Hat',
//   //     isActive: false,
//   //     lastActivity: DateTime.now().subtract(const Duration(minutes: 30)),
//   //   ),
//   //   PhoneNumber(
//   //     id: '3',
//   //     number: '+90 555 555 5555',
//   //     displayName: 'Destek Hattı',
//   //     isActive: true,
//   //     lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
//   //   ),
//   // ];

//   @override
//   void dispose() {
//     _phoneController.dispose();
//     _nameController.dispose();
//     _editPhoneController.dispose();
//     _editNameController.dispose();
//     super.dispose();
//   }

//   void _addPhone() {
//     if (_phoneController.text.trim().isEmpty || _nameController.text.trim().isEmpty) {
//       _showErrorSnackBar('Lütfen tüm alanları doldurun');
//       return;
//     }

//     final newPhone = PhoneNumber(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       number: _phoneController.text.trim(),
//       displayName: _nameController.text.trim(),
//       isActive: false,
//       lastActivity: DateTime.now(),
//     );

//     setState(() {
//       phoneNumbers.add(newPhone);
//     });

//     _phoneController.clear();
//     _nameController.clear();
//     _showSuccessSnackBar('Telefon hattı başarıyla eklendi');
//   }

//   void _editPhone(PhoneNumber phone) {
//     _editPhoneController.text = phone.number;
//     _editNameController.text = phone.displayName;

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Hat Düzenle'),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: _editNameController,
//               decoration: const InputDecoration(
//                 labelText: 'Hat Adı',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _editPhoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Telefon Numarası',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('İptal'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_editPhoneController.text.trim().isEmpty || 
//                   _editNameController.text.trim().isEmpty) {
//                 return;
//               }

//               setState(() {
//                 final index = phoneNumbers.indexWhere((p) => p.id == phone.id);
//                 if (index != -1) {
//                   phoneNumbers[index] = PhoneNumber(
//                     id: phone.id,
//                     number: _editPhoneController.text.trim(),
//                     displayName: _editNameController.text.trim(),
//                     isActive: phone.isActive,
//                     lastActivity: phone.lastActivity,
//                   );
//                 }
//               });

//               Navigator.of(context).pop();
//               _showSuccessSnackBar('Hat bilgileri güncellendi');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: secondaryColor,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Güncelle'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _removePhone(String phoneId) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Hat Sil'),
//         content: const Text('Bu hattı silmek istediğinizden emin misiniz?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('İptal'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 phoneNumbers.removeWhere((p) => p.id == phoneId);
//               });
//               Navigator.of(context).pop();
//               _showSuccessSnackBar('Hat başarıyla silindi');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Sil'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _togglePhoneStatus(String phoneId) {
//     setState(() {
//       final index = phoneNumbers.indexWhere((p) => p.id == phoneId);
//       if (index != -1) {
//         final phone = phoneNumbers[index];
//         phoneNumbers[index] = PhoneNumber(
//           id: phone.id,
//           number: phone.number,
//           displayName: phone.displayName,
//           isActive: !phone.isActive,
//           lastActivity: DateTime.now(),
//         );
//       }
//     });
//   }

//   void _logout() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Çıkış Yap'),
//         content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text('İptal'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               context.go('/');
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.red,
//               foregroundColor: Colors.white,
//             ),
//             child: const Text('Çıkış Yap'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showSuccessSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: Colors.red,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF0F2F5),
//       body: Row(
//         children: [
//           // Left Sidebar
//           Container(
//             width: 280,
//             decoration: BoxDecoration(
//               color: mainColor,
//             ),
//             child: Column(
//               children: [
//                 // Header
//                 Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: mainColor.withOpacity(0.9),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: secondaryColor.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: const Text(
//                           'SEDEF WP',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
                
//                 const SizedBox(height: 20),
                
//                 // Navigation
//                 _buildNavItem(Icons.chat, 'Chat', () => context.go('/chat')),
//                 _buildNavItem(Icons.settings, 'Ayarlar', null, isActive: true),
                
//                 const Spacer(),
                
//                 // Logout
//                 Container(
//                   margin: const EdgeInsets.all(16),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: _logout,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                       ),
//                       icon: const Icon(Icons.logout),
//                       label: const Text('Çıkış Yap'),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // Main Content
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Page Title
//                   const Text(
//                     'Ayarlar',
//                     style: TextStyle(
//                       fontSize: 32,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF2D3748),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Hesap bilgilerinizi ve telefon hatlarınızı yönetin',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                   const SizedBox(height: 32),
                  
//                   Expanded(
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Left Column - User Info & Add Phone
//                         Expanded(
//                           flex: 1,
//                           child: Column(
//                             children: [
//                               _buildUserInfoCard(),
//                               const SizedBox(height: 24),
//                               _buildAddPhoneCard(),
//                             ],
//                           ),
//                         ),
                        
//                         const SizedBox(width: 24),
                        
//                         // Right Column - Phone List
//                         Expanded(
//                           flex: 1,
//                           child: _buildPhoneListCard(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem(IconData icon, String title, VoidCallback? onTap, {bool isActive = false}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//       decoration: BoxDecoration(
//         color: isActive ? secondaryColor.withOpacity(0.3) : Colors.transparent,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.white),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         onTap: onTap,
//       ),
//     );
//   }

//   Widget _buildUserInfoCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 CircleAvatar(
//                   radius: 30,
//                   backgroundColor: secondaryColor,
//                   child: const Icon(
//                     Icons.person,
//                     color: Colors.white,
//                     size: 30,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         userInfo['name']!,
//                         style: const TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       Text(
//                         userInfo['role']!,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             _buildInfoRow(Icons.email, 'Email', userInfo['email']!),
//             _buildInfoRow(Icons.phone, 'Telefon', userInfo['phone']!),
//             _buildInfoRow(Icons.access_time, 'Son Giriş', userInfo['lastLogin']!),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: Colors.grey.shade600),
//           const SizedBox(width: 12),
//           Text(
//             '$label: ',
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: TextStyle(
//                 color: Colors.grey.shade700,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAddPhoneCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Yeni Telefon Hattı Ekle',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _nameController,
//               decoration: const InputDecoration(
//                 labelText: 'Hat Adı',
//                 hintText: 'örn: İş Hattı',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.label),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _phoneController,
//               decoration: const InputDecoration(
//                 labelText: 'Telefon Numarası',
//                 hintText: '+90 555 123 4567',
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.phone),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: _addPhone,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: secondaryColor,
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 icon: const Icon(Icons.add),
//                 label: const Text('Hat Ekle'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPhoneListCard() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 const Text(
//                   'Mevcut Hatlar',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Spacer(),
//                 Text(
//                   '${phoneNumbers.length} hat',
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: phoneNumbers.length,
//                 itemBuilder: (context, index) {
//                   final phone = phoneNumbers[index];
//                   return Card(
//                     margin: const EdgeInsets.only(bottom: 12),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Row(
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: phone.isActive ? Colors.green : Colors.grey,
//                             radius: 12,
//                             child: Icon(
//                               phone.isActive ? Icons.check : Icons.close,
//                               color: Colors.white,
//                               size: 16,
//                             ),
//                           ),
//                           const SizedBox(width: 16),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   phone.displayName,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                                 Text(
//                                   phone.number,
//                                   style: TextStyle(
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 ),
//                                 Text(
//                                   phone.isActive ? 'Aktif' : 'Pasif',
//                                   style: TextStyle(
//                                     color: phone.isActive ? Colors.green : Colors.grey,
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Switch(
//                             value: phone.isActive,
//                             onChanged: (_) => _togglePhoneStatus(phone.id),
//                             activeColor: secondaryColor,
//                           ),
//                           IconButton(
//                             onPressed: () => _editPhone(phone),
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             tooltip: 'Düzenle',
//                           ),
//                           IconButton(
//                             onPressed: () => _removePhone(phone.id),
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             tooltip: 'Sil',
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }