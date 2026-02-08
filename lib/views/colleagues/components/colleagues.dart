import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'dart:math' as math;
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/colleagues/colleagues_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class Colleagues extends StatelessWidget {
  Colleagues({
    super.key,
  });
  final _colleaguesController = Get.find<ColleaguesController>();

  @override
  Widget build(BuildContext context) {
    return Obx((() => Column(
          children: [
            !_colleaguesController.isLoading.value
                ? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: getProportionateScreenHeight(5),
                          horizontal: getProportionateScreenWidth(20),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(10),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black26,
                              offset: Offset.fromDirection(math.pi * .5, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: (SizeConfig.screenWidth) * 0.75,
                              child: TextField(
                                style: const TextStyle(color: kTextColor),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  _colleaguesController.searchText.value =
                                      value;
                                  debugPrint(
                                      _colleaguesController.searchText.value);
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.all(15.0),
                                  hintText: "Search by Name or Id..",
                                  hintStyle: TextStyle(
                                    fontSize: kTextSize - 2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.search,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      Column(
                        children: List.generate(
                          _colleaguesController.colleagues.length,
                          (idx) {
                            return _colleaguesController.searchText.isEmpty ||
                                    _colleaguesController.colleagues[idx].text
                                        .toString()
                                        .toLowerCase()
                                        .contains(_colleaguesController
                                            .searchText
                                            .toLowerCase()) ||
                                    _colleaguesController
                                        .colleagues[idx].designationName
                                        .toString()
                                        .contains(_colleaguesController
                                            .searchText
                                            .toLowerCase()) ||
                                    _colleaguesController
                                        .colleagues[idx].officeEmail
                                        .toString()
                                        .contains(_colleaguesController
                                            .searchText
                                            .toLowerCase()) ||
                                    _colleaguesController.colleagues[idx]
                                        .toString()
                                        .isPhoneNumber
                                        .toString()
                                        .contains(_colleaguesController
                                            .searchText
                                            .toLowerCase())
                                ? Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: getProportionateScreenHeight(5),
                                      horizontal:
                                          getProportionateScreenWidth(20),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          getProportionateScreenHeight(10),
                                      horizontal:
                                          getProportionateScreenWidth(10),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 6,
                                          color: Colors.black26,
                                          offset: Offset.fromDirection(
                                              math.pi * .5, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width:
                                              (SizeConfig.screenWidth) * 0.60,
                                          height: 120,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppText(
                                                text:
                                                    '${_colleaguesController.colleagues[idx].text}',
                                                size: kTextSize - 2,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        5),
                                              ),
                                              AppText(
                                                text:
                                                    'Designation : ${_colleaguesController.colleagues[idx].designationName}',
                                                size: kTextSize - 4,
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        5),
                                              ),
                                              AppText(
                                                text:
                                                    'Email : ${_colleaguesController.colleagues[idx].officeEmail}',
                                                size: kTextSize - 4,
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        5),
                                              ),
                                              AppText(
                                                text:
                                                    'Mobile : ${_colleaguesController.colleagues[idx].officeMobile}',
                                                size: kTextSize - 4,
                                              ),
                                              SizedBox(
                                                height:
                                                    getProportionateScreenHeight(
                                                        5),
                                              ),
                                              AppText(
                                                text:
                                                    'Blood Group : ${_colleaguesController.colleagues[idx].bloodGroup}',
                                                size: kTextSize - 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                //print('CLICKED');
                                                var url = Uri.parse(
                                                    'tel://${_colleaguesController.colleagues[idx].officeMobile}');
                                                //await launch('tel://$url');
                                                debugPrint(url.toString());
                                                if (await canLaunchUrl(url)) {
                                                  await launchUrl(url);
                                                } else {
                                                  debugPrint(
                                                      'Could not launch $url');
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      getProportionateScreenWidth(
                                                          15),
                                                  vertical:
                                                      getProportionateScreenHeight(
                                                          2),
                                                ),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                  color: kPrimaryColor,
                                                ),
                                                child: const Column(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .phone_in_talk_rounded,
                                                      color: Colors.white,
                                                    ),
                                                    AppText(
                                                      text: "Call",
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      size: kTextSize - 4,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width:
                                                    getProportionateScreenWidth(
                                                        5)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  )
                : const CircularProgressIndicator()
          ],
        )));
  }
}
