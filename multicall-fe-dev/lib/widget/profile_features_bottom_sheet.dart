import 'package:flutter/material.dart';
import 'package:multicall_mobile/models/profile.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/widget/text_button.dart';

class ProfileFeaturesBottomSheet extends StatelessWidget {
  final VoidCallback closeFunc;
  final Profile profile;

  const ProfileFeaturesBottomSheet({
    super.key,
    required this.closeFunc,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 485,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Profile Features",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: const Color.fromRGBO(205, 211, 215, 1),
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(237, 240, 242, 1),
                    Color.fromRGBO(221, 225, 228, 1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: [0.5, 0.5],
                ),
              ),
              child: Column(
                children: [
                  _buildTableRow('Type', accountTypes[profile.accountType - 1]),
                  _buildDivider(),
                  _buildTableRow('Call Size', '${profile.profileSize} Members'),
                  _buildDivider(),
                  _buildTableRow(
                      'ISD', profile.allowStatusISD == 1 ? 'On' : "Off"),
                  _buildDivider(),
                  _buildTableRow('Recording/Playback',
                      profile.facilityElement == 3 ? 'On' : "Off"),
                  _buildDivider(),
                  _buildTableRow('Scheduling',
                      profile.facilityElement == 3 ? 'On' : "Off"),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
            TextButtonWithBG(
              title: 'OK',
              action: closeFunc,
              color: const Color.fromRGBO(0, 134, 181, 1),
              textColor: Colors.white,
              fontSize: 16,
              // iconData: iconData,
              iconColor: Colors.white,
              width: size.width,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableRow(String leftText, String rightText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
              child: Text(
                leftText,
                style: const TextStyle(
                  color: Color.fromRGBO(110, 122, 132, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Text(
                rightText,
                style: const TextStyle(
                  color: Color.fromRGBO(16, 19, 21, 1),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      color: const Color.fromRGBO(205, 211, 215, 1),
      height: 1,
    );
  }
}
