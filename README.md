# aitools

PowerShell module for interacting with the AI Toolkit API

## Description

The aitools module provides a set of PowerShell functions to interact with the AI Toolkit API. It allows you to retrieve available models, load and unload models, retrieve loaded models, create chat completions, and configure the API settings.

## Installation

You can install the aitools module from the PowerShell Gallery using the following command:

```powershell
Install-Module -Name aitools
```

## Usage

To use the aitools module, you need to import it into your PowerShell session:

```powershell
Import-Module -Name aitools
```

### Available Functions

- `Get-AITModel`: Retrieves the list of available models from the AI Toolkit API.
- `Mount-AITModel`: Loads a specific model in the AI Toolkit API.
- `Dismount-AITModel`: Unloads a specific model from the AI Toolkit API.
- `Get-AITMountedModel`: Retrieves the list of currently loaded models from the AI Toolkit API.
- `Request-AITChatCompletion`: Creates a chat completion using the specified model and input in the AI Toolkit API.
- `Set-AITConfig`: Sets the configuration values for the aitools module.

### Examples

1. Retrieve the list of available models:
   ```powershell
   Get-AITModel
   ```

2. Load a specific model:
   ```powershell
   Mount-AITModel -Model mistral-7b-v02-int4-cpu
   ```

3. Unload a specific model:
   ```powershell
   Dismount-AITModel -Model mistral-7b-v02-int4-cpu
   ```

4. Retrieve the list of loaded models:
   ```powershell
   Get-AITMountedModel
   ```

5. Create a chat completion:
   ```powershell
   Request-AITChatCompletion -Model mistral-7b-v02-int4-cpu -Message "Hello, how are you?"
   ```

6. Set the configuration:
   ```powershell
   Set-AITConfig -BaseUrl "http://localhost:8080"
   ```

## Configuration

The aitools module uses the `$script:aitoolsBaseUrl` variable to store the base URL of the AI Toolkit API. You can set this value using the `Set-AITConfig` cmdlet. By default, the base URL is set to `"http://localhost:5272"`.

## Contributing

Contributions to the aitools module are welcome! If you find any issues or have suggestions for improvements, please open an issue or submit a pull request on the module's GitHub repository.

## License

The aitools module is released under the [MIT License](LICENSE).
