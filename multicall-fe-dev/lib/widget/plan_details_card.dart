import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/dashed_divider.dart';
import 'package:multicall_mobile/widget/text_widget.dart';

class PlanDetailsCard extends StatelessWidget {
  const PlanDetailsCard({
    super.key,
    required this.price,
    required this.validity,
    required this.callSize,
    required this.callType,
    required this.buyAction,
    required this.title,
  });

  final String title;
  final String price;
  final String validity;
  final String callSize;
  final String callType;
  final VoidCallback buyAction;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlanDetailsTopSection(
          title: title,
        ),
        PlanDetailsBottomSection(
          size: size,
          price: price,
          validity: validity,
          callSize: callSize,
          callType: callType,
          buyAction: buyAction,
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}

class PlanDetailsBottomSection extends StatelessWidget {
  const PlanDetailsBottomSection({
    super.key,
    required this.size,
    required this.price,
    required this.validity,
    required this.callSize,
    required this.callType,
    required this.buyAction,
  });

  final Size size;
  final String price;
  final String validity;
  final String callSize;
  final String callType;
  final VoidCallback buyAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(8.0),
          bottomRight: Radius.circular(8.0),
          bottomLeft: Radius.circular(8.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: GlobalText(
                    alignment: Alignment.topLeft,
                    text: price,
                    textAlign: TextAlign.left,
                    color: const Color.fromRGBO(16, 19, 21, 1),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    padding: EdgeInsets.zero,
                  ),
                ),
                PlanDetails(
                  title: "Validity",
                  content: validity,
                ),
                PlanDetails(
                  title: "Call Size",
                  content: callSize,
                ),
              ],
            ),
          ),
          const DashedDivider(
            height: 2,
            dashWidth: 5,
            dashGap: 3,
            color: Color.fromRGBO(205, 211, 215, 1),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GlobalText(
                  alignment: Alignment.topLeft,
                  text: callType,
                  textAlign: TextAlign.left,
                  color: const Color.fromRGBO(16, 19, 21, 1),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  padding: EdgeInsets.zero,
                  fontFamily: "Lato",
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.resolveWith(
                      (states) => const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                    ),
                  ),
                  onPressed: buyAction,
                  child: const GlobalText(
                    alignment: Alignment.topLeft,
                    text: "Buy Now",
                    textAlign: TextAlign.left,
                    color: Color.fromRGBO(98, 180, 20, 1),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    padding: EdgeInsets.zero,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlanDetailsTopSection extends StatelessWidget {
  const PlanDetailsTopSection({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 80, 109, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8.0),
          topRight: Radius.circular(8.0),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class PlanDetails extends StatelessWidget {
  const PlanDetails({
    super.key,
    required this.title,
    required this.content,
  });

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 75,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlobalText(
            alignment: Alignment.topLeft,
            text: title,
            textAlign: TextAlign.left,
            color: const Color.fromRGBO(78, 93, 105, 1),
            fontSize: 12,
            fontWeight: FontWeight.w600,
            padding: EdgeInsets.zero,
          ),
          GlobalText(
            alignment: Alignment.topLeft,
            text: content,
            textAlign: TextAlign.left,
            color: const Color.fromRGBO(16, 19, 21, 1),
            fontSize: 14,
            fontWeight: FontWeight.w600,
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}
