import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class CommonAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String titleText;
  final bool isCenterTitle;
  final VoidCallback? backButtonFun;
  final VoidCallback? appIconButtonFun;
  final bool appIconButtonAvailable;
  final Widget? buttonIcon;
  final bool isBackButtonNeeded;
  final bool? isAppBarTitleWidgetNeed;
  final Widget? appBarTitle;
  final Widget? actionWidget;

  const CommonAppBarWidget(
      {super.key,
        required this.titleText,
        this.isCenterTitle = false,
        this.backButtonFun,
        this.appIconButtonFun,
        this.appIconButtonAvailable = false,
        this.buttonIcon,
        this.isBackButtonNeeded = true,
        this.isAppBarTitleWidgetNeed = false,
        this.appBarTitle,
        this.actionWidget});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        titleSpacing: isBackButtonNeeded ? 0 : null,
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Colors.pinkAccent,
                      Colors.pinkAccent
                    ]))),
        titleTextStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
        automaticallyImplyLeading: false,
        actions: [
          actionWidget != null
              ? Padding(
            padding: const EdgeInsets.only(right: 10),
            child: actionWidget!,
          )
              : Container(),
          Visibility(
            visible: appIconButtonAvailable,
            child: Padding(
              padding: EdgeInsets.only(right: 8.r),
              child: IconButton(
                onPressed: () =>
                appIconButtonFun != null ? appIconButtonFun!() : () {},
                icon: SizedBox(height: 25.h, width: 25.w, child: buttonIcon),
              ),
            ),
          ),
        ],
        leading: !isBackButtonNeeded
            ? null
            : IconButton(
          splashColor: Colors.transparent,
          onPressed: backButtonFun != null
              ? () => backButtonFun!()
              : () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.r,
            color: Colors.white,
          ),
        ),
        centerTitle: isCenterTitle,
        title: isAppBarTitleWidgetNeed!
            ? appBarTitle ?? const SizedBox.shrink()
            : Text(
          titleText,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
