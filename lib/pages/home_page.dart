import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> sair(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = Supabase.instance.client.auth.currentUser;

    final nome = usuario?.userMetadata?['nome'] as String?;

    return Scaffold(
      backgroundColor: const Color(0xFF073F82),
      appBar: AppBar(
        backgroundColor: const Color(0xFF073F82),
        foregroundColor: Colors.white,
        title: const Text('Prontuário Médico Único'),
        actions: [
          IconButton(
            onPressed: () => sair(context),
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Espaço reservado para a logo.
                const Icon(
                  Icons.medical_information_outlined,
                  size: 80,
                  color: Colors.white,
                ),

                const SizedBox(height: 24),

                Text(
                  'Olá${nome != null && nome.isNotEmpty ? ', $nome' : ''}!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Bem-vindo(a) ao seu prontuário médico.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 30),

                const Card(
                  child: ListTile(
                    leading: Icon(Icons.history),
                    title: Text('Histórico de consultas'),
                    subtitle: Text(
                      'Essa funcionalidade será implementada '
                      'na próxima etapa.',
                    ),
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