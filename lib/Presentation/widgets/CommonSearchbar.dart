import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchFieldWidget extends StatefulWidget {
  final bool? readOnly;
  final TextEditingController? searchController;
  final List<String>? searchHintTextList;
  final String? hintText;
  final FocusNode? searchFocusNode;
  final VoidCallback? onTap;
  final void Function(String?)? onChanged;
  final void Function(String?)? onSubmitted;

  const SearchFieldWidget({
    super.key,
    this.searchController,
    this.searchHintTextList,
    this.searchFocusNode,
    this.onChanged,
    this.onTap,
    this.hintText = 'What are you looking for',
    this.onSubmitted,
    this.readOnly = false,
  });

  @override
  State<SearchFieldWidget> createState() => _SearchFieldWidgetState();
}

class _SearchFieldWidgetState extends State<SearchFieldWidget> {
  int _currentHintIndex = 0;
  Timer? _timer;
  late List<String> searchHints;

  @override
  void initState() {
    super.initState();
    _startHintRotation();
  }

  void _startHintRotation() {
    searchHints = widget.searchHintTextList ?? [];
    if (searchHints.isEmpty) {
      return;
    }
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentHintIndex = (_currentHintIndex + 1) % searchHints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    //widget.searchController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: TextField(
        cursorColor: Color(0xFF03A3A4),
        textInputAction: TextInputAction.search,
        readOnly: widget.readOnly!,
        onSubmitted: (String value) {
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(value);
          }
        },
        enabled: true,
        onTap: widget.onTap != null
            ? () {
                FocusScope.of(context).unfocus();
                widget.onTap!();
              }
            : null,
        onChanged: widget.onChanged,
        textAlign: TextAlign.start,
        controller: widget.searchController,
        autofocus: false,
        focusNode: widget.searchFocusNode,
        decoration: InputDecoration(
          suffixIcon: Visibility(
            visible: widget.searchController!.text.isNotEmpty,
            child: IconButton(
              onPressed: () {
                widget.searchController!.clear();
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(Icons.clear),
            ),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 14.r, right: 5.r),
            child: SizedBox(
              //height: 2.h,
              width: 1.w,
              child: Icon(Icons.search),
            ),
          ),
          contentPadding: EdgeInsets.all(10.r),
          hintText: searchHints.isNotEmpty
              ? "${widget.hintText} ${searchHints[_currentHintIndex]}"
              : widget.hintText,
          hintStyle: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(151, 149, 149, 1),
          ),
          fillColor: Color.fromRGBO(242, 241, 247, 1),
          filled: true,
          focusColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 0.7.sp, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(width: 0.7.sp, color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(9.r)),
          ),
        ),
      ),
    );
  }
}
