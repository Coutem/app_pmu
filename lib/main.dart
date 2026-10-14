import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'pages/cadastro_page.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cifchwygwuiftfsqbvnf.supabase.co',
    publishableKey: 'sb_publishable_T8E-j12LNRANB57KieLzBg_qhk6_GWQ',
  );

  runApp(const ProntuarioApp());
}

class ProntuarioApp extends StatelessWidget {
  const ProntuarioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Prontuário Médico Único',
      theme: ThemeData(useMaterial3: true),
      home: const CadastroPage(),
    );
  }
}