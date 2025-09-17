// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Sichere Familie';

  @override
  String get homeWelcomeTitle => 'Sichere Familie';

  @override
  String get loginButton => 'Anmelden';

  @override
  String get registerButton => 'Registrieren';

  @override
  String get languagePolish => 'Polnisch';

  @override
  String get languageEnglish => 'Englisch';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSpanish => 'Spanisch';

  @override
  String get themeToggleLight => 'Zum hellen Thema wechseln';

  @override
  String get themeToggleDark => 'Zum dunklen Thema wechseln';

  @override
  String get loginTitle => 'Anmelden';

  @override
  String get loginUsernameLabel => 'Login / Benutzername';

  @override
  String get loginPasswordLabel => 'Passwort';

  @override
  String get loginRequiredField => 'Feld erforderlich';

  @override
  String get loginForgotPassword => 'Passwort vergessen?';

  @override
  String get registerTitle => 'Konto erstellen';

  @override
  String get registerEmailLabel => 'E-Mail-Adresse';

  @override
  String get registerPhoneLabel => 'Telefonnummer';

  @override
  String get registerUsernameLabel => 'Login / Benutzername';

  @override
  String get registerPasswordLabel => 'Passwort';

  @override
  String get registerContinueButton => 'Weiter';

  @override
  String get registerPasswordMinLength => 'Mindestens 6 Zeichen';

  @override
  String get registerEmailToggle => 'E-Mail';

  @override
  String get registerPhoneToggle => 'Telefon';

  @override
  String get recoveryTitle => 'Kontowiederherstellung';

  @override
  String get recoveryQuestion => 'Was haben Sie vergessen?';

  @override
  String get recoveryEmailLabel => 'Bei der Registrierung verwendete E-Mail';

  @override
  String get recoverySendButton => 'Erinnerung senden';

  @override
  String recoverySuccessMessage(Object email, Object recoveryItem) {
    return 'Eine Erinnerung ($recoveryItem) wurde an $email gesendet';
  }

  @override
  String get recoveryItemLogin => 'Login';

  @override
  String get recoveryItemPassword => 'Passwort';

  @override
  String get recoveryInvalidEmail =>
      'Bitte geben Sie eine gültige E-Mail-Adresse ein.';

  @override
  String get verifyCodeTitle => 'Code-Überprüfung';

  @override
  String verifyCodeInstruction(Object emailOrPhone) {
    return 'Wir haben einen Bestätigungscode an\n$emailOrPhone gesendet';
  }

  @override
  String get verifyCodeInputLabel => '6-stelliger Code';

  @override
  String get verifyCodeInvalid => 'Geben Sie 6 Ziffern ein';

  @override
  String get verifyButton => 'Überprüfen';

  @override
  String get setupFamilyTitle => 'Familieneinrichtung';

  @override
  String get setupFamilyDescription =>
      'Fügen Sie Geräte hinzu und weisen Sie ihnen Familienmitglieder zu.';

  @override
  String get setupSearchDeviceButton => 'Gerät suchen und hinzufügen';

  @override
  String get setupNoDevices => 'Es wurden noch keine Geräte hinzugefügt.';

  @override
  String get setupFinishButton => 'Abschließen und anmelden';

  @override
  String get searchDevicesTitle => 'Suche nach Geräten...';

  @override
  String get searchDevicesError => 'Suchfehler.';

  @override
  String get searchDevicesAllAdded =>
      'Alle gefundenen Geräte wurden bereits hinzugefügt.';

  @override
  String get searchCancelButton => 'Abbrechen';

  @override
  String assignToDeviceTitle(Object deviceName) {
    return 'Zuweisen zu: $deviceName';
  }

  @override
  String get assignUsernameLabel => 'Login / Name';

  @override
  String get assignPasswordLabel => 'Passwort (min. 6 Zeichen)';

  @override
  String get assignPermissionsLabel => 'Berechtigungen';

  @override
  String get assignRoleStandard => 'Standard';

  @override
  String get assignRoleViewer => 'Betrachter';

  @override
  String get assignSaveButton => 'Speichern';

  @override
  String deviceCardUser(Object username) {
    return 'Benutzer: $username';
  }

  @override
  String get deviceCardAssignButton => 'Familienmitglied zuweisen';

  @override
  String get deviceMenuEditUser => 'Benutzer bearbeiten';

  @override
  String get deviceMenuUnassignUser => 'Zuweisung des Benutzers aufheben';

  @override
  String get deviceMenuRemoveDevice => 'Gerät entfernen';

  @override
  String get bottomNavUsers => 'Benutzer';

  @override
  String get bottomNavZones => 'Zonen';

  @override
  String get bottomNavMenu => 'Menü';

  @override
  String get familyListTitle => 'Benutzer';

  @override
  String get familyEmptyTitle => 'Keine Benutzer hinzugefügt';

  @override
  String get familyEmptyDescription =>
      'Fügen Sie Familienmitglieder hinzu, um ihren Standort zu sehen und ihre Geräte zu verwalten.';

  @override
  String get familyAddFirstUserButton => 'Ersten Benutzer hinzufügen';

  @override
  String get familyAddUserButton => 'Familienmitglied hinzufügen';

  @override
  String familyCardInZones(Object zones) {
    return 'In Zonen: $zones';
  }

  @override
  String familyCardDeviceInfo(Object batteryLevel, Object deviceName) {
    return '$deviceName - $batteryLevel% Akku';
  }

  @override
  String get familyManageButton => 'Verwalten';

  @override
  String get familyCreatorAddTitle => 'Neuen Benutzer hinzufügen';

  @override
  String get familyCreatorEditTitle => 'Benutzer verwalten';

  @override
  String get familyCreatorDeleteConfirmTitle => 'Löschung bestätigen';

  @override
  String get familyCreatorDeleteConfirmContent =>
      'Sind Sie sicher, dass Sie diesen Benutzer dauerhaft löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get familyCreatorDeleteButton => 'Benutzer löschen';

  @override
  String get familyCreatorStep1Title => 'Schritt 1: Daten und Gerät';

  @override
  String get familyCreatorLoginLabel => 'Login (einzigartig)';

  @override
  String get familyCreatorPasswordMinLength =>
      'Das Passwort muss mindestens 6 Zeichen lang sein';

  @override
  String get familyCreatorLinkDeviceButton => 'Gerät verbinden';

  @override
  String get familyCreatorDeviceLinkedTo => 'Verbunden mit:';

  @override
  String get familyCreatorChangeDevice => 'Gerät ändern';

  @override
  String get familyCreatorDisconnectDevice => 'Trennen';

  @override
  String get familyCreatorBluetoothSearchTitle =>
      'Suche nach Bluetooth-Geräten';

  @override
  String get familyCreatorBluetoothScanning => 'Scannen...';

  @override
  String get familyCreatorStep2Title => 'Schritt 2: Zonenzuweisung';

  @override
  String get familyCreatorStep2Description =>
      'Wählen Sie die Zonen aus, denen Sie den Benutzer zuweisen möchten. Dieser Schritt ist optional.';

  @override
  String get familyCreatorNoZones =>
      'Keine Zonen definiert. Erstellen Sie eine Zone im entsprechenden Tab.';

  @override
  String get familyCreatorFinishButton => 'Abschließen';

  @override
  String get familyCreatorSaveChangesButton => 'Änderungen speichern';

  @override
  String get zonesTitle => 'Sicherheitszonen';

  @override
  String get zonesSearchHint => 'Suche nach einer Zone oder einem Benutzer...';

  @override
  String get zonesSearchResultZone => 'Zone';

  @override
  String get zonesSearchResultUser => 'Benutzer';

  @override
  String get zonesAddButton => 'Zone hinzufügen';

  @override
  String get zonesCardAddress => 'Adresse:';

  @override
  String get zonesCardUsersInZone => 'Benutzer in der Zone:';

  @override
  String get zonesCardNoUsers => 'Keine';

  @override
  String get zonesCardModifyButton => 'Zone ändern';

  @override
  String get zonesEmptyTitle => 'Was sind Sicherheitszonen?';

  @override
  String get zonesEmptyInfo1Title => 'Automatische Benachrichtigungen erhalten';

  @override
  String get zonesEmptyInfo1Subtitle =>
      'wenn Ihre Lieben wichtige Orte betreten oder verlassen.';

  @override
  String get zonesEmptyInfo2Title =>
      'Richten Sie Zonen um Zuhause, Schule, Arbeit ein';

  @override
  String get zonesEmptyInfo2Subtitle => 'oder den Spielplatz.';

  @override
  String get zonesEmptyInfo3Title =>
      'Seien Sie beruhigt, in dem Wissen, dass Ihre Lieben sicher sind';

  @override
  String get zonesEmptyInfo3Subtitle => 'an bestimmten Orten.';

  @override
  String get zoneCreatorAddTitle => 'Neue Zone hinzufügen';

  @override
  String get zoneCreatorEditTitle => 'Zone bearbeiten';

  @override
  String get zoneCreatorStep1Title => 'Schritt 1: Name und Symbol';

  @override
  String get zoneCreatorNameLabel => 'Zonenname';

  @override
  String get zoneCreatorNameRequired => 'Name ist erforderlich';

  @override
  String get zoneCreatorSelectIcon => 'Symbol auswählen:';

  @override
  String get zoneCreatorNextButton => 'Weiter';

  @override
  String get zoneCreatorStep2Title => 'Schritt 2: Standort';

  @override
  String get zoneCreatorAddressHint =>
      'Adresse eingeben oder auf der Karte auswählen';

  @override
  String zoneCreatorRadius(Object radius) {
    return 'Zonenradius: $radius m';
  }

  @override
  String get zoneCreatorStep3Title => 'Schritt 3: Benachrichtigungen';

  @override
  String get zoneCreatorStep3Description =>
      'Für welche Geräte möchten Sie Benachrichtigungen über das Betreten und Verlassen der Zone erhalten?';

  @override
  String get zoneCreatorNoUsersToAssign =>
      'Keine definierten Benutzer zum Zuweisen.';

  @override
  String get zoneCreatorCreateButton => 'Zone erstellen';

  @override
  String get zoneCreatorSuccessTitleAdd => 'Zone wurde erstellt!';

  @override
  String get zoneCreatorSuccessTitleEdit => 'Zone wurde aktualisiert!';

  @override
  String get zoneCreatorSuccessDescription =>
      'Durch das Einrichten einer Zone erhalten Sie immer eine automatische Benachrichtigung, wenn Ihr Angehöriger den festgelegten Bereich betritt oder verlässt.';

  @override
  String get zoneCreatorGoToZonesButton => 'Zu den Zonen gehen';

  @override
  String get zoneCreatorAddAnotherButton => 'Weitere hinzufügen';

  @override
  String get zoneCreatorDeleteConfirmTitle => 'Löschung bestätigen';

  @override
  String get zoneCreatorDeleteConfirmContent =>
      'Sind Sie sicher, dass Sie diese Zone dauerhaft löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get zoneCreatorDeleteButton => 'Zone löschen';

  @override
  String get menuTitle => 'Menü';

  @override
  String get menuSectionAccount => 'Konto';

  @override
  String get menuManageAccount => 'Konto verwalten';

  @override
  String get menuManageAccountSubtitle => 'E-Mail oder Passwort ändern';

  @override
  String get menuSectionApp => 'Anwendung';

  @override
  String get menuLanguage => 'Sprache';

  @override
  String get menuTheme => 'Thema';

  @override
  String get menuLogout => 'Abmelden';

  @override
  String get menuThemeLight => 'Hell';

  @override
  String get menuThemeDark => 'Dunkel';

  @override
  String get menuThemeSystem => 'System';

  @override
  String get menuSelectThemeTitle => 'Thema auswählen';

  @override
  String get menuSaveButton => 'Speichern';
}
