# PS-UtilityLib

## Description

PS-UtilityLib is a PowerShell module library designed to offer reusable functionalities commonly required in PowerShell scripting. It aims to streamline PowerShell development by providing a range of utility functions that can be easily imported into any script.

## Features

- **Test-AdminPrivilege**: Checks if the script has administrator privileges and restarts with them if not.
- _More utility functions coming soon_

## Installation

1. Clone the repository.
    ```bash
    git clone https://github.com/Doron-Bogomolov/PS-UtilityLib.git
    ```
   **Note**: You can run this command in Git Bash or PowerShell. Make sure you have Git installed. If not, you can download and install it from [here](https://git-scm.com/download/win).

2. Import the module.
    ```powershell
    Import-Module ./path/to/PS-UtilityLib.psm1
    ```

## Usage

Here's an example of how to use `Test-AdminPrivilege` from this library:

```powershell
# Import the library
Import-Module ./path/to/PS-UtilityLib.psm1
```

# Use the Test-AdminPrivilege function
```powershell
Test-AdminPrivilege
```

## Contributing

We welcome contributions! Please read the [contributing guidelines](CONTRIBUTING.md) before getting started.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
