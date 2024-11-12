import 'package:flutter/material.dart';

class ProfileDetailRow extends StatelessWidget {
  const ProfileDetailRow({
    super.key,
    required this.title,
    this.subTitle,
    this.rightIcon,
    this.titleWeight,
    this.clickFunction,
    this.isNotLast = false,
  });

  final String title;
  final String? subTitle;
  final FontWeight? titleWeight;
  final IconData? rightIcon;
  final VoidCallback? clickFunction;
  final bool? isNotLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: titleWeight ?? FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                if (subTitle != null)
                  const SizedBox(
                    width: 5,
                  ),
                if (subTitle != null)
                  Text(
                    subTitle ?? "",
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
            if (rightIcon != null)
              InkWell(
                onTap: clickFunction != null ? clickFunction! : null,
                child: Icon(
                  rightIcon,
                  size: 30,
                  weight: 500,
                ),
              ),
          ],
        ),
        if (isNotLast ?? false)
          const Column(
            children: [
              SizedBox(
                height: 16,
              ),
              Divider(
                color: Color.fromRGBO(205, 211, 215, 1),
                thickness: 1,
                endIndent: 0,
                indent: 0,
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
      ],
    );
  }
}
