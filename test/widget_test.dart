
import 'package:flutter_test/flutter_test.dart';
import 'package:app_pmu/main.dart';

void main() {
  testWidgets('Abre o aplicativo corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const ProntuarioApp());

    expect(find.text('Seja Bem-Vindo(a)'), findsOneWidget);
    expect(find.text('CADASTRE-SE'), findsOneWidget);
    expect(find.text('ENVIAR'), findsOneWidget);
  });
}