import 'package:flutter/material.dart';
import 'package:root_app/configs/size_config.dart';
import 'section_title.dart';

class PopularProducts extends StatelessWidget {
  const PopularProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(title: "Popular Products", press: () {}),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // ...List.generate(
              //   demoProducts.length,
              //   (index) {
              //     if (demoProducts[index].isPopular)
              //       return ProductCard(product: demoProducts[index]);

              //     return SizedBox
              //         .shrink();
              //         // here by default width and height is 0
              //   },
              // ),
              // SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        )
      ],
    );
  }
}
