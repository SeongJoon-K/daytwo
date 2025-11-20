// 설명: 프로필 정보와 이미지를 수정하여 AppState에 반영하는 화면.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/spacing.dart';
import '../../widgets/common/primary_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _jobController;
  late TextEditingController _locationController;
  late TextEditingController _mbtiController;
  late TextEditingController _introController;
  String? _photo;

  @override
  void initState() {
    super.initState();
    final user = context.read<AppState>().currentUser;
    _nameController = TextEditingController(text: user.name);
    _ageController = TextEditingController(text: user.age.toString());
    _jobController = TextEditingController(text: user.job);
    _locationController = TextEditingController(text: user.location);
    _mbtiController = TextEditingController(text: user.mbti);
    _introController = TextEditingController(text: user.intro);
    _photo = user.photoUrl;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final result = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (result == null) return;
    if (kIsWeb) {
      final bytes = await result.readAsBytes();
      final base64Data = base64Encode(bytes);
      setState(() {
        _photo = 'data:${result.mimeType ?? 'image/png'};base64,$base64Data';
      });
    } else {
      setState(() => _photo = result.path);
    }
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final age = int.tryParse(_ageController.text) ?? 0;
    context.read<AppState>().saveEditedProfile(
          name: _nameController.text.trim(),
          age: age,
          job: _jobController.text.trim(),
          location: _locationController.text.trim(),
          mbti: _mbtiController.text.trim(),
          intro: _introController.text.trim(),
          photoUrl: _photo,
        );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _jobController.dispose();
    _locationController.dispose();
    _mbtiController.dispose();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = _photo;
    Widget avatar = CircleAvatar(
      radius: 48,
      backgroundColor: Colors.black12,
      child: const Icon(Icons.camera_alt),
    );
    if (image != null) {
      ImageProvider provider;
      if (image.startsWith('data:image')) {
        provider = MemoryImage(base64Decode(image.split(',').last));
      } else if (image.startsWith('http')) {
        provider = NetworkImage(image);
      } else {
        provider = AssetImage(image);
      }
      avatar = CircleAvatar(radius: 48, backgroundImage: provider);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('프로필 수정')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DaytwoSpacing.s24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: InkWell(
                  onTap: _pickImage,
                  child: avatar,
                ),
              ),
              const SizedBox(height: DaytwoSpacing.s24),
              _buildField('이름', _nameController),
              Row(
                children: [
                  Expanded(child: _buildField('나이', _ageController, keyboardType: TextInputType.number)),
                  const SizedBox(width: DaytwoSpacing.s12),
                  Expanded(child: _buildField('MBTI', _mbtiController)),
                ],
              ),
              _buildField('직무', _jobController),
              _buildField('지역', _locationController),
              _buildField('한 줄 소개', _introController, maxLines: 2),
              const SizedBox(height: DaytwoSpacing.s24),
              PrimaryButton(label: '저장', onPressed: _save),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: DaytwoSpacing.s16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: (value) => value == null || value.trim().isEmpty ? '$label을 입력해 주세요' : null,
        decoration: InputDecoration(labelText: label),
      ),
    );
  }
}
