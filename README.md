# Dedalus Mobile Application

Aplicación Flutter (Dedalus). Aquí las instrucciones para ejecutar la app y conectar el backend local (http://localhost:3000) desde un dispositivo Android físico o emulador.

## Requisitos
- Flutter SDK
- Android SDK (platform-tools con adb)
- Backend corriendo en tu máquina en el puerto 3000 (por ejemplo: `npm start` / `node index.js` / `dotnet run` según tu stack)

## Comandos útiles
PowerShell (desde la raíz del proyecto):
```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d <device-id>
```

## Ejecutar en un emulador Android
- Emulador Android estándar: usa `10.0.2.2` para acceder al localhost del host.
  - Ejemplo: `flutter run --dart-define=API_URL_Dedalus=http://10.0.2.2:3000`

## Ejecutar en un dispositivo Android físico (recomendado)
Tienes dos opciones principales:

A) Usar adb reverse (más sencillo, mantiene `http://localhost:3000` en el código)
1. Asegúrate de que adb esté en tu PATH (ejemplo si instalaste SDK en `D:\Android\Sdk\platform-tools`):
```powershell
# temporal para la sesión actual
$env:Path += ";D:\Android\Sdk\platform-tools"
where adb
adb version
```
2. Conecta el dispositivo por USB, autoriza la depuración y verifica:
```powershell
adb devices
# debe aparecer tu device id
```
3. Reenvía el puerto 3000 del dispositivo al PC:
```powershell
adb reverse tcp:3000 tcp:3000
```
4. Ejecuta la app (manteniendo `baseUrl = http://localhost:3000`):
```powershell
flutter run -d <device-id>
```
5. Para quitar el reenvío:
```powershell
adb reverse --remove-all
```

B) Usar la IP LAN de tu PC (si no quieres adb reverse)
1. Averigua tu IP local (ejemplo `192.168.1.10`):
```powershell
ipconfig
```
2. Asegúrate de que el backend escuche en `0.0.0.0` o en la interfaz de red y que el firewall permita conexiones al puerto 3000.
3. Ejecuta la app indicando la URL del API:
```powershell
flutter run --dart-define=API_URL_Dedalus=http://192.168.1.10:3000 -d <device-id>
```

## Qué cambiar en el proyecto (opcional)
- El servicio HTTP usa por defecto la variable de entorno `API_URL_Dedalus`. Puedes sobrescribirla con `--dart-define` (ver ejemplos arriba).
- Alternativa temporal en código: cambiar el valor por defecto dentro de `AuthService` / `BookingService` (no recomendado para commits).

## Comprobaciones si falla la conexión
- Desde el móvil, tras `adb reverse`, abre en el navegador: `http://localhost:3000/api/v1/` para confirmar acceso.
- Si usas IP LAN, abre `http://<your-pc-ip>:3000/api/v1/` en el móvil.
- Verifica que el backend escucha en `0.0.0.0` y no solo en `127.0.0.1`.
- Si adb no se reconoce, añade `D:\Android\Sdk\platform-tools` a tu PATH (ver pasos arriba).

## Atajos de desarrollo (hot reload / hot restart)
- Con `flutter run` en la terminal en la que la app esté corriendo:
  - `r` → hot reload
  - `R` → hot restart
  - `q` → salir

---

Si quieres, actualizo el valor por defecto de `_defaultBase` en `auth_service.dart` a `http://localhost:3000` o preparo un script PowerShell que haga `adb reverse` + `flutter run` automáticamente.
