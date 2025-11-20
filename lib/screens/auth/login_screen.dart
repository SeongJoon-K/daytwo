// 설명: 이메일 기반 로그인 UI. 성공 시 AppState 상태만 갱신되면 자동으로 메인 탭이 노출된다.
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/spacing.dart';
import '../../widgets/common/primary_button.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final success = await context.read<AppState>().login(
          _emailController.text,
          _passwordController.text,
        );
    if (!mounted) return;
    setState(() => _isLoading = false);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 또는 비밀번호가 잘못되었습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(DaytwoSpacing.s24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('daytwo', style: Theme.of(context).textTheme.displaySmall),
                  const SizedBox(height: DaytwoSpacing.s24),
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
                    validator: (value) => value == null || value.isEmpty ? '비밀번호를 입력해 주세요' : null,
                  ),
                  const SizedBox(height: DaytwoSpacing.s24),
                  PrimaryButton(
                    label: _isLoading ? '로그인 중...' : '로그인',
                    onPressed: _isLoading ? null : _submit,
                  ),
                  const SizedBox(height: DaytwoSpacing.s12),
                  TextButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            );
                          },
                    child: const Text('계정이 없으신가요? 회원가입'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
