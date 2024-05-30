enum AccessLevel {
  unauth_user,
  user,
  botanist,
  admin
}

extension AccessLevelExtension on AccessLevel {
  String get displayTitle {
    switch (this) {
      case AccessLevel.unauth_user:
        return 'Анонимный пользователь';
      case AccessLevel.user:
        return 'Пользователь';
      case AccessLevel.botanist:
        return 'Ботаник';
      case AccessLevel.admin:
        return 'Админ';
    }
  }
}