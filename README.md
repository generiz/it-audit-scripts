# Windows Inventory Scripts

Small PowerShell utility for collecting hardware and activation information from Windows machines during IT support and inventory work.

**Status:** operations tool. It is not an endpoint-management platform, compliance scanner or security-audit suite.

## What it collects

`system_audit_script.ps1` records information such as:

- hostname and Windows version
- CPU information
- RAM slots and installed memory
- disk information
- Windows activation state
- Microsoft Office version and activation state
- operator-supplied inventory context such as machine number, model, area and user

Results are written to the local `Resultados` directory.

## Requirements

- Windows
- Windows PowerShell
- Administrator privileges for complete collection

## Use

Clone the repository:

```powershell
git clone https://github.com/generiz/it-audit-scripts.git
```

Run `iniciar.bat`, follow the prompts and review the generated text file under `Resultados`.

## Data handling

The generated output can contain system and user information that should be treated as operationally sensitive. Do not publish result files or leave them in shared locations without an explicit reason.

The script reads local system information; it does not provide continuous monitoring, remote collection, vulnerability scanning or centralized reporting.

## Files

```text
system_audit_script.ps1   inventory and activation collection
iniciar.bat               launcher
Resultados/               generated local output
```

## License

GPL-3.0
