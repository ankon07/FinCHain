import 'package:finchain_frontend/utils/api_service.dart';
import 'package:flutter/material.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late String _firstName;
  late String _lastName;
  late String _email;

  final TextEditingController _controller = TextEditingController();
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future<void> getUser() async {
    final data = await apiService.fetchUserData();
    setState(() {
      _firstName = data["first_name"];
      _lastName = data["last_name"];
      _email = data["email"];
    });
  }

  void _editField(String title, String initialValue, Function(String) onSave) {
    _controller.text = initialValue;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $title'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: title,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(_controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditableRow(
              title: 'First Name',
              value: _firstName,
              onEdit: () => _editField('First Name', _firstName, (newValue) {
                setState(() {
                  _firstName = newValue;
                });
              }),
            ),
            const Divider(),
            _buildEditableRow(
              title: 'Last Name',
              value: _lastName,
              onEdit: () => _editField('Last Name', _lastName, (newValue) {
                setState(() {
                  _lastName = newValue;
                });
              }),
            ),
            const Divider(),
            _buildEditableRow(
              title: 'Email',
              value: _email,
              onEdit: () => _editField('Email', _email, (newValue) {
                setState(() {
                  _email = newValue;
                });
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableRow({
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
