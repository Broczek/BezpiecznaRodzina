// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appName => 'Bezpieczna Rodzina';

  @override
  String get homeWelcomeTitle => 'Bezpieczna Rodzina';

  @override
  String get loginButton => 'Zaloguj się';

  @override
  String get registerButton => 'Zarejestruj się';

  @override
  String get languagePolish => 'Polski';

  @override
  String get languageEnglish => 'Angielski';

  @override
  String get languageGerman => 'Niemiecki';

  @override
  String get languageSpanish => 'Hiszpański';

  @override
  String get themeToggleLight => 'Przełącz na motyw jasny';

  @override
  String get themeToggleDark => 'Przełącz na motyw ciemny';

  @override
  String get loginTitle => 'Zaloguj się';

  @override
  String get loginUsernameLabel => 'Login / Nazwa użytkownika';

  @override
  String get loginPasswordLabel => 'Hasło';

  @override
  String get loginRequiredField => 'Pole wymagane';

  @override
  String get loginForgotPassword => 'Nie pamiętasz hasła?';

  @override
  String get registerTitle => 'Stwórz konto';

  @override
  String get registerEmailLabel => 'Adres Email';

  @override
  String get registerPhoneLabel => 'Numer telefonu';

  @override
  String get registerUsernameLabel => 'Login / Nazwa użytkownika';

  @override
  String get registerPasswordLabel => 'Hasło';

  @override
  String get registerContinueButton => 'Kontynuuj';

  @override
  String get registerPasswordMinLength => 'Minimum 6 znaków';

  @override
  String get registerEmailToggle => 'Email';

  @override
  String get registerPhoneToggle => 'Telefon';

  @override
  String get recoveryTitle => 'Odzyskiwanie konta';

  @override
  String get recoveryQuestion => 'Czego nie pamiętasz?';

  @override
  String get recoveryEmailLabel => 'Email podany przy rejestracji';

  @override
  String get recoverySendButton => 'Wyślij przypomnienie';

  @override
  String recoverySuccessMessage(Object email, Object recoveryItem) {
    return 'Wysłano przypomnienie ($recoveryItem) na adres: $email';
  }

  @override
  String get recoveryItemLogin => 'login';

  @override
  String get recoveryItemPassword => 'hasło';

  @override
  String get recoveryInvalidEmail => 'Proszę podać poprawny adres email.';

  @override
  String get verifyCodeTitle => 'Weryfikacja kodu';

  @override
  String verifyCodeInstruction(Object emailOrPhone) {
    return 'Wysłaliśmy kod weryfikacyjny na:\n$emailOrPhone';
  }

  @override
  String get verifyCodeInputLabel => 'Kod 6-cyfrowy';

  @override
  String get verifyCodeInvalid => 'Wprowadź 6 cyfr';

  @override
  String get verifyButton => 'Zweryfikuj';

  @override
  String get setupFamilyTitle => 'Konfiguracja rodziny';

  @override
  String get setupFamilyDescription =>
      'Dodaj urządzenia i przypisz do nich członków rodziny.';

  @override
  String get setupSearchDeviceButton => 'Wyszukaj i dodaj urządzenie';

  @override
  String get setupNoDevices => 'Nie dodano jeszcze żadnych urządzeń.';

  @override
  String get setupFinishButton => 'Zakończ i zaloguj';

  @override
  String get searchDevicesTitle => 'Wyszukiwanie urządzeń...';

  @override
  String get searchDevicesError => 'Błąd wyszukiwania.';

  @override
  String get searchDevicesAllAdded =>
      'Wszystkie znalezione urządzenia zostały już dodane.';

  @override
  String get searchCancelButton => 'Anuluj';

  @override
  String assignToDeviceTitle(Object deviceName) {
    return 'Przypisz do: $deviceName';
  }

  @override
  String get assignUsernameLabel => 'Login / Nazwa';

  @override
  String get assignPasswordLabel => 'Hasło (min. 6 znaków)';

  @override
  String get assignPermissionsLabel => 'Uprawnienia';

  @override
  String get assignRoleStandard => 'Standard';

  @override
  String get assignRoleViewer => 'Viewer';

  @override
  String get assignSaveButton => 'Zapisz';

  @override
  String deviceCardUser(Object username) {
    return 'Użytkownik: $username';
  }

  @override
  String get deviceCardAssignButton => 'Przypisz członka rodziny';

  @override
  String get deviceMenuEditUser => 'Edytuj użytkownika';

  @override
  String get deviceMenuUnassignUser => 'Odłącz użytkownika';

  @override
  String get deviceMenuRemoveDevice => 'Usuń urządzenie';

  @override
  String get bottomNavUsers => 'Użytkownicy';

  @override
  String get bottomNavZones => 'Strefy';

  @override
  String get bottomNavMenu => 'Menu';

  @override
  String get familyListTitle => 'Użytkownicy';

  @override
  String get familyEmptyTitle => 'Brak dodanych użytkowników';

  @override
  String get familyEmptyDescription =>
      'Dodaj członków rodziny, aby widzieć ich lokalizację i zarządzać ich urządzeniami.';

  @override
  String get familyAddFirstUserButton => 'Dodaj pierwszego użytkownika';

  @override
  String get familyAddUserButton => 'Dodaj członka rodziny';

  @override
  String familyCardInZones(Object zones) {
    return 'W strefach: $zones';
  }

  @override
  String familyCardDeviceInfo(Object batteryLevel, Object deviceName) {
    return '$deviceName - $batteryLevel% baterii';
  }

  @override
  String get familyManageButton => 'Zarządzaj';

  @override
  String get familyCreatorAddTitle => 'Dodaj nowego użytkownika';

  @override
  String get familyCreatorEditTitle => 'Zarządzaj użytkownikiem';

  @override
  String get familyCreatorDeleteConfirmTitle => 'Potwierdź usunięcie';

  @override
  String get familyCreatorDeleteConfirmContent =>
      'Czy na pewno chcesz trwale usunąć tego użytkownika? Tej operacji nie można cofnąć.';

  @override
  String get familyCreatorDeleteButton => 'Usuń użytkownika';

  @override
  String get familyCreatorStep1Title => 'Krok 1: Dane i urządzenie';

  @override
  String get familyCreatorLoginLabel => 'Login (unikalny)';

  @override
  String get familyCreatorPasswordMinLength =>
      'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get familyCreatorLinkDeviceButton => 'Połącz urządzenie';

  @override
  String get familyCreatorDeviceLinkedTo => 'Połączono z:';

  @override
  String get familyCreatorChangeDevice => 'Zmień urządzenie';

  @override
  String get familyCreatorDisconnectDevice => 'Rozłącz';

  @override
  String get familyCreatorBluetoothSearchTitle =>
      'Wyszukiwanie urządzeń Bluetooth';

  @override
  String get familyCreatorBluetoothScanning => 'Skanowanie...';

  @override
  String get familyCreatorStep2Title => 'Krok 2: Przypisanie do stref';

  @override
  String get familyCreatorStep2Description =>
      'Wybierz strefy, do których chcesz przypisać użytkownika. Ten krok jest opcjonalny.';

  @override
  String get familyCreatorNoZones =>
      'Brak zdefiniowanych stref. Utwórz strefę w odpowiedniej zakładce.';

  @override
  String get familyCreatorFinishButton => 'Zakończ';

  @override
  String get familyCreatorSaveChangesButton => 'Zapisz zmiany';

  @override
  String get zonesTitle => 'Strefy Bezpieczeństwa';

  @override
  String get zonesSearchHint => 'Szukaj strefy lub użytkownika...';

  @override
  String get zonesSearchResultZone => 'Strefa';

  @override
  String get zonesSearchResultUser => 'Użytkownik';

  @override
  String get zonesAddButton => 'Dodaj strefę';

  @override
  String get zonesCardAddress => 'Adres:';

  @override
  String get zonesCardUsersInZone => 'Użytkownicy w strefie:';

  @override
  String get zonesCardNoUsers => 'Brak';

  @override
  String get zonesCardModifyButton => 'Modyfikuj strefę';

  @override
  String get zonesEmptyTitle => 'Czym są strefy bezpieczeństwa?';

  @override
  String get zonesEmptyInfo1Title => 'Otrzymuj automatyczne powiadomienia';

  @override
  String get zonesEmptyInfo1Subtitle =>
      'gdy Twoi bliscy wejdą lub wyjdą z ważnych miejsc.';

  @override
  String get zonesEmptyInfo2Title => 'Ustaw strefy wokół domu, szkoły, pracy';

  @override
  String get zonesEmptyInfo2Subtitle => 'czy placu zabaw.';

  @override
  String get zonesEmptyInfo3Title =>
      'Bądź spokojny wiedząc, że Twoi bliscy są bezpieczni';

  @override
  String get zonesEmptyInfo3Subtitle => 'w określonych miejscach.';

  @override
  String get zoneCreatorAddTitle => 'Dodaj nową strefę';

  @override
  String get zoneCreatorEditTitle => 'Edytuj strefę';

  @override
  String get zoneCreatorStep1Title => 'Krok 1: Nazwa i ikona';

  @override
  String get zoneCreatorNameLabel => 'Nazwa strefy';

  @override
  String get zoneCreatorNameRequired => 'Nazwa jest wymagana';

  @override
  String get zoneCreatorSelectIcon => 'Wybierz ikonę:';

  @override
  String get zoneCreatorNextButton => 'Dalej';

  @override
  String get zoneCreatorStep2Title => 'Krok 2: Lokalizacja';

  @override
  String get zoneCreatorAddressHint => 'Wpisz adres lub wskaż na mapie';

  @override
  String zoneCreatorRadius(Object radius) {
    return 'Promień strefy: $radius m';
  }

  @override
  String get zoneCreatorStep3Title => 'Krok 3: Powiadomienia';

  @override
  String get zoneCreatorStep3Description =>
      'Dla których urządzeń chcesz otrzymywać powiadomienia o wejściu i wyjściu ze strefy?';

  @override
  String get zoneCreatorNoUsersToAssign =>
      'Brak zdefiniowanych użytkowników do przypisania.';

  @override
  String get zoneCreatorCreateButton => 'Utwórz strefę';

  @override
  String get zoneCreatorSuccessTitleAdd => 'Strefa została utworzona!';

  @override
  String get zoneCreatorSuccessTitleEdit => 'Strefa została zaktualizowana!';

  @override
  String get zoneCreatorSuccessDescription =>
      'Dzięki ustawieniu strefy zawsze otrzymasz automatyczny alert, gdy Twój Bliski wejdzie lub wyjdzie z wyznaczonego obszaru.';

  @override
  String get zoneCreatorGoToZonesButton => 'Przejdź do stref';

  @override
  String get zoneCreatorAddAnotherButton => 'Dodaj kolejną';

  @override
  String get zoneCreatorDeleteConfirmTitle => 'Potwierdź usunięcie';

  @override
  String get zoneCreatorDeleteConfirmContent =>
      'Czy na pewno chcesz trwale usunąć tę strefę? Tej operacji nie można cofnąć.';

  @override
  String get zoneCreatorDeleteButton => 'Usuń strefę';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuSectionAccount => 'Konto';

  @override
  String get menuManageAccount => 'Zarządzaj kontem';

  @override
  String get menuManageAccountSubtitle => 'Zmień e-mail lub hasło';

  @override
  String get menuSectionApp => 'Aplikacja';

  @override
  String get menuLanguage => 'Język';

  @override
  String get menuTheme => 'Motyw';

  @override
  String get menuLogout => 'Wyloguj';

  @override
  String get menuThemeLight => 'Jasny';

  @override
  String get menuThemeDark => 'Ciemny';

  @override
  String get menuThemeSystem => 'Systemowy';

  @override
  String get menuSelectThemeTitle => 'Wybierz motyw';

  @override
  String get menuSaveButton => 'Zapisz';
}
