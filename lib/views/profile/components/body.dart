import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:root_app/components/components.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/configs/size_config.dart';
import 'package:root_app/constants/constants.dart';
import 'package:root_app/controllers/profile/profile_controller.dart';
import 'package:root_app/views/home/components/components.dart';

class Body extends StatelessWidget {
  Body({super.key});
  final _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(children: [
          const CustomAppBar(),
          Stack(children: [
            Container(
                height: SizeConfig.screenHeight * 0.10, color: kPrimaryColor),
            Obx(() => _profileController.isLoading.value
                ? SizedBox(
                    height: SizeConfig.screenHeight / 1.3,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(20)),
                      ProfilePicture(profile: _profileController.profile),
                      Container(
                        height: getProportionateScreenHeight(250),
                        width: double.infinity,
                        margin: EdgeInsets.all(getProportionateScreenWidth(20)),
                        padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenWidth(15),
                        ),
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(color: Colors.white),
                            children: [
                              TextSpan(
                                text:
                                    "${_profileController.profile.employeeName} (${_profileController.profile.employeeCode})\n",
                                style: TextStyle(
                                  fontSize:
                                      getProportionateScreenWidth(kTextSize),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "${_profileController.profile.designationName}\n",
                                style: TextStyle(
                                  fontSize: getProportionateScreenWidth(
                                      kLargeTextSize - 4),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: "\n",
                              ),
                              TextSpan(
                                text:
                                    "Department : ${_profileController.profile.departmentName}\n",
                                style: TextStyle(
                                  fontSize:
                                      getProportionateScreenWidth(kTextSize),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Outlet Name : ${_profileController.profile.branchName}\n",
                                style: TextStyle(
                                  fontSize:
                                      getProportionateScreenWidth(kTextSize),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Date of Joining : ${DateFormat('dd-MMM-yyyy').format(_profileController.profile.dateOfJoining!)}\n",
                                style: TextStyle(
                                  fontSize:
                                      getProportionateScreenWidth(kTextSize),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Email : ${_profileController.profile.officeEmail}\n",
                                style: TextStyle(
                                  fontSize:
                                      getProportionateScreenWidth(kTextSize),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Mobile : ${_profileController.profile.officeMobile}\n",
                                style: TextStyle(
                                  fontSize:
                                      getProportionateScreenWidth(kTextSize),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "JobType : ${_profileController.profile.jobType}\n",
                                style: TextStyle(
                                  fontSize:
                                      getProportionateScreenWidth(kTextSize),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "Gender : ${_profileController.profile.gender}\n",
                                style: TextStyle(
                                  fontSize:
                                      getProportionateScreenWidth(kTextSize),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
          ]),
        ]),
      ),
    );
  }
}
