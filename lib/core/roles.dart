// lib/core/roles.dart
enum UserRole { admin, ceo, commercial, technician, manager, viewer }

UserRole parseRole(String? raw) {
  switch ((raw ?? '').toLowerCase()) {
    case 'admin':
      return UserRole.admin;
    case 'ceo':
      return UserRole.ceo;
    case 'commercial':
      return UserRole.commercial;
    case 'technician':
      return UserRole.technician;
    case 'manager':
      return UserRole.manager;
    case 'viewer':
    default:
      return UserRole.viewer;
  }
}

extension RoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.admin:
        return 'Admin';
      case UserRole.ceo:
        return 'CEO';
      case UserRole.commercial:
        return 'Commercial';
      case UserRole.technician:
        return 'Technician';
      case UserRole.manager:
        return 'Manager';
      case UserRole.viewer:
        return 'Viewer';
    }
  }

  /// Technical operations = Interventions / Installations / SAV
  bool get canEditTechOps {
    switch (this) {
      case UserRole.admin:
      case UserRole.ceo:
      case UserRole.manager:
      case UserRole.technician:
        return true;
      case UserRole.commercial:
      case UserRole.viewer:
        return false;
    }
  }

  /// Sales (Livraison) editing permission
  bool get canEditLivraison {
    switch (this) {
      case UserRole.admin:
      case UserRole.ceo:
      case UserRole.manager:
      case UserRole.commercial:
        return true;
      case UserRole.technician:
      case UserRole.viewer:
        return false;
    }
  }

  /// Permission to assign interventions to technicians
  bool get canAssignTickets {
    return const [
      UserRole.admin,
      UserRole.ceo,
      UserRole.manager,
      UserRole.commercial,
    ].contains(this);
  }

  /// Permission to change the status of an intervention (e.g., to 'Resolved')
  bool get canChangeInterventionStatus {
    return const [
      UserRole.admin,
      UserRole.ceo,
      UserRole.manager,
      UserRole.commercial,
    ].contains(this);
  }
}