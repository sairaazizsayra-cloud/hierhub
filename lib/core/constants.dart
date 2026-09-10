class AppConstants {
  static const defaultCompanyLogo =
      'https://ui-avatars.com/api/?name=HireHub&background=5B4BFF&color=fff&size=128&bold=true';

  static const defaultAvatar = defaultCompanyLogo;

  static String companyLogo(String company) {
    final name = company.trim().isEmpty ? 'HireHub' : company.trim();
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}'
        '&background=5B4BFF&color=fff&size=128&bold=true';
  }
}
