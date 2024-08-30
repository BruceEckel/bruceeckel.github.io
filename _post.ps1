function Generate-FileName {
    param (
        [string]$Title
    )

    $date = Get-Date -Format 'yyyy-MM-dd'
    $formattedTitle = $Title -replace '\s+', '-'
    $fileName = "$date-$formattedTitle.md"

    return $fileName
}

try {
    $title = Read-Host 'Please enter the title'
    $fileName = Generate-FileName -Title $title
    $subdirectory = '_posts'

    if (-not (Test-Path $subdirectory)) {
        New-Item -ItemType Directory -Path $subdirectory | Out-Null
    }

    $filePath = Join-Path -Path $subdirectory -ChildPath $fileName
    $date = Get-Date -Format 'yyyy-MM-dd'

    $content = @"
---
title: "$title"
date: $date
---
"@

    $content | Out-File -FilePath $filePath -Encoding utf8

    Write-Host "File created: $filePath"
}
catch {
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
