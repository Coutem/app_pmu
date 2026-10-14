
import 'package:supabase_flutter/supabase_flutter.dart';

import '../model/usuario.dart';

class PerfilService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Usuario?> buscarPerfil() async {
    final usuarioAuth = _supabase.auth.currentUser;

    if (usuarioAuth == null) {
      return null;
    }

    final resultado = await _supabase
        .from('perfis')
        .select()
        .eq('id', usuarioAuth.id)
        .maybeSingle();

    if (resultado == null) {
      return null;
    }

    return Usuario.fromMap(resultado);
  }

  Future<void> atualizarNome(String novoNome) async {
    final usuarioAuth = _supabase.auth.currentUser;

    if (usuarioAuth == null) {
      throw Exception('Nenhum usuário está autenticado.');
    }

    final nome = novoNome.trim();

    if (nome.isEmpty) {
      throw Exception('O nome não pode ficar vazio.');
    }

    await _supabase
        .from('perfis')
        .update({'nome': nome})
        .eq('id', usuarioAuth.id);
  }
}