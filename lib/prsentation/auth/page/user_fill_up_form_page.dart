import 'package:flutter/material.dart';
import 'package:job_seeker/core/theme/app_theme.dart';
import 'package:job_seeker/core/user_role.dart';
import 'package:job_seeker/domain/entity/user_entity.dart';
import 'package:job_seeker/prsentation/auth/provider/auth_provider.dart';
import 'package:job_seeker/prsentation/auth/widgets/auth_action_button.dart';
import 'package:job_seeker/prsentation/auth/widgets/auth_header_widget.dart';
import 'package:job_seeker/prsentation/auth/widgets/my_custom_input_filed.dart';
import 'package:provider/provider.dart';

class UserFillUpFormPage extends StatefulWidget {
  const UserFillUpFormPage({super.key});

  @override
  State<UserFillUpFormPage> createState() => _UserFillUpFormPageState();
}

class _UserFillUpFormPageState extends State<UserFillUpFormPage> {
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
  }

  @override
  void dispose() {
    super.dispose();

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
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          color: AppTheme.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 80,
              ),
              const AuthHeaderWidget(
                text: "Tell us about your job profile",
                title: "Profile",
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 700),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(60),
                            topRight: Radius.circular(60))),
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(
                            height: 60,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: AppTheme.primary.withValues(alpha: 0.18),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10))
                                ]),
                            child: Column(
                              children: [
                                // const Text("Name"),
                                MyCustomInputFiled(
                                    text: "Name",
                                    textEditingController: _nameController),
                                const SizedBox(
                                  height: 10,
                                ),
                                // const Text("Last Name"),
                                MyCustomInputFiled(
                                    text: "Last Name",
                                    textEditingController: _lastController),
                                const SizedBox(
                                  height: 10,
                                ),
                                // const Text("Phone No"),
                                MyCustomInputFiled(
                                    text: "Phone No",
                                    textEditingController: _phoneNoController),
                                const SizedBox(
                                  height: 10,
                                ),
                                // const Text("Address"),
                                MyCustomInputFiled(
                                    text: "Address",
                                    textEditingController: _addressController),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // const Text("Date of Birth"),
                                    Expanded(
                                      child: MyCustomInputFiled(
                                          text: "DD",
                                          textEditingController:
                                              _dobDDController),
                                    ),
                                    Expanded(
                                      child: MyCustomInputFiled(
                                          text: "MM",
                                          textEditingController:
                                              _dobMMController),
                                    ),
                                    Expanded(
                                      child: MyCustomInputFiled(
                                          text: "YYYY",
                                          textEditingController:
                                              _dobYYController),
                                    ),
                                  ],
                                ),
                                MyCustomInputFiled(
                                    text: context.watch<AuthProvider>().isRecruiter
                                        ? "Hiring role"
                                        : "Desired job profile",
                                    textEditingController:
                                        _jobProfileController),
                                const SizedBox(
                                  height: 10,
                                ),
                                MyCustomInputFiled(
                                    text: context.watch<AuthProvider>().isRecruiter
                                        ? "Skills you hire for"
                                        : "Job skills (Flutter, UI, ...)",
                                    textEditingController: _skillsController),
                                if (context.watch<AuthProvider>().isRecruiter) ...[
                                  const SizedBox(height: 10),
                                  MyCustomInputFiled(
                                    text: "Company name",
                                    textEditingController: _companyController,
                                  ),
                                  const SizedBox(height: 10),
                                  MyCustomInputFiled(
                                    text: "Organisation",
                                    textEditingController:
                                        _organisationController,
                                  ),
                                  const SizedBox(height: 10),
                                  MyCustomInputFiled(
                                    text: "Office / job location",
                                    textEditingController: _locationController,
                                  ),
                                  const SizedBox(height: 10),
                                  MyCustomInputFiled(
                                    text: "Company / hiring description",
                                    textEditingController:
                                        _descriptionController,
                                  ),
                                ],
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          AuthActionButton(
                              text: "Create Profile",
                              onPressed: () async {
                                if (_nameController.text.trim().isEmpty ||
                                    _lastController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter your first and last name',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final auth = context.read<AuthProvider>();
                                if (auth.isRecruiter &&
                                    _companyController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please enter your company name to post jobs',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                final dob =
                                    "${_dobDDController.text}-${_dobMMController.text}-${_dobYYController.text}";
                                try {
                                  await auth.createProfile(UserEntity(
                                    id: '',
                                    name: _nameController.text.trim(),
                                    email: '',
                                    skills: _skillsController.text.trim(),
                                    lastName: _lastController.text.trim(),
                                    address: _addressController.text.trim(),
                                    avatar: '',
                                    resumeUrl: '',
                                    dateOfBirth: dob,
                                    jobProfile:
                                        _jobProfileController.text.trim(),
                                    phoneNo: _phoneNoController.text.trim(),
                                    role: auth.user?.role ?? UserRole.jobSeeker,
                                    companyName: _companyController.text.trim(),
                                    organisation:
                                        _organisationController.text.trim().isEmpty
                                            ? _companyController.text.trim()
                                            : _organisationController.text.trim(),
                                    location: _locationController.text.trim(),
                                    description:
                                        _descriptionController.text.trim(),
                                  ));
                                  if (!context.mounted) return;
                                  Navigator.of(context)
                                      .popUntil((route) => route.isFirst);
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
