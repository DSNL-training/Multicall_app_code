import 'package:flutter/material.dart';
import 'package:multicall_mobile/widget/action_row.dart';
import 'package:multicall_mobile/widget/stars_row.dart';

class RatingBottomSheet extends StatefulWidget {
  final VoidCallback cancelFunc;
  final Function okFunc;

  const RatingBottomSheet({
    super.key,
    required this.cancelFunc,
    required this.okFunc,
  });

  @override
  State<RatingBottomSheet> createState() => _RatingBottomSheetState();
}

class _RatingBottomSheetState extends State<RatingBottomSheet> {
  double rating = 5;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                children: [
                  const Text(
                    "Rate your calling experience with MultiCall",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  StarRating(
                    rating: rating,
                    onRatingChanged: (rating) =>
                        setState(() => this.rating = rating),
                    color: const Color.fromRGBO(251, 191, 36, 1),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            const Divider(
              color: Color.fromRGBO(205, 211, 215, 1),
            ),
            ActionRow(
              cancelFunction: widget.cancelFunc,
              approveFunction: () => widget.okFunc(rating.toInt()),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ],
    );
  }
}
