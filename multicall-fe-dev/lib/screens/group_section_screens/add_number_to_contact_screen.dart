import 'dart:math' as math;
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/models/member_list_model.dart';
import 'package:multicall_mobile/models/message.dart';
import 'package:multicall_mobile/providers/instant_call_provider.dart';
import 'package:multicall_mobile/utils/ensure_permission.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class AddNumberToContactScreen extends StatefulWidget {
  final bool isFromCreatingNewGroup;
  final bool isFromEditGroupDetails;
  final bool isFromCallNow;
  GroupMembers? groupMember;
  MemberListModel? member;

  AddNumberToContactScreen({
    super.key,
    this.groupMember,
    this.member,
    this.isFromCreatingNewGroup = false,
    this.isFromEditGroupDetails = false,
    this.isFromCallNow = false,
  });

  @override
  State<AddNumberToContactScreen> createState() =>
      _AddNumberToContactScreenState();
}

class _AddNumberToContactScreenState extends State<AddNumberToContactScreen> {
  bool isButtonEnabled = false;
  final TextEditingController _nameController = TextEditingController(text: "");
  final FocusNode _nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Text("Add to Contact"),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: CustomStyledContainer(
                  width: size.width,
                  height: size.height - math.max(size.height * 0.28, 248),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        NameInputField(
                          size: size,
                          label: "Please enter a name",
                          controller: _nameController,
                          focusNode: _nameFocus,
                          onChanged: (v) {
                            isButtonEnabled = v.isNotEmpty;
                            setState(() {});
                          },
                          color: const Color(0XffCDD7D7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: TextButtonWithBG(
                  title: 'Add to Contact',
                  action: addMemberToContact,
                  color: const Color.fromRGBO(98, 180, 20, 1),
                  textColor: Colors.white,
                  fontSize: 16,
                  iconColor: Colors.white,
                  width: size.width,
                  isDisabled: !isButtonEnabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> addMemberToContact() async {
    await ensureContactPermission();

    Contact newContact = Contact(givenName: _nameController.text, phones: [
      Item(label: "Phone", value: widget.groupMember?.memberTelephone)
    ]);
    await ContactsService.addContact(newContact);

    GroupMembers updatedGroupMember = GroupMembers(
        memberName: _nameController.text,
        memberTelephone: widget.groupMember?.memberTelephone ?? "");

    MemberListModel updatedMember = MemberListModel(
        name: _nameController.text,
        phoneNumber: widget.member?.phoneNumber ?? "");

    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);

    if (widget.isFromCreatingNewGroup) {
      groupController.removeMemberFromNewGroup(widget.groupMember!);
      groupController.addMembersToNewGroup([updatedGroupMember]);
      Navigator.pop(context);
    } else if (widget.isFromEditGroupDetails) {
      Group tempGroup = groupController.groupInAction!;
      tempGroup.members.removeWhere((element) =>
          element.memberTelephone == widget.groupMember?.memberTelephone);
      tempGroup.members.add(updatedGroupMember);
      int totalIterations = (tempGroup.members.length / 2).ceil();

      groupController.requestToEditGroupDetails(
        groupMemberCount: tempGroup.members.length,
        oldGroupName: tempGroup.name,
        newGroupName: tempGroup.name,
        profileRefNumber: tempGroup.profileRefNum,
        totalIterations: totalIterations,
      );

      groupController.requestToEditGroupMembers(
        tempGroup.name,
        tempGroup.name,
        tempGroup.members,
      );
      Navigator.pop(context);
    } else if (widget.isFromCallNow) {
      var provider = Provider.of<InstantCallProvider>(context, listen: false);
      provider.removeMember(widget.member?.phoneNumber ?? "");
      provider.addMember(updatedMember);
      Navigator.pop(context);
    }
  }
}
