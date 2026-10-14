import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RecuperarSenhaPage extends StatefulWidget {
  const RecuperarSenhaPage({super.key});

  @override
  State<RecuperarSenhaPage> createState() =>
      _RecuperarSenhaPageState();
}

class _RecuperarSenhaPageState
    extends State<RecuperarSenhaPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  bool carregando = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> enviarEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      carregando = true;
    });

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        emailController.text.trim().toLowerCase(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Solicitação enviada. Verifique seu e-mail.',
          ),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível enviar a solicitação.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF073F82),
      appBar: AppBar(
        backgroundColor: const Color(0xFF073F82),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('Recuperar senha'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),

                // Espaço reservado para a logo.
                const SizedBox(height: 70),

                Text(
                  'Esqueceu sua senha?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Informe o e-mail da sua conta para receber '
                  'as instruções de recuperação.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 30),

                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Seu e-mail',
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (valor) {
                    if (valor == null || valor.trim().isEmpty) {
                      return 'Informe seu e-mail.';
                    }

                    if (!valor.contains('@') ||
                        !valor.contains('.')) {
                      return 'Informe um e-mail válido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: carregando ? null : enviarEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1687E8),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: carregando
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text('ENVIAR INSTRUÇÕES'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}