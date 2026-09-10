import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_seeker/core/widget/my_custom_icon_button.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/auth/widgets/my_custom_input_filed.dart';
import 'package:provider/provider.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _lastController;
  late TextEditingController _phoneNoController;
  late TextEditingController _jobProfileController;
  late TextEditingController _skillsController;
  late TextEditingController _addressController;
  late TextEditingController _dobDDController;
  late TextEditingController _dobMMController;
  late TextEditingController _dobYYController;
  late TextEditingController _companyController;
  late TextEditingController _organisationController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _lastController = TextEditingController();
    _phoneNoController = TextEditingController();
    _jobProfileController = TextEditingController();
    _skillsController = TextEditingController();
    _addressController = TextEditingController();
    _dobDDController = TextEditingController();
    _dobMMController = TextEditingController();
    _dobYYController = TextEditingController();
    _companyController = TextEditingController();
    _organisationController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();

    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _nameController.text = user.name;
      _lastController.text = user.lastName;
      _phoneNoController.text = user.phoneNo;
      _addressController.text = user.address;
      _jobProfileController.text = user.jobProfile;
      _skillsController.text = user.skills;
      _companyController.text = user.companyName;
      _organisationController.text = user.organisation;
      _locationController.text = user.location;
      _descriptionController.text = user.description;

      if (user.dateOfBirth.isNotEmpty) {
        final parts = user.dateOfBirth.split('-');
        if (parts.length == 3) {
          _dobDDController.text = parts[0];
          _dobMMController.text = parts[1];
          _dobYYController.text = parts[2];
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastController.dispose();
    _phoneNoController.dispose();
    _jobProfileController.dispose();
    _skillsController.dispose();
    _addressController.dispose();
    _dobDDController.dispose();
    _dobMMController.dispose();
    _dobYYController.dispose();
    _companyController.dispose();
    _organisationController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;
    if (user == null) return;

    final dob =
        '${_dobDDController.text}-${_dobMMController.text}-${_dobYYController.text}';

    try {
      await authProvider.updateProfile(
        user.copyWith(
          name: _nameController.text.trim(),
          lastName: _lastController.text.trim(),
          phoneNo: _phoneNoController.text.trim(),
          address: _addressController.text.trim(),
          dateOfBirth: dob,
          jobProfile: _jobProfileController.text.trim(),
          skills: _skillsController.text.trim(),
          companyName: _companyController.text.trim(),
          organisation: _organisationController.text.trim(),
          location: _locationController.text.trim(),
          description: _descriptionController.text.trim(),
        ),
      );

      if (!mounted) return;
      Fluttertoast.showToast(msg: 'Profile updated successfully');
      Navigator.pop(context);
    } catch (_) {
      Fluttertoast.showToast(
        msg: authProvider.error ?? 'Failed to update profile',
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: Colors.deepPurple,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    MyCustomIconButton(
                      icon: Icons.arrow_back,
                      callback: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        MyCustomInputFiled(
                          text: 'Name',
                          textEditingController: _nameController,
                        ),
                        const SizedBox(height: 10),
                        MyCustomInputFiled(
                          text: 'Last Name',
                          textEditingController: _lastController,
                        ),
                        const SizedBox(height: 10),
                        MyCustomInputFiled(
                          text: 'Phone No',
                          textEditingController: _phoneNoController,
                        ),
                        const SizedBox(height: 10),
                        MyCustomInputFiled(
                          text: 'Address',
                          textEditingController: _addressController,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: MyCustomInputFiled(
                                text: 'DD',
                                textEditingController: _dobDDController,
                              ),
                            ),
                            Expanded(
                              child: MyCustomInputFiled(
                                text: 'MM',
                                textEditingController: _dobMMController,
                              ),
                            ),
                            Expanded(
                              child: MyCustomInputFiled(
                                text: 'YYYY',
                                textEditingController: _dobYYController,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        MyCustomInputFiled(
                          text: 'Job Profile',
                          textEditingController: _jobProfileController,
                        ),
                        const SizedBox(height: 10),
                        MyCustomInputFiled(
                          text: 'Job skills',
                          textEditingController: _skillsController,
                        ),
                        if (context.watch<AuthProvider>().isRecruiter) ...[
                          const SizedBox(height: 10),
                          MyCustomInputFiled(
                            text: 'Company name',
                            textEditingController: _companyController,
                          ),
                          const SizedBox(height: 10),
                          MyCustomInputFiled(
                            text: 'Organisation',
                            textEditingController: _organisationController,
                          ),
                          const SizedBox(height: 10),
                          MyCustomInputFiled(
                            text: 'Job location',
                            textEditingController: _locationController,
                          ),
                          const SizedBox(height: 10),
                          MyCustomInputFiled(
                            text: 'Hiring description',
                            textEditingController: _descriptionController,
                          ),
                        ],
                        const SizedBox(height: 40),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed:
                                  authProvider.isLoading ? null : _handleUpdate,
                              child: authProvider.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Update Profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
