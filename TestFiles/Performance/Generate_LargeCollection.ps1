# Generate_LargeCollection.ps1
# Creates 1,200 test files for PER-04: Large Collection Test
# Purpose: Validate UI performance with very large collections

Write-Host "=== Large Collection Generator for PER-04 ===" -ForegroundColor Cyan
Write-Host "Creating 1,200 test files across multiple folders..." -ForegroundColor Yellow

# Create base directory structure
$baseDir = "LargeCollection_1200Items"
$folders = @(
    "Documentation\User Guides",
    "Documentation\Admin Guides",
    "Documentation\API Documentation",
    "Documentation\Release Notes",
    "Data\Analytics",
    "Data\Reports",
    "Data\Raw Data",
    "Training\Presentations",
    "Training\Videos",
    "Training\Exercises",
    "Policies\Security",
    "Policies\Compliance",
    "Policies\HR"
)

# Create folder structure
foreach ($folder in $folders) {
    $fullPath = Join-Path $baseDir $folder
    if (-not (Test-Path $fullPath)) {
        New-Item -Path $fullPath -ItemType Directory -Force | Out-Null
    }
}

Write-Host "Created folder structure" -ForegroundColor Green

# File generation configurations
$fileConfigs = @(
    # Documentation/User Guides (150 files)
    @{ Path = "Documentation\User Guides"; Prefix = "UserGuide"; Count = 150; Extensions = @(".pdf", ".docx"); Size = 50KB },
    
    # Documentation/Admin Guides (100 files)
    @{ Path = "Documentation\Admin Guides"; Prefix = "AdminGuide"; Count = 100; Extensions = @(".pdf", ".docx"); Size = 60KB },
    
    # Documentation/API Documentation (80 files)
    @{ Path = "Documentation\API Documentation"; Prefix = "API_Docs"; Count = 80; Extensions = @(".pdf", ".md"); Size = 40KB },
    
    # Documentation/Release Notes (70 files)
    @{ Path = "Documentation\Release Notes"; Prefix = "ReleaseNotes"; Count = 70; Extensions = @(".txt", ".md"); Size = 30KB },
    
    # Data/Analytics (150 files)
    @{ Path = "Data\Analytics"; Prefix = "Analytics"; Count = 150; Extensions = @(".csv", ".json"); Size = 100KB },
    
    # Data/Reports (100 files)
    @{ Path = "Data\Reports"; Prefix = "Report"; Count = 100; Extensions = @(".csv", ".pdf"); Size = 80KB },
    
    # Data/Raw Data (100 files)
    @{ Path = "Data\Raw Data"; Prefix = "RawData"; Count = 100; Extensions = @(".csv", ".json"); Size = 120KB },
    
    # Training/Presentations (200 files)
    @{ Path = "Training\Presentations"; Prefix = "Presentation"; Count = 200; Extensions = @(".pptx", ".pdf"); Size = 200KB },
    
    # Training/Videos (50 metadata files)
    @{ Path = "Training\Videos"; Prefix = "Video_Metadata"; Count = 50; Extensions = @(".json"); Size = 5KB },
    
    # Training/Exercises (100 files)
    @{ Path = "Training\Exercises"; Prefix = "Exercise"; Count = 100; Extensions = @(".docx", ".pdf"); Size = 70KB },
    
    # Policies/Security (50 files)
    @{ Path = "Policies\Security"; Prefix = "Security_Policy"; Count = 50; Extensions = @(".pdf", ".docx"); Size = 90KB },
    
    # Policies/Compliance (30 files)
    @{ Path = "Policies\Compliance"; Prefix = "Compliance"; Count = 30; Extensions = @(".pdf"); Size = 100KB },
    
    # Policies/HR (20 files)
    @{ Path = "Policies\HR"; Prefix = "HR_Policy"; Count = 20; Extensions = @(".pdf", ".docx"); Size = 80KB }
)

# Generate files
$totalCreated = 0
$chunk = New-Object byte[] 1KB

foreach ($config in $fileConfigs) {
    $folderPath = Join-Path $baseDir $config.Path
    
    Write-Host "`nGenerating $($config.Count) files in $($config.Path)..." -ForegroundColor Yellow
    
    for ($i = 1; $i -le $config.Count; $i++) {
        # Rotate through extensions
        $ext = $config.Extensions[($i - 1) % $config.Extensions.Count]
        
        # Generate filename with timestamp variation
        $timestamp = (Get-Date).AddDays(-($i % 365)).ToString("yyyy-MM-dd")
        $fileName = "$($config.Prefix)_$($i.ToString('D4'))_$timestamp$ext"
        $filePath = Join-Path $folderPath $fileName
        
        # Create file with appropriate content based on extension
        try {
            switch ($ext) {
                ".json" {
                    # Create JSON metadata
                    $jsonContent = @{
                        id = "DOC-$($totalCreated + $i)"
                        title = "$($config.Prefix) $i"
                        created = $timestamp
                        category = $config.Path.Split('\')[0]
                        subcategory = $config.Path.Split('\')[-1]
                        version = "1.$($i % 10)"
                        author = "Test User $($i % 20)"
                        tags = @("test", "documentation", "generated")
                        fileSize = $config.Size
                    } | ConvertTo-Json -Depth 3
                    
                    [System.IO.File]::WriteAllText($filePath, $jsonContent, [System.Text.Encoding]::UTF8)
                }
                
                ".csv" {
                    # Create CSV with sample data
                    $csvContent = "ID,Name,Value,Date,Category`n"
                    for ($row = 1; $row -le 100; $row++) {
                        $csvContent += "$row,Item$row,$($row * 100),$timestamp,Category$($row % 5)`n"
                    }
                    [System.IO.File]::WriteAllText($filePath, $csvContent, [System.Text.Encoding]::UTF8)
                }
                
                ".md" {
                    # Create Markdown documentation
                    $mdContent = @"
# $($config.Prefix) $i

**Document ID:** DOC-$($totalCreated + $i)
**Created:** $timestamp
**Version:** 1.$($i % 10)

## Overview
This is a test document for the large collection performance test (PER-04).

## Sections
- Section 1: Introduction
- Section 2: Details
- Section 3: Specifications
- Section 4: Conclusion

---
Generated for testing purposes.
"@
                    [System.IO.File]::WriteAllText($filePath, $mdContent, [System.Text.Encoding]::UTF8)
                }
                
                default {
                    # For .pdf, .docx, .pptx, .txt - create binary placeholder
                    $stream = [System.IO.File]::OpenWrite($filePath)
                    $iterations = [math]::Ceiling($config.Size / 1KB)
                    
                    for ($j = 0; $j -lt $iterations; $j++) {
                        # Fill chunk with varying data
                        for ($k = 0; $k -lt 1KB; $k++) {
                            $chunk[$k] = ($j + $k + $i) % 256
                        }
                        $stream.Write($chunk, 0, 1KB)
                    }
                    
                    $stream.Close()
                }
            }
            
            $totalCreated++
            
            # Progress indicator every 50 files
            if ($totalCreated % 50 -eq 0) {
                Write-Host "  Progress: $totalCreated files created..." -ForegroundColor Gray
            }
            
        } catch {
            Write-Host "  Error creating file: $fileName - $_" -ForegroundColor Red
        }
    }
    
    Write-Host "  ✓ Completed: $($config.Count) files in $($config.Path)" -ForegroundColor Green
}

Write-Host "`n=== Generation Complete ===" -ForegroundColor Cyan
Write-Host "Total files created: $totalCreated" -ForegroundColor Green
Write-Host "Location: $baseDir" -ForegroundColor Yellow

# Display folder statistics
Write-Host "`n=== Folder Statistics ===" -ForegroundColor Cyan
foreach ($folder in $folders) {
    $fullPath = Join-Path $baseDir $folder
    $fileCount = (Get-ChildItem -Path $fullPath -File).Count
    Write-Host "  $folder : $fileCount files" -ForegroundColor Gray
}

# Calculate total size
$totalSize = (Get-ChildItem -Path $baseDir -Recurse -File | Measure-Object -Property Length -Sum).Sum
$totalSizeMB = [math]::Round($totalSize / 1MB, 2)
Write-Host "`nTotal collection size: $totalSizeMB MB" -ForegroundColor Yellow

Write-Host "`n✓ Ready for PER-04 testing!" -ForegroundColor Green
Write-Host "Next: Use this collection to test UI performance with 1,200 items" -ForegroundColor Cyan
