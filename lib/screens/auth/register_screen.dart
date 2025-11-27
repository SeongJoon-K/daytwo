// 설명: 이메일 회원가입 UI. 성공 시 자동으로 로그인 상태가 되며 메인 화면으로 전환된다.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/spacing.dart';
import '../../widgets/common/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'male';
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final age = int.tryParse(_ageController.text.trim()) ?? 0;
    if (age <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('나이를 확인해 주세요.')),
      );
      return;
    }
    setState(() => _isLoading = true);
    final success = await context.read<AppState>().register(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text.trim(),
          age: age,
          gender: _gender,
        );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이미 사용 중인 이메일입니다.')),
      );
      return;
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(DaytwoSpacing.s24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: '이메일'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || value.isEmpty ? '이메일을 입력해 주세요' : null,
              ),
              const SizedBox(height: DaytwoSpacing.s16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) => value == null || value.length < 6 ? '6자 이상 입력해 주세요' : null,
              ),
              const SizedBox(height: DaytwoSpacing.s16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '이름'),
                validator: (value) => value == null || value.isEmpty ? '이름을 입력해 주세요' : null,
              ),
              const SizedBox(height: DaytwoSpacing.s16),
              Text('성별', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: DaytwoSpacing.s8),
              Wrap(
                spacing: DaytwoSpacing.s8,
                children: [
                  _GenderChip(
                    label: '남자',
                    value: 'male',
                    groupValue: _gender,
                    onSelected: (v) => setState(() => _gender = v),
                  ),
                  _GenderChip(
                    label: '여자',
                    value: 'female',
                    groupValue: _gender,
                    onSelected: (v) => setState(() => _gender = v),
                  ),
                  _GenderChip(
                    label: '기타',
                    value: 'other',
                    groupValue: _gender,
                    onSelected: (v) => setState(() => _gender = v),
                  ),
                ],
              ),
              const SizedBox(height: DaytwoSpacing.s16),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: '나이'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? '나이를 입력해 주세요' : null,
              ),
              const SizedBox(height: DaytwoSpacing.s24),
              PrimaryButton(
                label: _isLoading ? '가입 중...' : '회원가입',
                onPressed: _isLoading ? null : _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GenderChip extends StatelessWidget {
  final String label;
  final String value;
  final String groupValue;
  final ValueChanged<String> onSelected;

  const _GenderChip({
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(value),
      selectedColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      side: BorderSide(color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300),
    );
  }
}
