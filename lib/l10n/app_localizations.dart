import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('pl')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Safe Family'**
  String get appName;

  /// No description provided for @homeWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Safe Family'**
  String get homeWelcomeTitle;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @languagePolish.
  ///
  /// In en, this message translates to:
  /// **'Polish'**
  String get languagePolish;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get languageGerman;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @themeToggleLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to light theme'**
  String get themeToggleLight;

  /// No description provided for @themeToggleDark.
  ///
  /// In en, this message translates to:
  /// **'Switch to dark theme'**
  String get themeToggleDark;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginTitle;

  /// No description provided for @loginUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Login / Username'**
  String get loginUsernameLabel;

  /// No description provided for @loginPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPasswordLabel;

  /// No description provided for @loginRequiredField.
  ///
  /// In en, this message translates to:
  /// **'Field required'**
  String get loginRequiredField;

  /// No description provided for @loginForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get loginForgotPassword;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @registerEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get registerEmailLabel;

  /// No description provided for @registerPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get registerPhoneLabel;

  /// No description provided for @registerUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Login / Username'**
  String get registerUsernameLabel;

  /// No description provided for @registerPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerPasswordLabel;

  /// No description provided for @registerContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get registerContinueButton;

  /// No description provided for @registerPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get registerPasswordMinLength;

  /// No description provided for @registerEmailToggle.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerEmailToggle;

  /// No description provided for @registerPhoneToggle.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get registerPhoneToggle;

  /// No description provided for @recoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Recovery'**
  String get recoveryTitle;

  /// No description provided for @recoveryQuestion.
  ///
  /// In en, this message translates to:
  /// **'What did you forget?'**
  String get recoveryQuestion;

  /// No description provided for @recoveryEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email used for registration'**
  String get recoveryEmailLabel;

  /// No description provided for @recoverySendButton.
  ///
  /// In en, this message translates to:
  /// **'Send reminder'**
  String get recoverySendButton;

  /// No description provided for @recoverySuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'A reminder ({recoveryItem}) has been sent to: {email}'**
  String recoverySuccessMessage(Object email, Object recoveryItem);

  /// No description provided for @recoveryItemLogin.
  ///
  /// In en, this message translates to:
  /// **'login'**
  String get recoveryItemLogin;

  /// No description provided for @recoveryItemPassword.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get recoveryItemPassword;

  /// No description provided for @recoveryInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please provide a valid email address.'**
  String get recoveryInvalidEmail;

  /// No description provided for @verifyCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Code Verification'**
  String get verifyCodeTitle;

  /// No description provided for @verifyCodeInstruction.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to:\n{emailOrPhone}'**
  String verifyCodeInstruction(Object emailOrPhone);

  /// No description provided for @verifyCodeInputLabel.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get verifyCodeInputLabel;

  /// No description provided for @verifyCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter 6 digits'**
  String get verifyCodeInvalid;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @setupFamilyTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Setup'**
  String get setupFamilyTitle;

  /// No description provided for @setupFamilyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add devices and assign family members to them.'**
  String get setupFamilyDescription;

  /// No description provided for @setupSearchDeviceButton.
  ///
  /// In en, this message translates to:
  /// **'Search and add device'**
  String get setupSearchDeviceButton;

  /// No description provided for @setupNoDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices have been added yet.'**
  String get setupNoDevices;

  /// No description provided for @setupFinishButton.
  ///
  /// In en, this message translates to:
  /// **'Finish and log in'**
  String get setupFinishButton;

  /// No description provided for @searchDevicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Searching for devices...'**
  String get searchDevicesTitle;

  /// No description provided for @searchDevicesError.
  ///
  /// In en, this message translates to:
  /// **'Search error.'**
  String get searchDevicesError;

  /// No description provided for @searchDevicesAllAdded.
  ///
  /// In en, this message translates to:
  /// **'All found devices have already been added.'**
  String get searchDevicesAllAdded;

  /// No description provided for @searchCancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get searchCancelButton;

  /// No description provided for @assignToDeviceTitle.
  ///
  /// In en, this message translates to:
  /// **'Assign to: {deviceName}'**
  String assignToDeviceTitle(Object deviceName);

  /// No description provided for @assignUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Login / Name'**
  String get assignUsernameLabel;

  /// No description provided for @assignPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password (min. 6 characters)'**
  String get assignPasswordLabel;

  /// No description provided for @assignPermissionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get assignPermissionsLabel;

  /// No description provided for @assignRoleStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get assignRoleStandard;

  /// No description provided for @assignRoleViewer.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get assignRoleViewer;

  /// No description provided for @assignSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get assignSaveButton;

  /// No description provided for @deviceCardUser.
  ///
  /// In en, this message translates to:
  /// **'User: {username}'**
  String deviceCardUser(Object username);

  /// No description provided for @deviceCardAssignButton.
  ///
  /// In en, this message translates to:
  /// **'Assign family member'**
  String get deviceCardAssignButton;

  /// No description provided for @deviceMenuEditUser.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get deviceMenuEditUser;

  /// No description provided for @deviceMenuUnassignUser.
  ///
  /// In en, this message translates to:
  /// **'Unassign user'**
  String get deviceMenuUnassignUser;

  /// No description provided for @deviceMenuRemoveDevice.
  ///
  /// In en, this message translates to:
  /// **'Remove device'**
  String get deviceMenuRemoveDevice;

  /// No description provided for @bottomNavUsers.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get bottomNavUsers;

  /// No description provided for @bottomNavZones.
  ///
  /// In en, this message translates to:
  /// **'Zones'**
  String get bottomNavZones;

  /// No description provided for @bottomNavMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get bottomNavMenu;

  /// No description provided for @familyListTitle.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get familyListTitle;

  /// No description provided for @familyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No users added'**
  String get familyEmptyTitle;

  /// No description provided for @familyEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Add family members to see their location and manage their devices.'**
  String get familyEmptyDescription;

  /// No description provided for @familyAddFirstUserButton.
  ///
  /// In en, this message translates to:
  /// **'Add first user'**
  String get familyAddFirstUserButton;

  /// No description provided for @familyAddUserButton.
  ///
  /// In en, this message translates to:
  /// **'Add family member'**
  String get familyAddUserButton;

  /// No description provided for @familyCardInZones.
  ///
  /// In en, this message translates to:
  /// **'In zones: {zones}'**
  String familyCardInZones(Object zones);

  /// No description provided for @familyCardDeviceInfo.
  ///
  /// In en, this message translates to:
  /// **'{deviceName} - {batteryLevel}% battery'**
  String familyCardDeviceInfo(Object batteryLevel, Object deviceName);

  /// No description provided for @familyManageButton.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get familyManageButton;

  /// No description provided for @familyCreatorAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new user'**
  String get familyCreatorAddTitle;

  /// No description provided for @familyCreatorEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage user'**
  String get familyCreatorEditTitle;

  /// No description provided for @familyCreatorDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get familyCreatorDeleteConfirmTitle;

  /// No description provided for @familyCreatorDeleteConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this user? This action cannot be undone.'**
  String get familyCreatorDeleteConfirmContent;

  /// No description provided for @familyCreatorDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get familyCreatorDeleteButton;

  /// No description provided for @familyCreatorStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Details and device'**
  String get familyCreatorStep1Title;

  /// No description provided for @familyCreatorLoginLabel.
  ///
  /// In en, this message translates to:
  /// **'Login (unique)'**
  String get familyCreatorLoginLabel;

  /// No description provided for @familyCreatorPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get familyCreatorPasswordMinLength;

  /// No description provided for @familyCreatorLinkDeviceButton.
  ///
  /// In en, this message translates to:
  /// **'Link device'**
  String get familyCreatorLinkDeviceButton;

  /// No description provided for @familyCreatorDeviceLinkedTo.
  ///
  /// In en, this message translates to:
  /// **'Linked to:'**
  String get familyCreatorDeviceLinkedTo;

  /// No description provided for @familyCreatorChangeDevice.
  ///
  /// In en, this message translates to:
  /// **'Change device'**
  String get familyCreatorChangeDevice;

  /// No description provided for @familyCreatorDisconnectDevice.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get familyCreatorDisconnectDevice;

  /// No description provided for @familyCreatorBluetoothSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Searching for Bluetooth devices'**
  String get familyCreatorBluetoothSearchTitle;

  /// No description provided for @familyCreatorBluetoothScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get familyCreatorBluetoothScanning;

  /// No description provided for @familyCreatorStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Zone assignment'**
  String get familyCreatorStep2Title;

  /// No description provided for @familyCreatorStep2Description.
  ///
  /// In en, this message translates to:
  /// **'Select the zones you want to assign the user to. This step is optional.'**
  String get familyCreatorStep2Description;

  /// No description provided for @familyCreatorNoZones.
  ///
  /// In en, this message translates to:
  /// **'No zones defined. Create a zone in the appropriate tab.'**
  String get familyCreatorNoZones;

  /// No description provided for @familyCreatorFinishButton.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get familyCreatorFinishButton;

  /// No description provided for @familyCreatorSaveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get familyCreatorSaveChangesButton;

  /// No description provided for @zonesTitle.
  ///
  /// In en, this message translates to:
  /// **'Safety Zones'**
  String get zonesTitle;

  /// No description provided for @zonesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for a zone or user...'**
  String get zonesSearchHint;

  /// No description provided for @zonesSearchResultZone.
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get zonesSearchResultZone;

  /// No description provided for @zonesSearchResultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get zonesSearchResultUser;

  /// No description provided for @zonesAddButton.
  ///
  /// In en, this message translates to:
  /// **'Add zone'**
  String get zonesAddButton;

  /// No description provided for @zonesCardAddress.
  ///
  /// In en, this message translates to:
  /// **'Address:'**
  String get zonesCardAddress;

  /// No description provided for @zonesCardUsersInZone.
  ///
  /// In en, this message translates to:
  /// **'Users in zone:'**
  String get zonesCardUsersInZone;

  /// No description provided for @zonesCardNoUsers.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get zonesCardNoUsers;

  /// No description provided for @zonesCardModifyButton.
  ///
  /// In en, this message translates to:
  /// **'Modify zone'**
  String get zonesCardModifyButton;

  /// No description provided for @zonesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'What are safety zones?'**
  String get zonesEmptyTitle;

  /// No description provided for @zonesEmptyInfo1Title.
  ///
  /// In en, this message translates to:
  /// **'Receive automatic notifications'**
  String get zonesEmptyInfo1Title;

  /// No description provided for @zonesEmptyInfo1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'when your loved ones enter or leave important places.'**
  String get zonesEmptyInfo1Subtitle;

  /// No description provided for @zonesEmptyInfo2Title.
  ///
  /// In en, this message translates to:
  /// **'Set up zones around home, school, work'**
  String get zonesEmptyInfo2Title;

  /// No description provided for @zonesEmptyInfo2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'or the playground.'**
  String get zonesEmptyInfo2Subtitle;

  /// No description provided for @zonesEmptyInfo3Title.
  ///
  /// In en, this message translates to:
  /// **'Rest easy knowing your loved ones are safe'**
  String get zonesEmptyInfo3Title;

  /// No description provided for @zonesEmptyInfo3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'in specified locations.'**
  String get zonesEmptyInfo3Subtitle;

  /// No description provided for @zoneCreatorAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add new zone'**
  String get zoneCreatorAddTitle;

  /// No description provided for @zoneCreatorEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit zone'**
  String get zoneCreatorEditTitle;

  /// No description provided for @zoneCreatorStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Step 1: Name and icon'**
  String get zoneCreatorStep1Title;

  /// No description provided for @zoneCreatorNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Zone name'**
  String get zoneCreatorNameLabel;

  /// No description provided for @zoneCreatorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get zoneCreatorNameRequired;

  /// No description provided for @zoneCreatorSelectIcon.
  ///
  /// In en, this message translates to:
  /// **'Select icon:'**
  String get zoneCreatorSelectIcon;

  /// No description provided for @zoneCreatorNextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get zoneCreatorNextButton;

  /// No description provided for @zoneCreatorStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Step 2: Location'**
  String get zoneCreatorStep2Title;

  /// No description provided for @zoneCreatorAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter address or point on map'**
  String get zoneCreatorAddressHint;

  /// No description provided for @zoneCreatorRadius.
  ///
  /// In en, this message translates to:
  /// **'Zone radius: {radius} m'**
  String zoneCreatorRadius(Object radius);

  /// No description provided for @zoneCreatorStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Step 3: Notifications'**
  String get zoneCreatorStep3Title;

  /// No description provided for @zoneCreatorStep3Description.
  ///
  /// In en, this message translates to:
  /// **'For which devices do you want to receive notifications about entering and leaving the zone?'**
  String get zoneCreatorStep3Description;

  /// No description provided for @zoneCreatorNoUsersToAssign.
  ///
  /// In en, this message translates to:
  /// **'No defined users to assign.'**
  String get zoneCreatorNoUsersToAssign;

  /// No description provided for @zoneCreatorCreateButton.
  ///
  /// In en, this message translates to:
  /// **'Create zone'**
  String get zoneCreatorCreateButton;

  /// No description provided for @zoneCreatorSuccessTitleAdd.
  ///
  /// In en, this message translates to:
  /// **'Zone has been created!'**
  String get zoneCreatorSuccessTitleAdd;

  /// No description provided for @zoneCreatorSuccessTitleEdit.
  ///
  /// In en, this message translates to:
  /// **'Zone has been updated!'**
  String get zoneCreatorSuccessTitleEdit;

  /// No description provided for @zoneCreatorSuccessDescription.
  ///
  /// In en, this message translates to:
  /// **'By setting up a zone, you will always receive an automatic alert when your loved one enters or leaves the designated area.'**
  String get zoneCreatorSuccessDescription;

  /// No description provided for @zoneCreatorGoToZonesButton.
  ///
  /// In en, this message translates to:
  /// **'Go to zones'**
  String get zoneCreatorGoToZonesButton;

  /// No description provided for @zoneCreatorAddAnotherButton.
  ///
  /// In en, this message translates to:
  /// **'Add another'**
  String get zoneCreatorAddAnotherButton;

  /// No description provided for @zoneCreatorDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get zoneCreatorDeleteConfirmTitle;

  /// No description provided for @zoneCreatorDeleteConfirmContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to permanently delete this zone? This action cannot be undone.'**
  String get zoneCreatorDeleteConfirmContent;

  /// No description provided for @zoneCreatorDeleteButton.
  ///
  /// In en, this message translates to:
  /// **'Delete zone'**
  String get zoneCreatorDeleteButton;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @menuSectionAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get menuSectionAccount;

  /// No description provided for @menuManageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage account'**
  String get menuManageAccount;

  /// No description provided for @menuManageAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change email or password'**
  String get menuManageAccountSubtitle;

  /// No description provided for @menuSectionApp.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get menuSectionApp;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @menuTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menuTheme;

  /// No description provided for @menuLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get menuLogout;

  /// No description provided for @menuThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get menuThemeLight;

  /// No description provided for @menuThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get menuThemeDark;

  /// No description provided for @menuThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get menuThemeSystem;

  /// No description provided for @menuSelectThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Select theme'**
  String get menuSelectThemeTitle;

  /// No description provided for @menuSaveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get menuSaveButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
