import 'package:finmate/Presentation/widgets/CommonScaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../Notification/LocalNotification.dart';
import '../../main.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CommonScaffoldWidget(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16).r,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10).r,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              //backgroundColor: KConstantColors.whiteColor,
                              child: ClipOval(
                                child: auth.currentUser?.photoURL != null
                                    ? Image.network(
                                  auth.currentUser!.photoURL!,
                                  fit: BoxFit.cover,
                                  width: 50.w,
                                  height: 50.h,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.r,
                                        value: loadingProgress
                                            .expectedTotalBytes !=
                                            null
                                            ? loadingProgress
                                            .cumulativeBytesLoaded /
                                            (loadingProgress
                                                .expectedTotalBytes ??
                                                1)
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) => Icon(
                                    Icons.person,
                                    size: 22.sp,
                                    color: Colors.black,
                                  ),
                                )
                                    : Icon(
                                  Icons.person,
                                  size: 22
                                      .sp, // Slightly increased for better proportion
                                  color: Colors.blue[800]!,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              // Ensure text doesn't overflow
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${auth.currentUser!.displayName}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.visible,
                                  ),
                                  Text(
                                      "${auth.currentUser!.email}",
                                    style: Theme.of(context).textTheme.bodyMedium,
                                    softWrap: true,
                                    overflow:
                                    TextOverflow.ellipsis, // Prevents overflow
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: ()async{
                          await LocalNotification.showInstantNotification(title: 'welcome', body: 'sucessfully');
                        },
                        icon: Icon(
                          Icons.edit_note_outlined,
                        ),
                        style: Theme.of(context).iconButtonTheme.style,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      appBarTitle: 'Profile',
    );
  }
}
