import 'package:flutter/material.dart';

import 'pages/cadastro_page.dart';

void main() {
  runApp(
    const ProntuarioApp(),
  );
}

class ProntuarioApp extends StatelessWidget {
  const ProntuarioApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Prontuário Médico Único',

      theme: ThemeData(
        useMaterial3: true,
      ),

      home: const CadastroPage(),
    );
  }
}