import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sedefwpwebapp/models/phone_number_model/phone_number_model.dart';
import 'package:sedefwpwebapp/models/user_model/user_model.dart';
import 'package:sedefwpwebapp/utilities/data_utilities.dart';
import 'package:sedefwpwebapp/view_models/main_view_model.dart';
import '../contants.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _phoneController = TextEditingController();
  final _phoneIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _editPhoneController = TextEditingController();
  final _editPhoneNumberIdController = TextEditingController();
  final _editNameController = TextEditingController();
  
  // Admin için yeni user ekleme controller'ları
  final _newUserNameController = TextEditingController();
  final _newUserSurnameController = TextEditingController();
  final _newUserEmailController = TextEditingController();
  final _newUserPasswordController = TextEditingController();
  final _newUserDescriptionController = TextEditingController();
  
  // Admin için user düzenleme controller'ları
  final _editUserNameController = TextEditingController();
  final _editUserSurnameController = TextEditingController();
  final _editUserEmailController = TextEditingController();
  final _editUserPasswordController = TextEditingController();
  final _editUserDescriptionController = TextEditingController();
  
  final MainViewModel _mainViewModel = MainViewModel();

  @override
  void initState() {
    super.initState();
    // Veri yükleme işlemleri initState'de yapılır
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    loggedUserToken = await getSharedPrefs(4, "accessToken") ?? "";
    if(loggedUserToken.isEmpty){
      context.go('/');
      return;
    }
    await _mainViewModel.getMyUser(ref, context,needToGo: false);
    
    // Eğer kullanıcı ADMIN ise user listesini yükle
    final loggedUser = ref.read(_mainViewModel.loggedUser);
    if (loggedUser.role == 'ADMIN') {
      await _mainViewModel.getListUser(ref, context);
    }else{
        context.go('/chat');
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _editPhoneNumberIdController.dispose();
    _editPhoneController.dispose();
    _editNameController.dispose();
    
    // Admin controller'ları
    _newUserNameController.dispose();
    _newUserSurnameController.dispose();
    _newUserEmailController.dispose();
    _newUserPasswordController.dispose();
    _newUserDescriptionController.dispose();
    _editUserNameController.dispose();
    _editUserSurnameController.dispose();
    _editUserEmailController.dispose();
    _editUserPasswordController.dispose();
    _editUserDescriptionController.dispose();
    
    super.dispose();
  }

  Future<void> _addPhone() async {
    if (_phoneController.text.trim().isEmpty || _nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Lütfen tüm alanları doldurun');
      return;
    }

    final newPhone = PhoneNumberModel(
      phoneNumberId: _phoneIdController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      title: _nameController.text,
    );

    await _mainViewModel.addPhoneNumber(ref, context, newPhone);

    _phoneController.clear();
    _phoneIdController.clear();
    _nameController.clear();
  }

  Future<void> _editPhone(PhoneNumberModel phone) async {
    _editPhoneController.text = phone.phoneNumber ?? '';
    _editPhoneNumberIdController.text = phone.phoneNumberId ?? '';
    _editNameController.text = phone.title ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hat Düzenle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _editNameController,
              decoration: const InputDecoration(
                labelText: 'Hat Adı',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _editPhoneController,
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _editPhoneNumberIdController,
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası ID',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_editPhoneController.text.trim().isEmpty || 
                  _editNameController.text.trim().isEmpty) {
                return;
              }
              
              await _mainViewModel.updatePhoneNumber(ref, context, phone.copyWith(
                phoneNumber: _editPhoneController.text.trim(), 
                title: _editNameController.text,
                phoneNumberId: _editPhoneNumberIdController.text.trim(),
              ));
              
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: secondaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Güncelle'),
          ),
        ],
      ),
    );
  }

  Future<void> _removePhone(String phoneId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hat Sil'),
        content: const Text('Bu hattı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _mainViewModel.deletePhoneNumber(ref, context, int.parse(phoneId));
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  void _togglePhoneStatus(String phoneId) {
    _mainViewModel.togglePhoneStatus(ref, context, phoneId);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Çıkış Yap'),
        content: const Text('Çıkış yapmak istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await sharedPrefsClear("accessToken");
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Çıkış Yap'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Admin fonksiyonları
  Future<void> _addUser() async {
    if (_newUserNameController.text.trim().isEmpty || 
        _newUserSurnameController.text.trim().isEmpty ||
        _newUserEmailController.text.trim().isEmpty ||
        _newUserPasswordController.text.trim().isEmpty) {
      _showErrorSnackBar('Lütfen tüm alanları doldurun');
      return;
    }

    await _mainViewModel.createCustomerService(
      ref, 
      context, 
      _newUserNameController.text.trim(),
      _newUserSurnameController.text.trim(),
      _newUserEmailController.text.trim(),
      _newUserPasswordController.text.trim(),
      _newUserDescriptionController.text.trim(),
    );

    _newUserNameController.clear();
    _newUserSurnameController.clear();
    _newUserEmailController.clear();
    _newUserPasswordController.clear();
    _newUserDescriptionController.clear();
  }

  Future<void> _editUser(UserModel user) async {
    _editUserNameController.text = user.name ?? '';
    _editUserSurnameController.text = user.surname ?? '';
    _editUserEmailController.text = user.emailAddress ?? '';
    _editUserPasswordController.text = '';
    _editUserDescriptionController.text = user.description ?? '';
    
    // Kullanıcının mevcut telefon numarası listesini al
    List<int> userPhoneNumberIds = [];
    if (user.phoneNumberList != null && user.phoneNumberList!.isNotEmpty) {
      userPhoneNumberIds = user.phoneNumberList!.split(',').map((e) => int.tryParse(e.trim()) ?? 0).toList();
    }

    // Kullanıcının mevcut status'u
    bool userStatus = user.status ?? false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final phoneNumbers = ref.watch(_mainViewModel.phoneNumbers);
          
          return AlertDialog(
            title: const Text('Kullanıcı Düzenle'),
            content: Container(
              width: 500,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _editUserNameController,
                      decoration: const InputDecoration(
                        labelText: 'Ad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _editUserSurnameController,
                      decoration: const InputDecoration(
                        labelText: 'Soyad',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _editUserEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _editUserPasswordController,
                      decoration: const InputDecoration(
                        labelText: 'Yeni Şifre (Boş bırakabilirsiniz)',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _editUserDescriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Açıklama',
                        hintText: 'Kullanıcı hakkında açıklama',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    
                    // Kullanıcı Durumu
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.person_outline, size: 20),
                          const SizedBox(width: 12),
                          const Text(
                            'Kullanıcı Durumu:',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Switch(
                            value: userStatus,
                            onChanged: (bool value) {
                              setDialogState(() {
                                userStatus = value;
                              });
                            },
                            activeColor: secondaryColor,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: userStatus ? Colors.green : Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              userStatus ? 'Aktif' : 'Pasif',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Telefon Numarası Seçimi
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.phone, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Telefon Numarası Seçimi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            constraints: const BoxConstraints(maxHeight: 200),
                            child: phoneNumbers.isEmpty
                                ? const Center(
                                    child: Text(
                                      'Henüz telefon numarası bulunmamaktadır.',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: phoneNumbers.length,
                                    itemBuilder: (context, index) {
                                      final phone = phoneNumbers[index];
                                      final phoneId = phone.id!;
                                      final isChecked = userPhoneNumberIds.contains(phoneId);
                                      
                                      return CheckboxListTile(
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          setDialogState(() {
                                            if (value == true) {
                                              if (!userPhoneNumberIds.contains(phoneId)) {
                                                userPhoneNumberIds.add(phoneId);
                                              }
                                            } else {
                                              userPhoneNumberIds.remove(phoneId);
                                            }
                                          });
                                        },
                                        title: Text(
                                          phone.title ?? 'Bilinmeyen Hat',
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(phone.phoneNumber ?? ''),
                                            Text(
                                              'ID: ${phone.phoneNumberId ?? ''}',
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                        secondary: CircleAvatar(
                                          radius: 12,
                                          backgroundColor: (phone.status ?? false) ? Colors.green : Colors.grey,
                                          child: Icon(
                                            (phone.status ?? false) ? Icons.check : Icons.close,
                                            color: Colors.white,
                                            size: 14,
                                          ),
                                        ),
                                        dense: true,
                                        controlAffinity: ListTileControlAffinity.leading,
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('İptal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_editUserNameController.text.trim().isEmpty || 
                      _editUserSurnameController.text.trim().isEmpty ||
                      _editUserEmailController.text.trim().isEmpty) {
                    return;
                  }
                  
                  // Seçilen telefon numarası ID'lerini virgülle ayırarak birleştir
                  final selectedPhoneNumberIds = userPhoneNumberIds.join(',');
                  
                  await _mainViewModel.updateCustomerService(
                    ref, 
                    context, 
                    user.id!,
                    _editUserNameController.text.trim(),
                    _editUserSurnameController.text.trim(),
                    _editUserEmailController.text.trim(),
                    _editUserPasswordController.text.trim().isEmpty ? 
                      user.password! : _editUserPasswordController.text.trim(),
                    userStatus, // userStatus değişkenini kullan
                    selectedPhoneNumberIds,
                    _editUserDescriptionController.text.trim(), // Description ekle
                  );
                  
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Güncelle'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _removeUser(int userId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kullanıcı Sil'),
        content: const Text('Bu kullanıcıyı silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _mainViewModel.deleteCustomerService(ref, context, userId);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Riverpod state'leri izle
    final phoneNumbers = ref.watch(_mainViewModel.phoneNumbers);
    final loggedUser = ref.watch(_mainViewModel.loggedUser);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 280,
            decoration: BoxDecoration(
              color: mainColor,
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: mainColor.withOpacity(0.9),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: secondaryColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.asset("assets/images/logo.png", height: 40,),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Navigation
                _buildNavItem(Icons.chat, 'Chat', () => context.go('/chat')),
                _buildNavItem(Icons.settings, 'Ayarlar', null, isActive: true),
                
                const Spacer(),
                
                // Logout
                Container(
                  margin: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text('Çıkış Yap'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Main Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  const Text(
                    'Ayarlar',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hesap bilgilerinizi ve telefon hatlarınızı yönetin',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  Expanded(
                    child: loggedUser.role == 'ADMIN' 
                      ? _buildAdminPanel(loggedUser, phoneNumbers)
                      : _buildUserPanel(loggedUser, phoneNumbers),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, VoidCallback? onTap, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? secondaryColor.withOpacity(0.3) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildUserInfoCard(dynamic loggedUser, List<PhoneNumberModel> phoneNumbers) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: secondaryColor,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (loggedUser.name ?? 'Kullanıcı') + ' ' + (loggedUser.surname ?? ''),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Müşteri Hizmetleri',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildInfoRow(Icons.person_outline, 'Kullanıcı Adı', loggedUser.emailAddress ?? 'E-posta bulunamadı'),
            // _buildInfoRow(Icons.access_time, 'Son Giriş', _formatDateTime(DateTime.now())),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhoneCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yeni Telefon Hattı Ekle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Hat Adı',
                hintText: 'örn: İş Hattı',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.label),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası',
                hintText: '+90 555 123 4567',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneIdController,
              decoration: const InputDecoration(
                labelText: 'Telefon Numarası ID',
                hintText: '999999999999',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async => await  _addPhone().then((_){
                  setState(() {
                    
                  });
                }),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Hat Ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ConsumerWidget _buildPhoneListCard(List<PhoneNumberModel> phoneNumbers) {
    return Consumer(builder: (context, ref, child) => 
      Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Mevcut Hatlar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${phoneNumbers.length} hat',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: phoneNumbers.length,
                  itemBuilder: (context, index) {
                    final phone = phoneNumbers[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: (phone.status ?? false) ? Colors.green : Colors.grey,
                              radius: 12,
                              child: Icon(
                                (phone.status ?? false) ? Icons.check : Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    phone.title ?? 'Bilinmeyen Hat',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    phone.phoneNumber ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    phone.phoneNumberId ?? '',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 12
                                    ),
                                  ),
                                  Text(
                                    (phone.status ?? false) ? 'Aktif' : 'Pasif',
                                    style: TextStyle(
                                      color: (phone.status ?? false) ? Colors.green : Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: phone.status ?? false,
                              onChanged: (_) => _togglePhoneStatus(phone.phoneNumberId ?? ''),
                              activeColor: secondaryColor,
                            ),
                            IconButton(
                              onPressed: () async => await _editPhone(phone).then((_){
                                setState(() {
                                });
                              }),
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Düzenle',
                            ),
                            IconButton(
                              onPressed: () async => await _removePhone(phone.phoneNumberId ?? '').then((_){
                                setState(() {
                                });
                              }),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Sil',
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Normal kullanıcı paneli
  Widget _buildUserPanel(UserModel loggedUser, List<PhoneNumberModel> phoneNumbers) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column - User Info & Add Phone
        Expanded(
          flex: 1,
          child: Column(
            children: [
              _buildUserInfoCard(loggedUser, phoneNumbers),
              const SizedBox(height: 24),
              _buildAddPhoneCard(),
            ],
          ),
        ),
        
        const SizedBox(width: 24),
        
        // Right Column - Phone List
        Expanded(
          flex: 1,
          child: _buildPhoneListCard(phoneNumbers),
        ),
      ],
    );
  }

  // Admin paneli
  Widget _buildAdminPanel(UserModel loggedUser, List<PhoneNumberModel> phoneNumbers) {
    final users = ref.watch(_mainViewModel.users);
    
    return Column(
      children: [
        // Tab bar için Container
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people),
                          SizedBox(width: 8),
                          Text('Kullanıcı Yönetimi'),
                        ],
                      ),
                    ),
                    Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone),
                          SizedBox(width: 8),
                          Text('Hat Yönetimi'),
                        ],
                      ),
                    ),
                  ],
                  labelColor: secondaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: secondaryColor,
                ),
                Container(
                  height: 550,
                  child: TabBarView(
                    children: [
                      // Kullanıcı Yönetimi Tab
                      _buildUserManagementTab(users, phoneNumbers),
                      // Hat Yönetimi Tab
                      _buildPhoneManagementTab(loggedUser, phoneNumbers),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Kullanıcı yönetimi tab'ı
  Widget _buildUserManagementTab(List<UserModel> users, List<PhoneNumberModel> phoneNumbers) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol taraf - Yeni kullanıcı ekleme
          Expanded(
            flex: 1,
            child: _buildAddUserCard(),
          ),
          
          const SizedBox(width: 16),
          
          // Sağ taraf - Kullanıcı listesi
          Expanded(
            flex: 2,
            child: _buildUserListCard(users),
          ),
        ],
      ),
    );
  }

  // Hat yönetimi tab'ı
  Widget _buildPhoneManagementTab(UserModel loggedUser, List<PhoneNumberModel> phoneNumbers) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sol taraf - Kullanıcı bilgisi ve hat ekleme
          Expanded(
            flex: 1,
            child: Column(
              children: [
                _buildUserInfoCard(loggedUser, phoneNumbers),
                const SizedBox(height: 12),
                _buildAddPhoneCard(),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Sağ taraf - Hat listesi
          Expanded(
            flex: 1,
            child: _buildPhoneListCard(phoneNumbers),
          ),
        ],
      ),
    );
  }

  // Yeni kullanıcı ekleme kartı
  Widget _buildAddUserCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yeni Kullanıcı Ekle',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newUserNameController,
              decoration: const InputDecoration(
                labelText: 'Ad',
                hintText: 'örn: Ali',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newUserSurnameController,
              decoration: const InputDecoration(
                labelText: 'Soyad',
                hintText: 'örn: Veli',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newUserEmailController,
              decoration: const InputDecoration(
                labelText: 'Email/Kullanıcı Adı',
                hintText: 'örn: ali.veli@email.com',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newUserPasswordController,
              decoration: const InputDecoration(
                labelText: 'Şifre',
                hintText: 'Güçlü bir şifre oluşturun',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newUserDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Açıklama',
                hintText: 'Kullanıcı hakkında açıklama',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Kullanıcı Ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Kullanıcı listesi kartı
  Widget _buildUserListCard(List<UserModel> users) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Kullanıcılar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${users.length} kullanıcı',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: user.role == 'ADMIN' ? Colors.orange : secondaryColor,
                            child: Icon(
                              user.role == 'ADMIN' ? Icons.admin_panel_settings : Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.name ?? 'İsim'} ${user.surname ?? 'Soyisim'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  user.emailAddress ?? 'Email bulunamadı',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      user.role ?? 'Rol belirtilmemiş',
                                      style: TextStyle(
                                        color: user.role == 'ADMIN' ? Colors.orange : Colors.blue,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Status göstergesi
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: (user.status ?? false) ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        (user.status ?? false) ? 'Aktif' : 'Pasif',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Telefon numarası sayısını göster
                                if (user.phoneNumberList != null && user.phoneNumberList!.isNotEmpty)
                                  Text(
                                    '${user.phoneNumberList!.split(',').length} telefon hattı',
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                else
                                  Text(
                                    'Telefon hattı yok',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 12,
                                    ),
                                  ),
                                // Description göster
                                if (user.description != null && user.description!.isNotEmpty)
                                  Text(
                                    user.description!,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                          ),
                          // Status Switch (sadece ADMIN olmayan kullanıcılar için)
                          if (user.role != 'ADMIN') ...[
                            Column(
                              children: [
                                Switch(
                                  value: user.status ?? false,
                                  onChanged: (bool value) {
                                    _mainViewModel.toggleUserStatus(ref, context, user.id!, user.status ?? false);
                                  },
                                  activeColor: secondaryColor,
                                ),
                                Text(
                                  'Durum',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          if (user.role != 'ADMIN') ...[
                            IconButton(
                              onPressed: () => _editUser(user),
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              tooltip: 'Düzenle',
                            ),
                            IconButton(
                              onPressed: () => _removeUser(user.id!),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: 'Sil',
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}