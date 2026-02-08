import 'package:flutter/material.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/size_config.dart';
import 'dart:math' as math;
import 'package:root_app/constants/constants.dart';

class CustomTable extends StatelessWidget {
  final List<String> headerTitles;
  final List<int> colSizes;
  final List<List<String>> bodyData;

  const CustomTable({
    super.key,
    required this.colSizes,
    required this.headerTitles,
    required this.bodyData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
      ),
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(20),
        horizontal: getProportionateScreenWidth(20),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            blurRadius: 15,
            color: Colors.black26,
            offset: Offset.fromDirection(math.pi * .5, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomTableHeader(
            colSizes: colSizes,
            headerTitles: headerTitles,
          ),
          SizedBox(
            height: getProportionateScreenWidth(5),
          ),
          CustomTableBody(
            colSizes: colSizes,
            bodyData: bodyData,
          ),
        ],
      ),
    );
  }
}

class CustomTableHeader extends StatelessWidget {
  final List<String> headerTitles;
  final List<int> colSizes;

  const CustomTableHeader({
    super.key,
    required this.colSizes,
    required this.headerTitles,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        headerTitles.isNotEmpty ? headerTitles.length : 0,
        (idx) {
          return Expanded(
            flex: colSizes[idx],
            child: Container(
              padding: EdgeInsets.only(
                top: getProportionateScreenWidth(5),
                bottom: getProportionateScreenWidth(4),
                left: getProportionateScreenWidth(5),
              ),
              margin: EdgeInsets.only(
                right: idx < headerTitles.length ? 2 : 0,
              ),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: idx == 0
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      )
                    : idx == headerTitles.length - 1
                        ? const BorderRadius.only(
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          )
                        : null,
              ),
              child: AppText(
                text: headerTitles[idx],
                //overflow: TextOverflow.ellipsis,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                size: kTextSize - 4,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomTableBody extends StatelessWidget {
  final List<int> colSizes;
  final List<List<String>> bodyData;

  const CustomTableBody({
    super.key,
    required this.colSizes,
    required this.bodyData,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        bodyData.isNotEmpty ? bodyData.length : 0,
        (rowId) => Row(
          children: List<Widget>.generate(
            bodyData[rowId].isNotEmpty ? bodyData[rowId].length : 0,
            (idx) {
              return Expanded(
                flex: colSizes[idx],
                child: Container(
                  padding: EdgeInsets.only(
                    top: getProportionateScreenWidth(4),
                    bottom: getProportionateScreenWidth(4),
                    left: getProportionateScreenWidth(5),
                  ),
                  margin: EdgeInsets.only(
                    right: idx < bodyData[rowId].length ? 2 : 0,
                    bottom: getProportionateScreenWidth(5),
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xfff3f3f3),
                    borderRadius: idx == 0
                        ? const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          )
                        : idx == bodyData[rowId].length - 1
                            ? const BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              )
                            : null,
                  ),
                  child: AppText(
                    text: bodyData[rowId][idx],
                    color: kTextColor, // Colors.black,
                    fontWeight: FontWeight.bold,
                    size: kTextSize - 4,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
