import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:payment/Bloc/ProductsBloc.dart';
import 'package:payment/main.dart';
import 'package:payment/models/Product.dart';
import 'package:payment/screens/product.dart';
import 'package:payment/widgets/Product_Widget.dart';

void main() {
  testWidgets('UIStore test', (WidgetTester tester) async {
    await tester.runAsync(() async {
      await tester.pumpWidget(Splash());
      expect(find.byType(Splash), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      await Future.delayed(Duration(seconds:5 ));
      if(ProductCubit().state==LoadingState)
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
    else  if(ProductCubit().state==ProductSuccess)
     { expect(find.byType(AnimatedContainerProduct), findsAtLeast(1));
     await tester.press(find.byType(AnimatedContainerProduct));
     expect(find.byType(Product_Screen), findsAtLeast(1));
     }
    else if(ProductCubit().state==ProductFailed)
        expect(find.byType(TypewriterAnimatedText), findsOneWidget);
    });
  });
  group('ProductBloc', () {
    blocTest(
      'Products',
      build: () => ProductCubit(),
      expect: () => <Product>[]
    );
  });

}
