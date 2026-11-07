import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/main.dart';

void main() {
  testWidgets('Giriş ekranı açılır ve boş formda uyarılar gösterir', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Welcome Back'), findsOneWidget);

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(find.text('İsim alanı boş olamaz'), findsOneWidget);
    expect(find.text('Soyisim alanı boş olamaz'), findsOneWidget);
  });
}
