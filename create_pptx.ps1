# PowerShell script to create a PPTX presentation using Anthropic API and download it
# Usage: .\create_pptx.ps1
# Note: Requires PowerShell 7+ for better JSON handling, or use ConvertFrom-Json

# Step 1: Use a Skill to create a file
$headers = @{
    "x-api-key" = $env:ANTHROPIC_API_KEY
    "anthropic-version" = "2023-06-01"
    "anthropic-beta" = "code-execution-2025-08-25,skills-2025-10-02"
    "content-type" = "application/json"
}
$body = @{
    model = "claude-sonnet-4-5-20250929"
    max_tokens = 4096
    container = @{
        skills = @(
            @{
                type = "anthropic"
                skill_id = "pptx"
                version = "latest"
            }
        )
    }
    messages = @(
        @{
            role = "user"
            content = "Create a presentation about renewable energy"
        }
    )
    tools = @(
        @{
            type = "code_execution_20250825"
            name = "code_execution"
        }
    )
} | ConvertTo-Json -Depth 10

$response = Invoke-RestMethod -Method Post -Uri "https://api.anthropic.com/v1/messages" -Headers $headers -Body $body

# Format response as JSON for better readability
$response | ConvertTo-Json -Depth 20 | Write-Host

# Or save to file
# $response | ConvertTo-Json -Depth 20 | Out-File -FilePath "response.json" -Encoding utf8

# Or extract specific fields
# Write-Host "Message ID: $($response.id)"
# Write-Host "Role: $($response.role)"
# Write-Host "Stop Reason: $($response.stop_reason)"
# Write-Host "Usage - Input Tokens: $($response.usage.input_tokens), Output Tokens: $($response.usage.output_tokens)"


# Step 2: Extract file_id from response
$fileId = $null
foreach ($contentItem in $response.content) {
    if ($contentItem.type -eq "bash_code_execution_tool_result") {
        if ($contentItem.content.type -eq "bash_code_execution_result") {
            foreach ($item in $contentItem.content.content) {
                if ($item.file_id) {
                    $fileId = $item.file_id
                    break
                }
            }
        }
    }
}
if (-not $fileId) {
    Write-Error "Could not find file_id in response"
    exit 1
}

# Step 3: Get filename from metadata
$fileHeaders = @{
    "x-api-key" = $env:ANTHROPIC_API_KEY
    "anthropic-version" = "2023-06-01"
    "anthropic-beta" = "files-api-2025-04-14"
}
$fileMetadata = Invoke-RestMethod -Method Get -Uri "https://api.anthropic.com/v1/files/$fileId" -Headers $fileHeaders
$filename = $fileMetadata.filename

# Step 4: Download the file using Files API
$downloadHeaders = @{
    "x-api-key" = $env:ANTHROPIC_API_KEY
    "anthropic-version" = "2023-06-01"
    "anthropic-beta" = "files-api-2025-04-14"
}
Invoke-RestMethod -Method Get -Uri "https://api.anthropic.com/v1/files/$fileId/content" -Headers $downloadHeaders -OutFile $filename

Write-Host "Downloaded: $filename"

exit 0
