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

## Acceso rápido al backend local desde el móvil (USB / Wi‑Fi)

Si quieres automatizar el flujo para que la app en el móvil use el backend que tienes en tu PC (localhost:3000), aquí tienes pasos y un script.

Requisitos
- adb en PATH (ej. D:\Android\Sdk\platform-tools)
- PC y móvil en la misma red si usas Wi‑Fi
- Backend corriendo en el puerto 3000

A) Usar adb reverse (por USB — mantiene http://localhost:3000 en la app)
1. Conectar el dispositivo por USB y autorizar la depuración.
2. Ejecutar:
```powershell
adb devices
adb reverse tcp:3000 tcp:3000
```
3. Ejecutar la app:
```powershell
flutter run -d <device-id>
```
4. Para quitar el reenvío:
```powershell
adb reverse --remove-all
```

B) Depuración por Wi‑Fi (adb over TCP)
1. Conectar el móvil por USB (una vez).
2. Poner adb en modo TCP:
```powershell
adb tcpip 5555
```
3. Obtener la IP del móvil (ej. 192.168.0.19) y conectar por IP:
```powershell
adb connect 192.168.0.19:5555
adb devices
```
4. (Opcional) reenviar puerto 3000:
```powershell
adb reverse tcp:3000 tcp:3000
```
5. Ejecutar la app inalámbrica:
```powershell
flutter run -d 192.168.0.19:5555
```
6. Para volver a USB:
```powershell
adb disconnect 192.168.0.19:5555
adb usb
adb reverse --remove-all
```

Comprobaciones rápidas
- Desde el móvil (tras adb reverse) abre: http://localhost:3000/api/v1/
- Si usas IP LAN: abre http://<TU_PC_IP>:3000/api/v1/ en el navegador del móvil.
- Si adb no está en PATH, agrega `D:\Android\Sdk\platform-tools` al Path o ejecuta temporalmente:
```powershell
$env:Path += ";D:\Android\Sdk\platform-tools"
```

## Script PowerShell opcional
En la carpeta `scripts/` puedes añadir un script para ejecutar adb reverse y lanzar flutter run automáticamente (ejecutar en PowerShell desde la raíz del proyecto):

```powershell
# script para adb reverse y flutter run
$deviceId = "<tu-device-id>" # Cambia esto por tu device id
$apiUrl = "http://localhost:3000"

adb reverse tcp:3000 tcp:3000
flutter run -d $deviceId --dart-define=API_URL_Dedalus=$apiUrl
```

---

Si quieres, actualizo el valor por defecto de `_defaultBase` en `auth_service.dart` a `http://localhost:3000` o preparo un script PowerShell que haga `adb reverse` + `flutter run` automáticamente.
