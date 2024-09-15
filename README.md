# Scripts de Auditoría de TI

Este repositorio contiene scripts para realizar auditorías de sistemas en equipos con Windows. Los scripts están diseñados para recopilar información del sistema, verificar activaciones de software y ayudar a los administradores a mantener su infraestructura de manera eficiente.

## Archivos Incluidos

- **`system_audit_script.ps1`**: Un script de PowerShell que recopila detalles del sistema, como el nombre del host, versión del sistema operativo, especificaciones de la CPU, ranuras de RAM, detalles del disco y verifica el estado de activación de Windows y Microsoft Office.
- **`iniciar.bat`**: Un archivo por lotes para iniciar la ejecución del script.

## Funcionalidades

- **Recopilación de Información del Sistema**: Obtiene detalles como el nombre del host, la versión del sistema operativo, las especificaciones de la CPU, la RAM y la información del disco.
- **Verificación de Activación de Windows**: Verifica si Windows está activado legalmente.
- **Verificación de Activación de Microsoft Office**: Comprueba el estado de activación de Microsoft Office y su versión.
- **Salida de Resultados**: Guarda la información recopilada en un archivo de texto ubicado en la carpeta "Resultados".

## Requisitos Previos

- **Windows PowerShell**: El script está diseñado para ejecutarse en PowerShell en sistemas Windows.
- **Privilegios de Administrador**: El script debe ejecutarse con privilegios de administrador para recopilar toda la información necesaria.

## Uso

1. Clonar el Repositorio: 
   ```sh
   git clone https://github.com/generiz/it-audit-scripts.git
   
2. Ejecutar el Archivo por Lotes:

Haz doble clic en iniciar.bat para iniciar el script de PowerShell.
3. Seguir las Instrucciones en Pantalla:

Introduce los detalles requeridos cuando se te solicite (número de máquina, modelo/marca, área de trabajo, nombre del usuario).
4. Revisar los Resultados:

Los resultados se guardarán en un archivo de texto dentro de la carpeta "Resultados" en el directorio del script.

Nota de Seguridad
Asegúrate de ejecutar el script en un entorno seguro, ya que recopila información sensible del sistema.
Mantén los archivos de salida protegidos y seguros, especialmente si se almacenan en sistemas compartidos o en red.

Contribuciones
¡Las contribuciones, reportes de errores y solicitudes de nuevas funcionalidades son bienvenidas! No dudes en revisar la página de issues.

Licencia
Este proyecto está licenciado bajo la Licencia GNU GPL v3 - consulta el archivo LICENSE para más detalles.

Autor
Desarrollado por Nicolás Pintos - www.nicolaspintos.com


