import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:root_app/configs/configs.dart';
import 'package:root_app/constants/const_image.dart';
import 'package:root_app/models/profile/profile_model.dart';

class ProfilePicture extends StatelessWidget {
  // const ProfilePicture({super.key, required this.profile});

  // final ProfileModel profile;

  const ProfilePicture({
    super.key,
    required this.profile,
  });

  final ProfileModel profile;

  // ImageProvider _getProfileImage() {
  //   // First check if user has uploaded a profile picture
  //   if (profile.photoPath != null && profile.photoPath!.isNotEmpty) {
  //     return NetworkImage(
  //         Uri.parse(kBaseImagePath + profile.photoPath!).toString());
  //   }

  //   // If no profile picture, check gender for default image
  //   return profile.gender?.toLowerCase() == 'female'
  //       ? const AssetImage('assets/images/girl_profile_pic.png')
  //       : const AssetImage('assets/images/boy_profile.png');
  // }

  // ImageProvider _getProfileImage() {
  //   // For male users
  //   if (profile.gender?.toLowerCase() == 'male') {
  //     return const AssetImage('assets/images/boy_profile.png');
  //   }

  //   // For female users
  //   if (profile.gender?.toLowerCase() == 'female') {
  //     return const AssetImage('assets/images/girl_profile_pic.png');
  //   }

  //   // Default fallback (in case gender is null or different)
  //   return const AssetImage('assets/images/boy_profile.png');
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getProportionateScreenHeight(120),
      width: getProportionateScreenWidth(120),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // CircleAvatar(
          //   backgroundImage: NetworkImage(kBaseImagePath + profile.photoPath!),
          // ),
          CircleAvatar(
              // backgroundImage: profile.photoPath != null &&
              //         profile.photoPath!.isNotEmpty
              //     ? NetworkImage(
              //         Uri.parse(kBaseImagePath + profile.photoPath!).toString())
              //     : const AssetImage('assets/images/boy_profile.png')
              //         as ImageProvider,
              //backgroundImage: _getProfileImage(),

              backgroundImage: profile.gender?.toLowerCase() == 'female'
                  ? const AssetImage('assets/images/girl_profile_pic.jpg')
                  : const AssetImage('assets/images/boy_profile.png')),
          Positioned(
            right: getProportionateScreenWidth(-8),
            bottom: 0,
            child: SizedBox(
              height: getProportionateScreenHeight(38),
              width: getProportionateScreenWidth(38),
              child: TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFFF5F6F9)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                      side: const BorderSide(color: Colors.white),
                    ))),
                onPressed: () {},
                child: SvgPicture.asset("$kIconPath/Camera Icon.svg"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:root_app/configs/configs.dart';
// import 'package:root_app/constants/const_image.dart';
// import 'package:root_app/models/profile/profile_model.dart';
// import 'package:dio/dio.dart';

// class ProfilePicture extends StatefulWidget {
//   const ProfilePicture({super.key, required this.profile});
//   final ProfileModel profile;

//   @override
//   State<ProfilePicture> createState() => _ProfilePictureState();
// }

// class _ProfilePictureState extends State<ProfilePicture> {
//   File? _imageFile;
//   final ImagePicker _picker = ImagePicker();
//   bool _isUploading = false;

//   Future<void> _uploadImage() async {
//     if (_imageFile == null) return;

//     setState(() {
//       _isUploading = true;
//     });

//     try {
//       // Create form data
//       final formData = FormData.fromMap({
//         'file': await MultipartFile.fromFile(
//           _imageFile!.path,
//           filename: 'profile_picture.jpg',
//         ),
//       });

//       // Make API call to upload image
//       final response = await Dio().post(
//         'YOUR_UPLOAD_ENDPOINT', // Replace with your actual upload endpoint
//         data: formData,
//       );

//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile picture updated successfully')),
//         );
//         // Here you might want to update the profile model with the new image path
//         // widget.profile.photoPath = response.data['photoPath'];
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to upload image')),
//       );
//       print('Error uploading image: $e');
//     } finally {
//       setState(() {
//         _isUploading = false;
//       });
//     }
//   }

//   Future<void> _pickImage() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1000,
//         maxHeight: 1000,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         setState(() {
//           _imageFile = File(image.path);
//         });
//         await _uploadImage();
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to pick image')),
//       );
//       print('Error picking image: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: getProportionateScreenHeight(120),
//       width: getProportionateScreenWidth(120),
//       child: Stack(
//         fit: StackFit.expand,
//         clipBehavior: Clip.none,
//         children: [
//           CircleAvatar(
//             backgroundImage: _imageFile != null
//                 ? FileImage(_imageFile!) as ImageProvider
//                 : (widget.profile.photoPath != null &&
//                             widget.profile.photoPath!.isNotEmpty
//                         ? NetworkImage(Uri.parse(
//                                 kBaseImagePath + widget.profile.photoPath!)
//                             .toString())
//                         : const AssetImage('assets/images/boy_profile.png'))
//                     as ImageProvider,
//           ),
//           if (_isUploading)
//             const Positioned.fill(
//               child: CircularProgressIndicator(),
//             ),
//           Positioned(
//             right: getProportionateScreenWidth(-8),
//             bottom: 0,
//             child: SizedBox(
//               height: getProportionateScreenHeight(38),
//               width: getProportionateScreenWidth(38),
//               child: TextButton(
//                 style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStateProperty.all<Color>(const Color(0xFFF5F6F9)),
//                   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(50),
//                       side: const BorderSide(color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 onPressed: _isUploading ? null : _pickImage,
//                 child: _isUploading
//                     ? const SizedBox(
//                         height: 20,
//                         width: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : SvgPicture.asset("$kIconPath/Camera Icon.svg"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
