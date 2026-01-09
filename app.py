import anthropic
import os
import dotenv

dotenv.load_dotenv()

client = anthropic.Anthropic()

response = client.beta.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=4096,
    betas=["code-execution-2025-08-25", "skills-2025-10-02"],
    container={
        "skills": [
            {
                "type": "anthropic",
                "skill_id": "pptx",
                "version": "latest"
            }
        ]
    },
    messages=[{
        "role": "user",
        "content": "Create a presentation about renewable energy"
    }],
    tools=[{
        "type": "code_execution_20250825",
        "name": "code_execution"
    }]
)

# Terminal commands have been moved to separate files:
# - create_pptx.ps1: PowerShell script for creating PPTX presentations
# - create_xlsx.sh: Bash script for creating Excel files and downloading them