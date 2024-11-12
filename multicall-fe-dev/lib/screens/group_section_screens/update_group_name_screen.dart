import 'package:flutter/material.dart';
import 'package:multicall_mobile/controller/group_controller.dart';
import 'package:multicall_mobile/models/group.dart';
import 'package:multicall_mobile/utils/utils.dart';
import 'package:multicall_mobile/widget/custom_app_bar.dart';
import 'package:multicall_mobile/widget/custom_container.dart';
import 'package:multicall_mobile/widget/name_input_field.dart';
import 'package:multicall_mobile/widget/text_button.dart';
import 'package:provider/provider.dart';

class UpdateGroupNameScreen extends StatefulWidget {
  static const routeName = '/update-group-name-screen';

  final bool isFromEditGroupName;
  final bool isFromCreatingNewGroup;
  final String groupName;

  const UpdateGroupNameScreen({
    super.key,
    this.isFromEditGroupName = false,
    this.groupName = "New Group",
    this.isFromCreatingNewGroup = false,
  });

  @override
  UpdateGroupNameScreenState createState() => UpdateGroupNameScreenState();
}

class UpdateGroupNameScreenState extends State<UpdateGroupNameScreen> {
  late TextEditingController _groupNameController;
  late String strGroupName;
  String nameErrorText = "";

  @override
  void initState() {
    super.initState();
    strGroupName = widget.groupName;
    _groupNameController = TextEditingController(text: strGroupName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    if (args != null && args != strGroupName) {
      strGroupName = args;
      _groupNameController.text = strGroupName;
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        appBar: const CustomAppBar(
          leading: Text(
            "Group Name",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 21,
              color: Colors.black,
            ),
          ),
        ),
        body: Column(
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
                    child: NameInputField(
                      size: size,
                      label: "Enter a group name",
                      controller: _groupNameController,
                      maxLength: 15,
                      errorText: nameErrorText,
                      onChanged: (v) {
                        setState(() {
                          strGroupName = v;
                          nameErrorText = "";
                        });
                      },
                      onSubmit: (v) {
                        validateAndSave(context);
                      },
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
                    validateAndSave(context);
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
      ),
    );
  }

  void validateAndSave(BuildContext context) {
    if (strGroupName.length > 2) {
      if (widget.isFromEditGroupName) {
        //Call Edit Group API
        //Call Edit Group Member API
        //Fetch Group Details
        updateGroupName(strGroupName);
      } else if (widget.isFromCreatingNewGroup) {
        GroupController groupController =
            Provider.of<GroupController>(context, listen: false);
        if (groupController.groups
            .map((e) => e.name)
            .toList()
            .contains(strGroupName)) {
          nameErrorText =
              "Group name already exist, Please enter different name.";
          setState(() {});
        } else {
          groupController.changeNewGroupName(strGroupName);
          Navigator.pop(context);
        }
      }
    } else {
      showToast("Please enter valid group name");
    }
  }

  void updateGroupName(String newGroupName) {
    GroupController groupController =
        Provider.of<GroupController>(context, listen: false);
    Group activeGroup = groupController.groupInAction!;
    int totalIterations = (activeGroup.members.length / 2).ceil();

    groupController.requestToEditGroupDetails(
      groupMemberCount: activeGroup.members.length,
      oldGroupName: activeGroup.name,
      newGroupName: newGroupName,
      profileRefNumber: activeGroup.profileRefNum,
      totalIterations: totalIterations,
    );

    groupController.requestToEditGroupMembers(
      newGroupName,
      newGroupName,
      activeGroup.members,
    );

    groupController.fetchGroupMembers(activeGroup.groupId);

    Navigator.pop(context);
  }
}
