import 'package:flutter/material.dart';
import 'package:flutter_pos/pages/data/login/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final email = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final passwordFormKey = GlobalKey<FormState>();
  final passwordFocusNode = FocusNode();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void login() async {
    final success = await ref.read(loginProvider.notifier).login(
          usernameOrEmail: email.text,
          password: password.text,
        );
    if (success) {
      email.clear();
      password.clear();
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // error text
              loginState.maybeWhen(
                error: (error, stackTrace) => Text(
                  error.toString(),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.redAccent),
                  textAlign: TextAlign.left,
                ),
                orElse: () => const SizedBox(),
              ),
              const SizedBox(height: 16.0),
              // email
              Form(
                key: emailFormKey,
                child: TextFormField(
                  enabled: loginState.isLoading == false,
                  controller: email,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email is required';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    if (emailFormKey.currentState?.validate() == true) {
                      passwordFocusNode.requestFocus();
                    }
                  },
                  onTapOutside: (event) {
                    emailFormKey.currentState?.validate();
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              // password
              Form(
                key: passwordFormKey,
                child: TextFormField(
                  focusNode: passwordFocusNode,
                  enabled: loginState.isLoading == false,
                  controller: password,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                  onEditingComplete: () {
                    if (emailFormKey.currentState?.validate() == true &&
                        passwordFormKey.currentState?.validate() == true) {
                      login();
                    }
                  },
                  onTapOutside: (event) {
                    passwordFormKey.currentState?.validate();
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ButtonBar(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (emailFormKey.currentState?.validate() == true &&
                          passwordFormKey.currentState?.validate() == true) {
                        login();
                      }
                    },
                    child: loginState.maybeWhen(
                      orElse: () => const Text('Log In'),
                      loading: () => const Text('Waiting'),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
