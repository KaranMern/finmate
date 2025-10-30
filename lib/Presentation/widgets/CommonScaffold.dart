import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'CommonAppBar.dart';
import 'CommonSearchbar.dart';

class CommonScaffoldWidget extends StatefulWidget {
  final Widget body;
  final String appBarTitle;
  final bool isSearchBoxNeeded;
  final bool isFilterNeeded;
  final bool isCenterTitle;
  final List<String>? searchTerms;
  final VoidCallback? appBackFunc;
  final VoidCallback? appIconButtonFun;
  final VoidCallback? filterButtonFun;
  final bool? appIconButtonNeeded;
  final Widget? appIconButton;
  final String? searchText;
  final TextEditingController? searchController;
  final FocusNode? searchFocusNode;
  final bool isBackButton;
  final Color bgColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final void Function(String?)? onChanged;
  final bool? resizeToAvoidBottomInset;
  final bool? isAppBarWidgetNeed;
  final Widget? appBarTitleWidget;
  final Widget? actionWidget;

  const CommonScaffoldWidget({
    super.key,
    required this.body,
    required this.appBarTitle,
    this.isSearchBoxNeeded = false,
    this.isFilterNeeded = false,
    this.isCenterTitle = false,
    this.appBackFunc,
    this.searchTerms,
    this.appIconButtonFun,
    this.appIconButtonNeeded = false,
    this.appIconButton,
    this.filterButtonFun,
    this.searchText = "",
    this.searchController,
    this.searchFocusNode,
    this.bgColor = Colors.white,
    this.isBackButton = false,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.onChanged,
    this.resizeToAvoidBottomInset = false,
    this.isAppBarWidgetNeed = false,
    this.appBarTitleWidget,
    this.actionWidget,
  });

  @override
  State<CommonScaffoldWidget> createState() => _CommonScaffoldWidgetState();
}

class _CommonScaffoldWidgetState extends State<CommonScaffoldWidget> {
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.searchTerms != null && widget.searchTerms!.isNotEmpty) {
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        setState(() {
          currentIndex = (currentIndex + 1) % widget.searchTerms!.length;
        });
      });
    }
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              Color.fromARGB(255, 73, 188, 198),
              Color.fromARGB(255, 62, 207, 176),
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.pinkAccent,
          resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          appBar: CommonAppBarWidget(
            actionWidget: widget.actionWidget,
            titleText: widget.appBarTitle,
            isCenterTitle: widget.isCenterTitle,
            backButtonFun: widget.appBackFunc,
            appIconButtonAvailable: widget.appIconButtonNeeded!,
            appIconButtonFun: widget.appIconButtonFun,
            buttonIcon: widget.appIconButton,
            isBackButtonNeeded: widget.isBackButton,
            appBarTitle: widget.appBarTitleWidget,
            isAppBarTitleWidgetNeed: widget.isAppBarWidgetNeed!,
          ),
          body: Column(
            children: [
              Visibility(
                visible: widget.isSearchBoxNeeded,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Color.fromARGB(255, 73, 188, 198),
                        Color.fromARGB(255, 62, 207, 176),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10.r,
                      right: 10.r,
                      bottom: 10.r,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SearchFieldWidget(
                            onChanged: widget.onChanged,
                            hintText:
                                (widget.searchTerms != null &&
                                    widget.searchTerms!.isNotEmpty)
                                ? 'Search By ${widget.searchTerms![currentIndex]}'
                                : 'Search',
                            searchController: widget.searchController,
                            searchFocusNode: widget.searchFocusNode,
                            // onChangeFunction: widget.onChangedFunction,
                          ),
                        ),
                        Visibility(
                          visible: widget.isFilterNeeded,
                          child: Padding(
                            padding: EdgeInsets.only(left: 10.r),
                            child: Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.r),
                                ),
                                color: Color(0xFFFFFFFF),
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: widget.filterButtonFun ?? () {},
                                  icon: Icon(Icons.filter),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.bgColor, //color: iconBackGroundColor2,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(28),
                      topLeft: Radius.circular(28),
                    ),
                  ),
                  child: widget.body,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
