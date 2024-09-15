# Comprobar si el script se está ejecutando con permisos de administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    # Si no tiene permisos de administrador, reiniciar con permisos elevados
    Write-Output "No tienes permisos de administrador. Solicitando permisos elevados..."
    Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File "', $PSCommandPath, '"' -Verb RunAs
    exit
}

# Mensaje de bienvenida con información de autoría sutil
Write-Host "Initializing system audit... Please wait." -ForegroundColor Cyan
Start-Sleep -Seconds 2  # Pausa breve para el efecto

# Info
Write-Host "Audit Script v1.0 - Powered by UfoTech IT Solutions" -ForegroundColor Green
Start-Sleep -Seconds 1  # Pausa
Write-Host "For more information, visit www.nicolaspintos.com" -ForegroundColor Green

# Pedir información al usuario
$numero_maquina = Read-Host "Introduce el numero de la maquina"
$marca_notebook = Read-Host "Introduce la modelo/marca"
$area_trabajo = Read-Host "Introduce el area de trabajo"
$usuario = Read-Host "Introduce el nombre del usuario"

# Crear la subcarpeta "Resultados" en la ubicación del script
$ruta_carpeta_resultados = Join-Path -Path (Split-Path -Parent $PSCommandPath) -ChildPath "Resultados"
if (-not (Test-Path -Path $ruta_carpeta_resultados)) {
    New-Item -Path $ruta_carpeta_resultados -ItemType Directory -Force | Out-Null
}

# Crear el nombre del archivo de salida
$nombre_archivo = "$numero_maquina`_$usuario`_$area_trabajo.txt"
$ruta_archivo = Join-Path -Path $ruta_carpeta_resultados -ChildPath $nombre_archivo
#Mensaje de espera
Write-host "Verificando Windows, Office y detalles del sistema, por favor aguarde..." -ForegroundColor Green

# Obtener detalles del sistema
$hostname = hostname
$os = Get-WmiObject Win32_OperatingSystem | Select-Object -Property Caption, Version, OSArchitecture
$cpu = Get-WmiObject Win32_Processor | Select-Object -Property Name, NumberOfCores, NumberOfLogicalProcessors
$ram_slots = Get-WmiObject -Class "Win32_PhysicalMemory" | Select-Object BankLabel, Capacity, Manufacturer, Speed
$ram_total = [math]::round((Get-WmiObject Win32_ComputerSystem).TotalPhysicalMemory/1GB, 2)
$disks = Get-WmiObject Win32_DiskDrive | Select-Object Model, InterfaceType, MediaType, Size

# Verificar activación de Windows usando WMI
$windows_activation_info = Get-WmiObject -Query "SELECT * FROM SoftwareLicensingProduct WHERE PartialProductKey <> null AND LicenseStatus = 1 AND Description LIKE 'Windows%'" | Select-Object -First 1

$windows_status = "Desconocido"
if ($windows_activation_info) {
    $windows_status = "Windows activado legalmente"
} else {
    $windows_status = "Windows no esta activado o activacion no reconocida"
}

# Verificar activación de Office y obtener detalles
$office_paths = @(
    "C:\Program Files (x86)\Microsoft Office\Office16",
    "C:\Program Files\Microsoft Office\Office16",
    "C:\Program Files (x86)\Microsoft Office\Office15",
    "C:\Program Files\Microsoft Office\Office15"
)

$office_status = "Desconocido"
$office_version = "No detectado"
foreach ($path in $office_paths) {
    if (Test-Path "$path\OSPP.VBS") {
        # Ejecutar OSPP.VBS para obtener detalles de activación de Office
        $office_activation_output = cscript "$path\OSPP.VBS" /dstatus 2>&1 | Out-String
        if ($office_activation_output -match "KMS") {
            $office_status = "Office activado con KMS"
        } elseif ($office_activation_output -match "Retail" -or $office_activation_output -match "OEM" -or $office_activation_output -match "licensed") {
            $office_status = "Office original o activado legalmente"
        } else {
            $office_status = "Office no esta activado o activacion no reconocida"
        }

        # Detectar la versión de Office
        if ($office_activation_output -match "Microsoft Office (.*?) -") {
            $office_version = $matches[1]
        }
        break
    }
}

# Crear el contenido del archivo
$contenido = @"
Numero de Maquina: $numero_maquina
Marca de la Notebook: $marca_notebook
Area de Trabajo: $area_trabajo
Usuario: $usuario

Hostname: $hostname
Sistema Operativo: $($os.Caption) $($os.Version) ($($os.OSArchitecture))
CPU: $($cpu.Name) - Nucleos: $($cpu.NumberOfCores) - Procesadores Logicos: $($cpu.NumberOfLogicalProcessors)
RAM Total: $ram_total GB

Ranuras de Memoria (Slots) Usadas:
"@

foreach ($slot in $ram_slots) {
    $ram_size_gb = [math]::round($slot.Capacity/1GB, 2)
    $contenido += "Slot: $($slot.BankLabel) - Capacidad: $ram_size_gb GB - Fabricante: $($slot.Manufacturer) - Velocidad: $($slot.Speed) MHz`r`n"
}

$contenido += "`r`nInformacion de Discos Duros:`r`n"

foreach ($disk in $disks) {
    $disk_type = if ($disk.MediaType -like "*SSD*") { "SSD" } else { "HDD" }
    $contenido += "Modelo: $($disk.Model) - Tipo: $disk_type - Interfaz: $($disk.InterfaceType) - Tamano: $([math]::round($disk.Size/1GB, 2)) GB`r`n"
}

$contenido += "`r`nEstado de Activacion de Windows: $windows_status`r`n"
$contenido += "`r`nEstado de Activacion de Microsoft Office: $office_status`r`n"
$contenido += "`r`nVersion de Microsoft Office: $office_version`r`n"

# Mostrar resultados en la consola
Write-Output $contenido

# Guardar el archivo en la carpeta "Resultados" con codificación UTF-8
$contenido | Out-File -FilePath $ruta_archivo -Encoding utf8

# Mostrar mensaje de confirmación
Write-Output "El archivo se ha guardado en: $ruta_archivo"

# Pausa para mantener la consola abierta
Write-Host "Presiona cualquier tecla para salir..." -NoNewLine
[void][System.Console]::ReadKey($true)

