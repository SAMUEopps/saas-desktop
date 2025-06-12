// utils/user_roles.dart
enum UserRole {
  admin,
  storeManager,
  facilitator,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.storeManager:
        return 'Store Manager';
      case UserRole.facilitator:
        return 'Facilitator';
    }
  }
}