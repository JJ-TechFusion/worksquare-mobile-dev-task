class ApiEndpoints {
  static const baseUrl = 'https://uphold.agnosyshealth.com';

  static const _basePath = '/api/v1';

  static const login = '$_basePath/auth/login';
  static const register = '$_basePath/user';
  static const logout = '$_basePath/auth/logout';
  static const me = '$_basePath/user/me';

  static const user = '$_basePath/user';
  static const updatePassword = '$_basePath/auth/update-password';
  static const userDashboard = '$_basePath/user/dashboard';
  static const partners = '$_basePath/user/partners';

  static const patient = '$_basePath/patient';

  static const appointment = '$_basePath/appointment';
  static const forgotPassword = '$_basePath/auth/forgot-password';
  static const resetPassword = '$_basePath/auth/reset-password';
  static const listPlans = '$_basePath/payment/pricing';
  static const checkout = '$_basePath/payment';
  static const subscription = '$_basePath/payment/subscription';

  static const websiteClassification = '$_basePath/user/browser-history';
  static const urlClassification = '$_basePath/user/categorize-url';
}
