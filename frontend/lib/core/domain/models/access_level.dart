enum AccessLevel {
  unauth_user,
  user,
  botanic,
  admin
}

extension AccessLevelExtension on AccessLevel {
  String get displayTitle {
    switch (this) {
      case AccessLevel.unauth_user:
        return 'Анонимный пользователь';
      case AccessLevel.user:
        return 'Пользователь';
      case AccessLevel.botanic:
        return 'Ботаник';
      case AccessLevel.admin:
        return 'Админ';
    }
  }
}