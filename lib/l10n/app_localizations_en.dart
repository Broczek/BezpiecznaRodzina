// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Safe Family';

  @override
  String get homeWelcomeTitle => 'Safe Family';

  @override
  String get loginButton => 'Log In';

  @override
  String get registerButton => 'Register';

  @override
  String get languagePolish => 'Polish';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'German';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get themeToggleLight => 'Switch to light theme';

  @override
  String get themeToggleDark => 'Switch to dark theme';

  @override
  String get loginTitle => 'Log In';

  @override
  String get loginUsernameLabel => 'Login / Username';

  @override
  String get loginPasswordLabel => 'Password';

  @override
  String get loginRequiredField => 'Field required';

  @override
  String get loginForgotPassword => 'Forgot your password?';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerEmailLabel => 'Email Address';

  @override
  String get registerPhoneLabel => 'Phone number';

  @override
  String get registerUsernameLabel => 'Login / Username';

  @override
  String get registerPasswordLabel => 'Password';

  @override
  String get registerContinueButton => 'Continue';

  @override
  String get registerPasswordMinLength => 'Minimum 6 characters';

  @override
  String get registerEmailToggle => 'Email';

  @override
  String get registerPhoneToggle => 'Phone';

  @override
  String get recoveryTitle => 'Account Recovery';

  @override
  String get recoveryQuestion => 'What did you forget?';

  @override
  String get recoveryEmailLabel => 'Email used for registration';

  @override
  String get recoverySendButton => 'Send reminder';

  @override
  String recoverySuccessMessage(Object email, Object recoveryItem) {
    return 'A reminder ($recoveryItem) has been sent to: $email';
  }

  @override
  String get recoveryItemLogin => 'login';

  @override
  String get recoveryItemPassword => 'password';

  @override
  String get recoveryInvalidEmail => 'Please provide a valid email address.';

  @override
  String get verifyCodeTitle => 'Code Verification';

  @override
  String verifyCodeInstruction(Object emailOrPhone) {
    return 'We have sent a verification code to:\n$emailOrPhone';
  }

  @override
  String get verifyCodeInputLabel => '6-digit code';

  @override
  String get verifyCodeInvalid => 'Enter 6 digits';

  @override
  String get verifyButton => 'Verify';

  @override
  String get setupFamilyTitle => 'Family Setup';

  @override
  String get setupFamilyDescription =>
      'Add devices and assign family members to them.';

  @override
  String get setupSearchDeviceButton => 'Search and add device';

  @override
  String get setupNoDevices => 'No devices have been added yet.';

  @override
  String get setupFinishButton => 'Finish and log in';

  @override
  String get searchDevicesTitle => 'Searching for devices...';

  @override
  String get searchDevicesError => 'Search error.';

  @override
  String get searchDevicesAllAdded =>
      'All found devices have already been added.';

  @override
  String get searchCancelButton => 'Cancel';

  @override
  String assignToDeviceTitle(Object deviceName) {
    return 'Assign to: $deviceName';
  }

  @override
  String get assignUsernameLabel => 'Login / Name';

  @override
  String get assignPasswordLabel => 'Password (min. 6 characters)';

  @override
  String get assignPermissionsLabel => 'Permissions';

  @override
  String get assignRoleStandard => 'Standard';

  @override
  String get assignRoleViewer => 'Viewer';

  @override
  String get assignSaveButton => 'Save';

  @override
  String deviceCardUser(Object username) {
    return 'User: $username';
  }

  @override
  String get deviceCardAssignButton => 'Assign family member';

  @override
  String get deviceMenuEditUser => 'Edit user';

  @override
  String get deviceMenuUnassignUser => 'Unassign user';

  @override
  String get deviceMenuRemoveDevice => 'Remove device';

  @override
  String get bottomNavUsers => 'Users';

  @override
  String get bottomNavZones => 'Zones';

  @override
  String get bottomNavMenu => 'Menu';

  @override
  String get familyListTitle => 'Users';

  @override
  String get familyEmptyTitle => 'No users added';

  @override
  String get familyEmptyDescription =>
      'Add family members to see their location and manage their devices.';

  @override
  String get familyAddFirstUserButton => 'Add first user';

  @override
  String get familyAddUserButton => 'Add family member';

  @override
  String familyCardInZones(Object zones) {
    return 'In zones: $zones';
  }

  @override
  String familyCardDeviceInfo(Object batteryLevel, Object deviceName) {
    return '$deviceName - $batteryLevel% battery';
  }

  @override
  String get familyManageButton => 'Manage';

  @override
  String get familyCreatorAddTitle => 'Add new user';

  @override
  String get familyCreatorEditTitle => 'Manage user';

  @override
  String get familyCreatorDeleteConfirmTitle => 'Confirm deletion';

  @override
  String get familyCreatorDeleteConfirmContent =>
      'Are you sure you want to permanently delete this user? This action cannot be undone.';

  @override
  String get familyCreatorDeleteButton => 'Delete user';

  @override
  String get familyCreatorStep1Title => 'Step 1: Details and device';

  @override
  String get familyCreatorLoginLabel => 'Login (unique)';

  @override
  String get familyCreatorPasswordMinLength =>
      'Password must be at least 6 characters';

  @override
  String get familyCreatorLinkDeviceButton => 'Link device';

  @override
  String get familyCreatorDeviceLinkedTo => 'Linked to:';

  @override
  String get familyCreatorChangeDevice => 'Change device';

  @override
  String get familyCreatorDisconnectDevice => 'Disconnect';

  @override
  String get familyCreatorBluetoothSearchTitle =>
      'Searching for Bluetooth devices';

  @override
  String get familyCreatorBluetoothScanning => 'Scanning...';

  @override
  String get familyCreatorStep2Title => 'Step 2: Zone assignment';

  @override
  String get familyCreatorStep2Description =>
      'Select the zones you want to assign the user to. This step is optional.';

  @override
  String get familyCreatorNoZones =>
      'No zones defined. Create a zone in the appropriate tab.';

  @override
  String get familyCreatorFinishButton => 'Finish';

  @override
  String get familyCreatorSaveChangesButton => 'Save changes';

  @override
  String get zonesTitle => 'Safety Zones';

  @override
  String get zonesSearchHint => 'Search for a zone or user...';

  @override
  String get zonesSearchResultZone => 'Zone';

  @override
  String get zonesSearchResultUser => 'User';

  @override
  String get zonesAddButton => 'Add zone';

  @override
  String get zonesCardAddress => 'Address:';

  @override
  String get zonesCardUsersInZone => 'Users in zone:';

  @override
  String get zonesCardNoUsers => 'None';

  @override
  String get zonesCardModifyButton => 'Modify zone';

  @override
  String get zonesEmptyTitle => 'What are safety zones?';

  @override
  String get zonesEmptyInfo1Title => 'Receive automatic notifications';

  @override
  String get zonesEmptyInfo1Subtitle =>
      'when your loved ones enter or leave important places.';

  @override
  String get zonesEmptyInfo2Title => 'Set up zones around home, school, work';

  @override
  String get zonesEmptyInfo2Subtitle => 'or the playground.';

  @override
  String get zonesEmptyInfo3Title =>
      'Rest easy knowing your loved ones are safe';

  @override
  String get zonesEmptyInfo3Subtitle => 'in specified locations.';

  @override
  String get zoneCreatorAddTitle => 'Add new zone';

  @override
  String get zoneCreatorEditTitle => 'Edit zone';

  @override
  String get zoneCreatorStep1Title => 'Step 1: Name and icon';

  @override
  String get zoneCreatorNameLabel => 'Zone name';

  @override
  String get zoneCreatorNameRequired => 'Name is required';

  @override
  String get zoneCreatorSelectIcon => 'Select icon:';

  @override
  String get zoneCreatorNextButton => 'Next';

  @override
  String get zoneCreatorStep2Title => 'Step 2: Location';

  @override
  String get zoneCreatorAddressHint => 'Enter address or point on map';

  @override
  String zoneCreatorRadius(Object radius) {
    return 'Zone radius: $radius m';
  }

  @override
  String get zoneCreatorStep3Title => 'Step 3: Notifications';

  @override
  String get zoneCreatorStep3Description =>
      'For which devices do you want to receive notifications about entering and leaving the zone?';

  @override
  String get zoneCreatorNoUsersToAssign => 'No defined users to assign.';

  @override
  String get zoneCreatorCreateButton => 'Create zone';

  @override
  String get zoneCreatorSuccessTitleAdd => 'Zone has been created!';

  @override
  String get zoneCreatorSuccessTitleEdit => 'Zone has been updated!';

  @override
  String get zoneCreatorSuccessDescription =>
      'By setting up a zone, you will always receive an automatic alert when your loved one enters or leaves the designated area.';

  @override
  String get zoneCreatorGoToZonesButton => 'Go to zones';

  @override
  String get zoneCreatorAddAnotherButton => 'Add another';

  @override
  String get zoneCreatorDeleteConfirmTitle => 'Confirm deletion';

  @override
  String get zoneCreatorDeleteConfirmContent =>
      'Are you sure you want to permanently delete this zone? This action cannot be undone.';

  @override
  String get zoneCreatorDeleteButton => 'Delete zone';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuSectionAccount => 'Account';

  @override
  String get menuManageAccount => 'Manage account';

  @override
  String get menuManageAccountSubtitle => 'Change email or password';

  @override
  String get menuSectionApp => 'Application';

  @override
  String get menuLanguage => 'Language';

  @override
  String get menuTheme => 'Theme';

  @override
  String get menuLogout => 'Log out';

  @override
  String get menuThemeLight => 'Light';

  @override
  String get menuThemeDark => 'Dark';

  @override
  String get menuThemeSystem => 'System';

  @override
  String get menuSelectThemeTitle => 'Select theme';

  @override
  String get menuSaveButton => 'Save';
}
