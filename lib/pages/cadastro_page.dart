
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';


class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool carregando = false;

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();

    super.dispose();
  }

  
  Future<void> cadastrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      carregando = true;
    });

    try {
      final nome = nomeController.text.trim();
      final email = emailController.text.trim().toLowerCase();
      final senha = senhaController.text;

      final resposta = await Supabase.instance.client.auth.signUp(
        email: email,
        password: senha,
        data: {
          'nome': nome,
        },
      );

      if (!mounted) return;

      if (resposta.user != null) {
        final mensagem = resposta.session == null
            ? 'Cadastro realizado! Verifique seu e-mail para confirmar a conta.'
            : 'Cadastro realizado com sucesso!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mensagem)),
        );

        nomeController.clear();
        emailController.clear();
        senhaController.clear();
        confirmarSenhaController.clear();
      }
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no cadastro: ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível realizar o cadastro: $e')),
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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 42,
            vertical: 25,
          ),

          child: Form(
            key: _formKey,

            child: Column(
              children: [

                Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 30),

                Text(
                  'Seja Bem-Vindo(a)',
                  textAlign: TextAlign.center,

                  style: GoogleFonts.montserrat(
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(
                  height: 55,
                ),

                Text(
                  'PRONTUÁRIO\nMÉDICO ÚNICO',
                  textAlign: TextAlign.center,

                  style: GoogleFonts.playfairDisplay(
                    fontSize: 39,
                    height: 1.15,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFBBD6FA),
                  ),
                ),

                const SizedBox(
                  height: 50,
                ),

                Text(
                  'CADASTRE-SE',
                  textAlign: TextAlign.center,

                  style: GoogleFonts.montserrat(
                    fontSize: 27,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),

                // ESPAÇO DO ÍCONE
                const SizedBox(
                  height: 65,
                ),

                // NOME
                campoTexto(
                  controller: nomeController,
                  hint: 'Insira seu nome:',
                  validator: (valor) {

                    if (valor == null ||
                        valor.trim().isEmpty) {

                      return 'Insira seu nome.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 42,
                ),

                // E-MAIL
                campoTexto(
                  controller: emailController,
                  hint: 'Insira seu e-mail:',
                  keyboardType: TextInputType.emailAddress,

                  validator: (valor) {

                    if (valor == null ||
                        valor.trim().isEmpty) {

                      return 'Insira seu e-mail.';
                    }

                    if (!valor.contains('@')) {
                      return 'Digite um e-mail válido.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 42,
                ),

                // SENHA
                campoTexto(
                  controller: senhaController,
                  hint: 'Crie sua senha:',
                  obscureText: true,

                  validator: (valor) {

                    if (valor == null ||
                        valor.isEmpty) {

                      return 'Crie sua senha.';
                    }

                    if (valor.length < 6) {

                      return 'A senha deve ter pelo menos 6 caracteres.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 42,
                ),

                // CONFIRMAÇÃO DA SENHA
                campoTexto(
                  controller: confirmarSenhaController,
                  hint: 'Confirme sua senha:',
                  obscureText: true,

                  validator: (valor) {

                    if (valor == null ||
                        valor.isEmpty) {

                      return 'Confirme sua senha.';
                    }

                    if (valor != senhaController.text) {

                      return 'As senhas não são iguais.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 25,
                ),

                
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        'Já tem uma conta? ',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: const Color(0xFFBBD6FA),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },

                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),

                      child: Text(
                        'Entrar',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: const Color(0xFFBBD6FA),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 55,
                ),

                // BOTÃO ENVIAR
                SizedBox(
                  width: 430,
                  height: 72,

                  child: ElevatedButton(
                    onPressed:
                        carregando ? null : cadastrarUsuario,

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFF4DB3F2),

                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(45),
                      ),
                    ),

                    child: carregando

                        ? const SizedBox(
                            width: 28,
                            height: 28,

                            child:
                                CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )

                        : Text(
                            'ENVIAR',

                            style:
                                GoogleFonts.montserrat(
                              fontSize: 30,
                              fontWeight:
                                  FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget campoTexto({
    required TextEditingController controller,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {

    return TextFormField(
      controller: controller,

      obscureText: obscureText,

      keyboardType: keyboardType,

      validator: validator,

      style: GoogleFonts.montserrat(
        fontSize: 20,
        color: Colors.black,
      ),

      decoration: InputDecoration(
        hintText: hint,

        hintStyle: GoogleFonts.montserrat(
          fontSize: 20,
          color: Colors.black,
        ),

        filled: true,

        fillColor: Colors.white,

        contentPadding:
            const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 23,
        ),

        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),

        enabledBorder:
            const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),

        focusedBorder:
            const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: 3,
          ),
        ),

        errorBorder:
            const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
      ),
    );
  }
}