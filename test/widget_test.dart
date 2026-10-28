
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:hotel_booking_app/main.dart';

void main() {
  testWidgets('Favorite button updates its state', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => FavoritesProvider(),
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final isFavorite =
                  context.watch<FavoritesProvider>().isFavorite(1);

              return Scaffold(
                body: Column(
                  children: [
                    Text(isFavorite ? 'Favorite' : 'Not favorite'),
                    ElevatedButton(
                      onPressed: () {
                        context.read<FavoritesProvider>().toggleFavorite(1);
                      },
                      child: const Text('Toggle favorite'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Not favorite'), findsOneWidget);

    await tester.tap(find.text('Toggle favorite'));
    await tester.pump();

    expect(find.text('Favorite'), findsOneWidget);
  });
}
