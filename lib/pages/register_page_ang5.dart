import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller_ang5.dart';

class RegisterPageAng5 extends StatefulWidget {
  const RegisterPageAng5({super.key});

  @override
  State<RegisterPageAng5> createState() => _RegisterPageAng5State();
}

class _RegisterPageAng5State extends State<RegisterPageAng5> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final balanceCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthControllerAng5>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameCtrl,
                validator: (v) => v!.isEmpty ? "Username wajib" : null,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: emailCtrl,
                validator: (v) => v!.isEmpty ? "Email wajib" : null,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
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
              TextFormField(
                controller: balanceCtrl,
                validator: (v) => v!.isEmpty ? "Balance wajib" : null,
                decoration: const InputDecoration(
                  labelText: "Balance",
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

                  await auth.registerWithEmail(
                    email: emailCtrl.text.trim(),
                    password: passCtrl.text.trim(),
                    username: usernameCtrl.text.trim(),
                    balance: balanceCtrl.text.trim(),
                    context: context,
                  );
                },
                child: auth.loading
                    ? const CircularProgressIndicator()
                    : const Text("Daftar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
