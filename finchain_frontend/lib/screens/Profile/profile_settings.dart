import 'package:finchain_frontend/utils/theme.dart';
import 'package:finchain_frontend/modules/finchain_appbar.dart';
import 'package:finchain_frontend/modules/loading_overlay.dart';
import 'package:finchain_frontend/modules/show_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:finchain_frontend/providers/user_provider.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late String _name = '';
  late String? _email;
  bool isLoading = false;
  ThemeData theme = AppTheme.getTheme();
  Map<String, String> updatedFields = {};

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user;
    if (user != null) {
      setState(() {
        _name = user.name;
        _email = user.email;

        _nameController.text = _name;
        _emailController.text = _email ?? '';
      });
    }
  }

  Future<void> _saveChanges() async {
    if (updatedFields.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.updateUser(
        name: updatedFields['name'],
        email: updatedFields['email'],
      );

      if (mounted) {
        ShowMessage.success(
            context, 'Profile updated successfully! Please refresh!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ShowMessage.error(context, 'Failed to update profile');
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _editField(String title, String initialValue, String field) {
    TextEditingController controller;
    switch (field) {
      case 'name':
        controller = _nameController;
        break;
      case 'email':
        controller = _emailController;
        break;
      default:
        return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: theme.primaryColor, width: 2),
              ),
              labelText: title,
              labelStyle: TextStyle(color: theme.primaryColor),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(color: theme.primaryColor),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final newValue = controller.text;
                if (newValue != initialValue) {
                  setState(() {
                    updatedFields[field] = newValue;
                  });
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    double widthFactor = screenWidth / 428;
    double heightFactor = screenHeight / 926;

    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        final isLoading = userProvider.isLoading;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const FinchainAppBar(
            title: "Profile Settings",
            backButtonExists: true,
          ),
          body: LoadingOverlay(
            isLoading: isLoading,
            message: "Updating profile...",
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(widthFactor * 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildEditableRow(
                      title: 'Name',
                      value: updatedFields['name'] ?? user.name,
                      onEdit: () => _editField('Name', user.name, 'name'),
                      theme: theme,
                      widthFactor: widthFactor,
                      isEdited: updatedFields.containsKey('name'),
                    ),
                    Divider(color: theme.primaryColor.withOpacity(0.2)),
                    _buildEditableRow(
                      title: 'Email',
                      value: updatedFields['email'] ?? user.email ?? 'Not set',
                      onEdit: () =>
                          _editField('Email', user.email ?? '', 'email'),
                      theme: theme,
                      widthFactor: widthFactor,
                      isEdited: updatedFields.containsKey('email'),
                    ),
                    if (updatedFields.isNotEmpty) ...[
                      SizedBox(height: widthFactor * 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _saveChanges,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            padding: EdgeInsets.symmetric(
                              horizontal: widthFactor * 30,
                              vertical: widthFactor * 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Save All Changes',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            height: heightFactor * 40,
            color: theme.primaryColor,
          ),
        );
      },
    );
  }

  Widget _buildEditableRow({
    required String title,
    required String value,
    required VoidCallback onEdit,
    required ThemeData theme,
    required double widthFactor,
    required bool isEdited,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: widthFactor * 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: widthFactor * 14,
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: widthFactor * 5),
                Text(
                  value.isEmpty ? 'Not set' : value,
                  style: TextStyle(
                    fontSize: widthFactor * 16,
                    fontWeight: FontWeight.w600,
                    color: value.isEmpty ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (isEdited)
                Icon(
                  Icons.edit_note,
                  color: Colors.green,
                  size: widthFactor * 20,
                ),
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: theme.primaryColor,
                  size: widthFactor * 20,
                ),
                onPressed: onEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
