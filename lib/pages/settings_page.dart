import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sedefwpwebapp/models/phone_number_model/phone_number_model.dart';
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
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _editPhoneNumberIdController.dispose();
    _editPhoneController.dispose();
    _editNameController.dispose();
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
            onPressed: () {
              Navigator.of(context).pop();
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
                    child: Row(
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
                    ),
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
                        loggedUser.name ?? 'Kullanıcı',
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
            _buildInfoRow(Icons.person_outline, 'Kullanıcı Adı', loggedUser.username ?? 'E-posta bulunamadı'),
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
}