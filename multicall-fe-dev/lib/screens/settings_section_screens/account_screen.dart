import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/account_controller.dart';
import 'package:multicall_mobile/utils/preference_helper.dart';
import 'package:multicall_mobile/widget/DualToneIcon.dart';
import 'package:multicall_mobile/widget/account_section_bottom_sheet.dart';
import 'package:multicall_mobile/widget/common/multicall_text_widget.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/horizontal_divider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account-screen';

  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  late List<String> emails = [];
  List<String> phoneNumberList = [];

  @override
  void initState() {
    super.initState();
    AccountController accountController = Provider.of<AccountController>(
      context,
      listen: false,
    );
    accountController.getUserPhoneNumberList();
    setState(() {
      emails = accountController.emails;
    });
  }

  int selectedContainerIndex = 0;

  void _selectContainer(int index) {
    setState(() {
      selectedContainerIndex = index;
    });
  }

  Widget buildHeading(String title, IconData icon, int index, Size size) {
    return GestureDetector(
      onTap: () => _selectContainer(index),
      child: Container(
        width: (size.width * 0.5) - 40,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: selectedContainerIndex == index
                  ? const Color(0XFF0086B5)
                  : const Color(0XFFADB5BB),
              width: 2.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: selectedContainerIndex == index
                  ? const Color(0XFF0086B5)
                  : Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selectedContainerIndex == index
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: selectedContainerIndex == index
                    ? const Color(0XFF0086B5)
                    : const Color(0XFFADB5BB),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildContainer(int index) {
    List<Widget> widgets = [];

    if (index == 0) {
      widgets = emails
          .map((email) =>
              accountDataListCard(email, emails.last == email, false))
          .toList();
    } else {
      widgets = phoneNumberList
          .map((phone) =>
              accountDataListCard(phone, phoneNumberList.last == phone, false))
          .toList();
    }

    return Visibility(
      visible: selectedContainerIndex == index,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                accountDataListCard(
                    index == 0
                        ? PreferenceHelper.get(PrefUtils.userEmail)
                        : PreferenceHelper.get(PrefUtils.userPhoneNumber),
                    false,
                    true),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgets,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AccountController>(context, listen: true);
    phoneNumberList = provider.userPhoneNumberList;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: CustomAppBar(
        leading: const Text("Account"),
        trailing: DualToneIcon(
          iconSrc: PhosphorIconsDuotone.plusCircle,
          duotoneSecondaryColor: const Color.fromRGBO(0, 134, 181, 1),
          color: Colors.black,
          size: 16,
          padding: const Padding(padding: EdgeInsets.all(7)),
          press: () {
            showModalBottomSheet<void>(
                isScrollControlled: true,
                showDragHandle: true,
                context: context,
                builder: (BuildContext context) {
                  return const AccountSectionBottomSheet();
                });
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomStyledContainer(
                height: double.infinity,
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildHeading(
                          'Email IDs',
                          PhosphorIconsRegular.envelopeSimple,
                          0,
                          size,
                        ),
                        buildHeading(
                          'Mobile Numbers',
                          PhosphorIconsRegular.deviceMobile,
                          1,
                          size,
                        ),
                      ],
                    ),
                    buildContainer(0),
                    buildContainer(1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget phoneNumberCell(String phoneNumber) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
                child: MultiCallTextWidget(
                  text: "+91 $phoneNumber",
                  textColor: const Color(0XFF101315),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        const HorizontalDivider(
          color: Color.fromRGBO(205, 211, 215, 1),
        ),
      ],
    );
  }

  Widget accountDataListCard(String itemName, bool isLast, bool isRegistered) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    itemName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0XFF101315),
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  //const Spacer(),
                  if (isRegistered)
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0XFFDEF6FF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                      ),
                      width: 80,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: const Center(
                        child: Text(
                          "Registered",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0XFF0086B5),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            color: Color(0XFFCDD3D7),
            thickness: 1,
          ),
      ],
    );
  }
}

class emailDetailCard extends StatelessWidget {
  const emailDetailCard({
    super.key,
    required this.email,
    this.isRegistered = false,
  });

  final String email;
  final bool isRegistered;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          email,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        if (isRegistered)
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(222, 246, 255, 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              "Registered",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(0, 134, 181, 1),
              ),
            ),
          )
      ],
    );
  }
}
