import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_icons.dart';

class MyStatus extends StatelessWidget {
  const MyStatus({super.key});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return
    // Column(
    // ///Status of current user
    // children: [
    //   SizedBox(height: mq.height * .05),
    //   Stack(
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.only(left: mq.width * .06),
    //         child: Container(
    //           decoration: BoxDecoration(
    //             shape: BoxShape.circle,
    //             border: Border.all(color: AppColors.whiteColor, width: 1),
    //           ),
    //           child: const CircleAvatar(
    //             radius: 30,
    //             backgroundColor: AppColors.whiteColor,
    //             backgroundImage: AssetImage("assets/images/random.png"),
    //           ),
    //         ),
    //       ),
    //
    //       ///Plus button
    //       Positioned(
    //         right: 0,
    //         bottom: 0,
    //         child: Container(
    //           decoration: BoxDecoration(
    //             color: AppColors.whiteColor,
    //             shape: BoxShape.circle,
    //             border: Border.all(color: AppColors.blackColor),
    //           ),
    //           child: InkWell(onTap: () {}, child: Icon(AppIcons.materialAdd)),
    //         ),
    //       ),
    //     ],
    //   ),
    Padding(
      padding: EdgeInsets.only(left: mq.width * .06),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.whiteColor, width: 1),
                ),
                child: CircleAvatar(
                  radius: 35,
                  backgroundColor: AppColors.whiteColor,
                  backgroundImage: AssetImage("assets/images/random.png"),
                ),
              ),

              Positioned(
                bottom: mq.width * .01,
                right: mq.width * .0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.whiteColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    AppIcons.materialAdd,
                    size: 20,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: mq.height * .01),
          const Text("My Status"),
        ],
      ),
    );
  }
}
