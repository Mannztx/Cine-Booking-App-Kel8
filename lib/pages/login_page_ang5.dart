import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller_ang5.dart';

class LoginPageAng5 extends StatefulWidget {
  const LoginPageAng5({super.key});

  @override
  State<LoginPageAng5> createState() => _LoginPageAng5State();
}

class _LoginPageAng5State extends State<LoginPageAng5> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthControllerAng5>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailCtrl,
                validator: (v) => v!.isEmpty ? "Email wajib diisi" : null,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passCtrl,
                obscureText: true,
                validator: (v) => v!.length < 6 ? "Minimal 6 karakter" : null,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (auth.errorMessage != null)
                Text(
                  auth.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  await auth.loginWithEmail(
                    email: emailCtrl.text.trim(),
                    password: passCtrl.text.trim(),
                  );
                },
                child: auth.loading
                    ? const CircularProgressIndicator()
                    : const Text("Login"),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, "/register"),
                child: const Text("Belum punya akun? Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
