import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/constants.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  State<CustomBottomNavigationBar> createState() =>
      CustomBottomNavigationBarState();
}

class CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          key: shouldUseKey() ? navigation1 : null,
          icon: Icon(
            widget.selectedIndex == 0
                ? PhosphorIconsFill.phone
                : PhosphorIconsLight.phone,
          ),
          label: ('MultiCall'),
        ),
        BottomNavigationBarItem(
          key: shouldUseKey() ? navigation2 : null,
          icon: Icon(
            widget.selectedIndex == 1
                ? PhosphorIconsFill.usersFour
                : PhosphorIconsLight.usersFour,
          ),
          label: ('Groups'),
        ),
        BottomNavigationBarItem(
          key: shouldUseKey() ? navigation3 : null,
          icon: Icon(
            widget.selectedIndex == 2
                ? PhosphorIconsFill.gear
                : PhosphorIconsLight.gear,
          ),
          label: ('Settings'),
        ),
        BottomNavigationBarItem(
          key: shouldUseKey() ? navigation4 : null,
          icon: Icon(
            widget.selectedIndex == 3
                ? PhosphorIconsFill.currencyInr
                : PhosphorIconsLight.currencyInr,
          ),
          label: ('Premium'),
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.black,
      showUnselectedLabels: true,
      unselectedItemColor: const Color.fromRGBO(173, 181, 187, 1),
      iconSize: 24,
      onTap: widget.onItemTapped,
    );
  }

  bool shouldUseKey() {
    return !(PreferenceHelper.get(PrefUtils.watchedIntro) ?? false);
  }
}
