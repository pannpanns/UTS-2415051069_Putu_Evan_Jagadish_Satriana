import 'package:flutter_test/flutter_test.dart';
import 'package:tuntas_kuliah/main.dart';

void main() {
  testWidgets('TuntasKuliah dashboard renders correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TuntasKuliahApp());

    expect(find.text('TuntasKuliah'), findsOneWidget);
    expect(find.text('Halo, Mahasiswa!'), findsOneWidget);
    expect(find.text('Tugas Minggu Ini'), findsOneWidget);
  });
}
