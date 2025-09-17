// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Familia Segura';

  @override
  String get homeWelcomeTitle => 'Familia Segura';

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get registerButton => 'Registrarse';

  @override
  String get languagePolish => 'Polaco';

  @override
  String get languageEnglish => 'Inglés';

  @override
  String get languageGerman => 'Alemán';

  @override
  String get languageSpanish => 'Español';

  @override
  String get themeToggleLight => 'Cambiar a tema claro';

  @override
  String get themeToggleDark => 'Cambiar a tema oscuro';

  @override
  String get loginTitle => 'Iniciar sesión';

  @override
  String get loginUsernameLabel => 'Login / Nombre de usuario';

  @override
  String get loginPasswordLabel => 'Contraseña';

  @override
  String get loginRequiredField => 'Campo requerido';

  @override
  String get loginForgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerEmailLabel => 'Dirección de correo electrónico';

  @override
  String get registerPhoneLabel => 'Número de teléfono';

  @override
  String get registerUsernameLabel => 'Login / Nombre de usuario';

  @override
  String get registerPasswordLabel => 'Contraseña';

  @override
  String get registerContinueButton => 'Continuar';

  @override
  String get registerPasswordMinLength => 'Mínimo 6 caracteres';

  @override
  String get registerEmailToggle => 'Correo electrónico';

  @override
  String get registerPhoneToggle => 'Teléfono';

  @override
  String get recoveryTitle => 'Recuperación de cuenta';

  @override
  String get recoveryQuestion => '¿Qué has olvidado?';

  @override
  String get recoveryEmailLabel =>
      'Correo electrónico utilizado en el registro';

  @override
  String get recoverySendButton => 'Enviar recordatorio';

  @override
  String recoverySuccessMessage(Object email, Object recoveryItem) {
    return 'Se ha enviado un recordatorio ($recoveryItem) a: $email';
  }

  @override
  String get recoveryItemLogin => 'login';

  @override
  String get recoveryItemPassword => 'contraseña';

  @override
  String get recoveryInvalidEmail =>
      'Por favor, introduce una dirección de correo electrónico válida.';

  @override
  String get verifyCodeTitle => 'Verificación de código';

  @override
  String verifyCodeInstruction(Object emailOrPhone) {
    return 'Hemos enviado un código de verificación a:\n$emailOrPhone';
  }

  @override
  String get verifyCodeInputLabel => 'Código de 6 dígitos';

  @override
  String get verifyCodeInvalid => 'Introduce 6 dígitos';

  @override
  String get verifyButton => 'Verificar';

  @override
  String get setupFamilyTitle => 'Configuración familiar';

  @override
  String get setupFamilyDescription =>
      'Añade dispositivos y asígnales miembros de la familia.';

  @override
  String get setupSearchDeviceButton => 'Buscar y añadir dispositivo';

  @override
  String get setupNoDevices => 'Aún no se han añadido dispositivos.';

  @override
  String get setupFinishButton => 'Finalizar e iniciar sesión';

  @override
  String get searchDevicesTitle => 'Buscando dispositivos...';

  @override
  String get searchDevicesError => 'Error de búsqueda.';

  @override
  String get searchDevicesAllAdded =>
      'Todos los dispositivos encontrados ya han sido añadidos.';

  @override
  String get searchCancelButton => 'Cancelar';

  @override
  String assignToDeviceTitle(Object deviceName) {
    return 'Asignar a: $deviceName';
  }

  @override
  String get assignUsernameLabel => 'Login / Nombre';

  @override
  String get assignPasswordLabel => 'Contraseña (mín. 6 caracteres)';

  @override
  String get assignPermissionsLabel => 'Permisos';

  @override
  String get assignRoleStandard => 'Estándar';

  @override
  String get assignRoleViewer => 'Espectador';

  @override
  String get assignSaveButton => 'Guardar';

  @override
  String deviceCardUser(Object username) {
    return 'Usuario: $username';
  }

  @override
  String get deviceCardAssignButton => 'Asignar miembro de la familia';

  @override
  String get deviceMenuEditUser => 'Editar usuario';

  @override
  String get deviceMenuUnassignUser => 'Desasignar usuario';

  @override
  String get deviceMenuRemoveDevice => 'Eliminar dispositivo';

  @override
  String get bottomNavUsers => 'Usuarios';

  @override
  String get bottomNavZones => 'Zonas';

  @override
  String get bottomNavMenu => 'Menú';

  @override
  String get familyListTitle => 'Usuarios';

  @override
  String get familyEmptyTitle => 'No hay usuarios añadidos';

  @override
  String get familyEmptyDescription =>
      'Añade miembros de la familia para ver su ubicación y gestionar sus dispositivos.';

  @override
  String get familyAddFirstUserButton => 'Añadir primer usuario';

  @override
  String get familyAddUserButton => 'Añadir miembro de la familia';

  @override
  String familyCardInZones(Object zones) {
    return 'En zonas: $zones';
  }

  @override
  String familyCardDeviceInfo(Object batteryLevel, Object deviceName) {
    return '$deviceName - $batteryLevel% de batería';
  }

  @override
  String get familyManageButton => 'Gestionar';

  @override
  String get familyCreatorAddTitle => 'Añadir nuevo usuario';

  @override
  String get familyCreatorEditTitle => 'Gestionar usuario';

  @override
  String get familyCreatorDeleteConfirmTitle => 'Confirmar eliminación';

  @override
  String get familyCreatorDeleteConfirmContent =>
      '¿Estás seguro de que quieres eliminar permanentemente a este usuario? Esta acción no se puede deshacer.';

  @override
  String get familyCreatorDeleteButton => 'Eliminar usuario';

  @override
  String get familyCreatorStep1Title => 'Paso 1: Datos y dispositivo';

  @override
  String get familyCreatorLoginLabel => 'Login (único)';

  @override
  String get familyCreatorPasswordMinLength =>
      'La contraseña debe tener al menos 6 caracteres';

  @override
  String get familyCreatorLinkDeviceButton => 'Conectar dispositivo';

  @override
  String get familyCreatorDeviceLinkedTo => 'Conectado a:';

  @override
  String get familyCreatorChangeDevice => 'Cambiar dispositivo';

  @override
  String get familyCreatorDisconnectDevice => 'Desconectar';

  @override
  String get familyCreatorBluetoothSearchTitle =>
      'Buscando dispositivos Bluetooth';

  @override
  String get familyCreatorBluetoothScanning => 'Escaneando...';

  @override
  String get familyCreatorStep2Title => 'Paso 2: Asignación a zonas';

  @override
  String get familyCreatorStep2Description =>
      'Selecciona las zonas a las que quieres asignar al usuario. Este paso es opcional.';

  @override
  String get familyCreatorNoZones =>
      'No hay zonas definidas. Crea una zona en la pestaña correspondiente.';

  @override
  String get familyCreatorFinishButton => 'Finalizar';

  @override
  String get familyCreatorSaveChangesButton => 'Guardar cambios';

  @override
  String get zonesTitle => 'Zonas de Seguridad';

  @override
  String get zonesSearchHint => 'Buscar una zona o usuario...';

  @override
  String get zonesSearchResultZone => 'Zona';

  @override
  String get zonesSearchResultUser => 'Usuario';

  @override
  String get zonesAddButton => 'Añadir zona';

  @override
  String get zonesCardAddress => 'Dirección:';

  @override
  String get zonesCardUsersInZone => 'Usuarios en la zona:';

  @override
  String get zonesCardNoUsers => 'Ninguno';

  @override
  String get zonesCardModifyButton => 'Modificar zona';

  @override
  String get zonesEmptyTitle => '¿Qué son las zonas de seguridad?';

  @override
  String get zonesEmptyInfo1Title => 'Recibe notificaciones automáticas';

  @override
  String get zonesEmptyInfo1Subtitle =>
      'cuando tus seres queridos entren o salgan de lugares importantes.';

  @override
  String get zonesEmptyInfo2Title =>
      'Configura zonas alrededor de casa, escuela, trabajo';

  @override
  String get zonesEmptyInfo2Subtitle => 'o el patio de recreo.';

  @override
  String get zonesEmptyInfo3Title =>
      'Quédate tranquilo sabiendo que tus seres queridos están a salvo';

  @override
  String get zonesEmptyInfo3Subtitle => 'en lugares específicos.';

  @override
  String get zoneCreatorAddTitle => 'Añadir nueva zona';

  @override
  String get zoneCreatorEditTitle => 'Editar zona';

  @override
  String get zoneCreatorStep1Title => 'Paso 1: Nombre e icono';

  @override
  String get zoneCreatorNameLabel => 'Nombre de la zona';

  @override
  String get zoneCreatorNameRequired => 'El nombre es obligatorio';

  @override
  String get zoneCreatorSelectIcon => 'Selecciona un icono:';

  @override
  String get zoneCreatorNextButton => 'Siguiente';

  @override
  String get zoneCreatorStep2Title => 'Paso 2: Ubicación';

  @override
  String get zoneCreatorAddressHint =>
      'Introduce la dirección o selecciónala en el mapa';

  @override
  String zoneCreatorRadius(Object radius) {
    return 'Radio de la zona: $radius m';
  }

  @override
  String get zoneCreatorStep3Title => 'Paso 3: Notificaciones';

  @override
  String get zoneCreatorStep3Description =>
      '¿Para qué dispositivos quieres recibir notificaciones sobre la entrada y salida de la zona?';

  @override
  String get zoneCreatorNoUsersToAssign =>
      'No hay usuarios definidos para asignar.';

  @override
  String get zoneCreatorCreateButton => 'Crear zona';

  @override
  String get zoneCreatorSuccessTitleAdd => '¡La zona ha sido creada!';

  @override
  String get zoneCreatorSuccessTitleEdit => '¡La zona ha sido actualizada!';

  @override
  String get zoneCreatorSuccessDescription =>
      'Al configurar una zona, siempre recibirás una alerta automática cuando tu ser querido entre o salga del área designada.';

  @override
  String get zoneCreatorGoToZonesButton => 'Ir a las zonas';

  @override
  String get zoneCreatorAddAnotherButton => 'Añadir otra';

  @override
  String get zoneCreatorDeleteConfirmTitle => 'Confirmar eliminación';

  @override
  String get zoneCreatorDeleteConfirmContent =>
      '¿Estás seguro de que quieres eliminar permanentemente esta zona? Esta acción no se puede deshacer.';

  @override
  String get zoneCreatorDeleteButton => 'Eliminar zona';

  @override
  String get menuTitle => 'Menú';

  @override
  String get menuSectionAccount => 'Cuenta';

  @override
  String get menuManageAccount => 'Gestionar cuenta';

  @override
  String get menuManageAccountSubtitle =>
      'Cambiar correo electrónico o contraseña';

  @override
  String get menuSectionApp => 'Aplicación';

  @override
  String get menuLanguage => 'Idioma';

  @override
  String get menuTheme => 'Tema';

  @override
  String get menuLogout => 'Cerrar sesión';

  @override
  String get menuThemeLight => 'Claro';

  @override
  String get menuThemeDark => 'Oscuro';

  @override
  String get menuThemeSystem => 'Sistema';

  @override
  String get menuSelectThemeTitle => 'Seleccionar tema';

  @override
  String get menuSaveButton => 'Guardar';
}
