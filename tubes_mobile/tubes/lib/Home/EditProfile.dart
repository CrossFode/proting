import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  final int userId;

  const EditProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _fullnameController = TextEditingController();
  String _selectedGender = 'Laki-laki';
  DateTime _selectedDate = DateTime(1990, 1, 1);
  File? _profileImage;
  String? _currentProfilePicture;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan', 'Non-binery'];

  static const String baseUrl = 'http://10.0.2.2:3000/api';

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _fullnameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      print('Loading user profile for ID: ${widget.userId}');
      print('API URL: $baseUrl/Account/${widget.userId}');

      final response = await http.get(
        Uri.parse('$baseUrl/Account/${widget.userId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout - Check your internet connection');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        print('User data received: $userData');

        setState(() {
          _usernameController.text = userData['username']?.toString() ?? '';
          _emailController.text = userData['email']?.toString() ?? '';
          _phoneController.text = userData['phone']?.toString() ?? '';
          _fullnameController.text = userData['fullname']?.toString() ?? '';

          String gender = userData['gender']?.toString() ?? 'Laki-laki';
          if (_genderOptions.contains(gender)) {
            _selectedGender = gender;
          } else {
            _selectedGender = 'Laki-laki';
          }

          if (userData['tanggal_lahir'] != null &&
              userData['tanggal_lahir'].toString().isNotEmpty) {
            try {
              _selectedDate =
                  DateTime.parse(userData['tanggal_lahir'].toString());
            } catch (e) {
              print('Error parsing birth date: $e');
              _selectedDate = DateTime(1990, 1, 1);
            }
          }

          _currentProfilePicture = userData['profile_picture']?.toString();
          print('Current profile picture: $_currentProfilePicture');
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _hasError = true;
          _errorMessage = 'User not found (404)';
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Server error: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      print('Error loading profile: $e');
      setState(() {
        _hasError = true;
        _errorMessage = 'Network error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFFC107),
              onPrimary: Colors.black,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: $e');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (photo != null) {
        setState(() {
          _profileImage = File(photo.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error taking photo: $e');
    }
  }

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _uploadProfilePicture() async {
    if (_profileImage == null) return;

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/Account/${widget.userId}/profile-picture'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_picture',
          _profileImage!.path,
        ),
      );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      print('Upload response status: ${response.statusCode}');
      print('Upload response body: $responseBody');

      if (response.statusCode == 200) {
        var responseData = json.decode(responseBody);
        setState(() {
          _currentProfilePicture = responseData['profile_picture'];
          _profileImage = null;
        });
        _showSnackBar('Foto profil berhasil diperbarui');
      } else {
        var responseData = json.decode(responseBody);
        throw Exception('Failed to upload image: ${responseData['error']}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // First, upload profile picture if changed
      if (_profileImage != null) {
        await _uploadProfilePicture();
      }

      // Format tanggal_lahir to YYYY-MM-DD format
      String formattedTanggalLahir =
          DateFormat('yyyy-MM-dd').format(_selectedDate);

      // Then update profile data with ALL fields
      final Map<String, dynamic> profileData = {
        'username': _usernameController.text.trim(),
        'fullname': _fullnameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'jenis_kelamin': _selectedGender,
        'tanggal_lahir': DateFormat('yyyy-MM-dd').format(_selectedDate),
      };

      // Add profile_picture if we have a current one
      if (_currentProfilePicture != null) {
        profileData['profile_picture'] = _currentProfilePicture;
      }

      print('Saving profile data: $profileData');

      final response = await http.put(
        Uri.parse('$baseUrl/Account/${widget.userId}/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(profileData),
      );

      print('Save response status: ${response.statusCode}');
      print('Save response body: ${response.body}');

      if (response.statusCode == 200) {
        _showSnackBar('Profil berhasil diperbarui');
        // Wait a moment for the snackbar to show
        await Future.delayed(const Duration(seconds: 1));
        // Navigate back to ProfilePage with success result
        Navigator.pop(context, true);
      } else {
        final errorData = json.decode(response.body);
        _showSnackBar('Error: ${errorData['error']}');
      }
    } catch (e) {
      print('Error saving profile: $e');
      _showSnackBar('Error saving profile: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  String _getProfileImageUrl() {
    if (_currentProfilePicture != null && _currentProfilePicture!.isNotEmpty) {
      if (_currentProfilePicture!.startsWith('/images/')) {
        return 'http://10.0.2.2:3000${_currentProfilePicture!}';
      }
      return _currentProfilePicture!;
    }
    return 'https://i.stack.imgur.com/l60Hf.png';
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error Loading Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFC107),
                foregroundColor: Colors.black,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFFFFC107)),
              SizedBox(height: 16),
              Text('Loading profile...'),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Profile'),
          centerTitle: true,
        ),
        body: _buildErrorWidget(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: const Text(
              'Simpan',
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile picture section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: _profileImage != null
                                ? Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                  )
                                : Image.network(
                                    _getProfileImageUrl(),
                                    fit: BoxFit.cover,
                                    width: 100,
                                    height: 100,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      print(
                                          'Error loading profile image: $error');
                                      return const Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      );
                                    },
                                  ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _showImageSourceOptions,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC107),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.add_a_photo,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _usernameController.text.isEmpty
                          ? 'User'
                          : _usernameController.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Form Fields
              _buildFormField('Username', _usernameController, Icons.person),
              _buildReadOnlyField('Email', _emailController.text, Icons.email),
              _buildFormField('Nama Lengkap', _fullnameController, Icons.badge),
              _buildFormField('Nomor Telepon', _phoneController, Icons.phone),

              // Gender Dropdown
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.people, color: Colors.grey),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedGender,
                            hint: const Text('Jenis Kelamin'),
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            style: const TextStyle(color: Colors.black87),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedGender = newValue!;
                              });
                            },
                            items: _genderOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Birth Date Picker
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.calendar_today, color: Colors.grey),
                  title: const Text('Tanggal Lahir'),
                  subtitle:
                      Text(DateFormat('dd MMMM yyyy').format(_selectedDate)),
                  onTap: () => _selectDate(context),
                ),
              ),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFC107),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Text(
                          'SIMPAN PERUBAHAN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(
      String label, TextEditingController controller, IconData icon) {
    // Deteksi jika field phone
    final isPhone = label.toLowerCase().contains('telepon') ||
        label.toLowerCase().contains('phone');
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: controller,
                    keyboardType:
                        isPhone ? TextInputType.number : TextInputType.text,
                    inputFormatters: isPhone
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    value.isEmpty ? 'Tidak tersedia' : value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}