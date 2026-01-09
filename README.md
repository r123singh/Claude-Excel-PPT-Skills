# Claude Skills on Claude API using PowerShell and Bash scripts

Generate PowerPoint presentations and Excel spreadsheets using Anthropic's Claude Skills API using PowerShell and Bash scripts.

[Terminal](output.png)

## Overview

Want to generate PowerPoint presentations or Excel spreadsheets using AI? This repository demonstrates how to use **Claude Skills API** to create professional documents programmatically using PowerShell and Bash scripts. Claude Skills are pre-built capabilities that allow Claude to perform specific tasks like creating PPTX files or XLSX spreadsheets.

## Features

- 🎯 **PowerPoint Generation**: Create PPTX presentations using the `pptx` skill
- 📊 **Excel Generation**: Create XLSX spreadsheets using the `xlsx` skill
- 🐍 **Python SDK**: Easy-to-use Python examples with the Anthropic SDK
- 💻 **Terminal Scripts**: PowerShell and Bash scripts for command-line usage
- 📥 **File Download**: Automatically download generated files using the Files API

## Prerequisites

- PowerShell 5.1+ or PowerShell 7+ (for `.ps1` scripts)
- Bash (for `.sh` scripts)
- Anthropic API Key ([Get one here](https://console.anthropic.com/))
- `jq` (for Bash scripts - optional, for JSON parsing)

## Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd claude-skills-api
   ```

2. **Install Python dependencies(optional and for python script only)**
   ```bash
   pip install anthropic python-dotenv
   ```

3. **Set up environment variables**
   
   Or set it in your terminal:
   
   **PowerShell:**
   ```powershell
   $env:ANTHROPIC_API_KEY = "your-api-key-here"
   ```
   
   **Bash:**
   ```bash
   export ANTHROPIC_API_KEY="your-api-key-here"
   ```

## Usage

### Python SDK

Run the Python script to create a PowerPoint presentation:

```bash
python app.py
```

The script uses the Anthropic Python SDK to create a presentation about renewable energy using the `pptx` skill.

### PowerShell Scripts

#### Create PowerPoint Presentation

```powershell
.\create_pptx.ps1
```

This script:
1. Creates a PPTX presentation using Claude's `pptx` skill
2. Extracts the file ID from the response
3. Retrieves the filename from metadata
4. Downloads the file to your current directory

#### Create Excel Spreadsheet

```powershell
.\create_xlsx.ps1
```

This script:
1. Creates an XLSX spreadsheet using Claude's `xlsx` skill
2. Extracts the file ID from the response
3. Retrieves the filename from metadata
4. Downloads the file to your current directory

**Note:** If you encounter execution policy errors, run:
```powershell
powershell -ExecutionPolicy Bypass -File .\create_xlsx.ps1
```

### Bash Scripts

#### Create Excel Spreadsheet (Linux/Mac/Git Bash)

```bash
chmod +x create_xlsx.sh
./create_xlsx.sh
```

**Note:** Requires `jq` for JSON parsing. Install with:
- Ubuntu/Debian: `sudo apt-get install jq`
- macOS: `brew install jq`

## Project Structure

```
claude-skills-api/
├── app.py                 # Python SDK example for PPTX generation
├── create_pptx.ps1       # PowerShell script for PPTX generation
├── create_xlsx.ps1       # PowerShell script for XLSX generation
├── create_xlsx.sh        # Bash script for XLSX generation
├── README.md             # This file
└── .env                  # Environment variables (create this)
```

## How It Works

### Claude Skills

Claude Skills are specialized capabilities that extend Claude's functionality. This project uses:

- **`pptx` skill**: Generates PowerPoint presentations
- **`xlsx` skill**: Generates Excel spreadsheets

### API Flow

1. **Create Message**: Send a request to Claude with a skill enabled
2. **Execute Code**: Claude uses code execution to create the file
3. **Extract File ID**: Parse the response to find the generated file ID
4. **Get Metadata**: Retrieve file information (filename, size, etc.)
5. **Download File**: Download the file using the Files API

### Example Request

```json
{
  "model": "claude-sonnet-4-5-20250929",
  "max_tokens": 4096,
  "container": {
    "skills": [
      {
        "type": "anthropic",
        "skill_id": "pptx",
        "version": "latest"
      }
    ]
  },
  "messages": [{
    "role": "user",
    "content": "Create a presentation about renewable energy"
  }],
  "tools": [{
    "type": "code_execution_20250825",
    "name": "code_execution"
  }]
}
```

## Customization

### Change the Prompt

Edit the `content` field in the `messages` array to generate different content:

**PowerPoint:**
```powershell
content = "Create a presentation about artificial intelligence"
```

**Excel:**
```powershell
content = "Create a sales report spreadsheet for Q4 2024"
```

### Use Different Skills

Replace the `skill_id` to use different skills:
- `"pptx"` - PowerPoint presentations
- `"xlsx"` - Excel spreadsheets
- `"docx"` - Word documents (if available)
- `"pdf"` - PDF documents (if available)

## API Reference

- **Anthropic API Documentation**: https://docs.anthropic.com/
- **Claude Skills**: https://docs.anthropic.com/claude/docs/skills
- **Files API**: https://docs.anthropic.com/claude/docs/files-api

## Troubleshooting

### PowerShell Execution Policy Error

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Missing API Key

Make sure `ANTHROPIC_API_KEY` is set:
```powershell
# PowerShell
$env:ANTHROPIC_API_KEY

# Bash
echo $ANTHROPIC_API_KEY
```

### File Not Found Error

If the script can't find the file ID, check:
1. The API response structure may have changed
2. Ensure the skill executed successfully
3. Check the response JSON for error messages

## License

This project is provided as-is for educational and demonstration purposes.

## Contributing

Feel free to submit issues or pull requests to improve this project!

## Support

For issues related to:
- **Claude Skills API**: Check [Anthropic Documentation](https://docs.anthropic.com/)
- **This Project**: Open an issue in this repository
