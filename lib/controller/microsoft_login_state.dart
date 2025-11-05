abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final String name;
  final String email;
  final String? phone;
  final String? roleName;
  final dynamic userProfiles; // can be List or Map depending on API response
  final String? jobTitle;
  final String? officeLocation;
  final String? department;

  AuthSuccess({
    required this.name,
    required this.email,
    this.phone,
    this.roleName,
    this.userProfiles,
    this.jobTitle,
    this.officeLocation,
    this.department,
  });
}

class AuthError extends AuthState {
  final String errorMessage;
  AuthError(this.errorMessage);
}
