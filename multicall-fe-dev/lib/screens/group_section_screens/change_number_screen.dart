import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/row_option_selection.dart';
import 'package:multicall_mobile/widget/text_button.dart';

class ChangeNumberScreen extends StatefulWidget {
  static const routeName = '/change-number-screen';

  const ChangeNumberScreen({super.key});

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

String normalizePhoneNumber(String phoneNumber) {
  return phoneNumber.replaceAll(RegExp(r'\D'), '');
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {
  late String selectedOption;
  bool isLoading = true;
  bool isEmpty = false;

  List<String> options = [];

  Set<String> uniqueValues = <String>{};

  Future<void> fetchContacts(phoneNumber) async {
    try {
      final list = await ContactsService.getContactsForPhone(phoneNumber);

      for (var contact in list) {
        contact.phones?.forEach((phone) {
          if (phone.value != null) {
            uniqueValues.add(normalizePhoneNumber(phone.value!));
          }
        });
      }
      List<String> newList = uniqueValues.toList();

      setState(() {
        options.addAll(newList);
        isLoading = false;
        isEmpty = newList.isEmpty;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        isEmpty = true;
      });
      debugPrint("Failed to fetch contacts: $e");
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Object args = ModalRoute.of(context)?.settings.arguments ?? {};
    final String selectedNumber = (args as Map)['selectedNumber'] ?? '';
    uniqueValues.add(normalizePhoneNumber(selectedNumber));
    selectedOption = selectedNumber;
    setState(() {});
    fetchContacts(selectedNumber);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: const CustomAppBar(
        leading: SizedBox(
          height: 50,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Change Number",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 21,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: CustomStyledContainer(
                      height: double.infinity,
                      width: size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView(
                          children: options.asMap().entries.map((entry) {
                            int idx = entry.key;
                            String option = entry.value;
                            return OptionSelector(
                              title: processPhoneNumber(option),
                              isLeftIconReq: false,
                              isSelected: processPhoneNumber(option) ==
                                  processPhoneNumber(selectedOption),
                              leftIconClick: () {},
                              clickFunction: () {
                                setState(() {
                                  selectedOption = option;
                                });
                              },
                              isLastItem: idx == options.length - 1,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 24.0,
                      right: 24.0,
                      top: 12.0,
                      bottom: 12.0 + MediaQuery.of(context).padding.bottom,
                    ),
                    child: TextButtonWithBG(
                      title: 'Save',
                      action: () {
                        Navigator.pop(context, selectedOption);
                      },
                      color: const Color.fromRGBO(98, 180, 20, 1),
                      textColor: Colors.white,
                      fontSize: 16,
                      iconColor: Colors.white,
                      width: size.width,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
