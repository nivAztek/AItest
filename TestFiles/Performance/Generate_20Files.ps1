# PER-02: Generate 20 Files for Concurrent Upload Testing
# This script creates 20 varied files for performance testing

Write-Host "Creating 20 test files for concurrent upload (PER-02)..." -ForegroundColor Cyan

$outputDir = ".\TestFiles\Performance"

# Create 20 different files with various types
$files = @(
    @{Name="perf_image_01.jpg"; Type="Image"; Size=2MB; Content="JPEG"}
    @{Name="perf_image_02.png"; Type="Image"; Size=3MB; Content="PNG"}
    @{Name="perf_doc_01.pdf"; Type="PDF"; Size=4MB; Content="PDF"}
    @{Name="perf_doc_02.pdf"; Type="PDF"; Size=5MB; Content="PDF"}
    @{Name="perf_data_01.csv"; Type="CSV"; Size=1MB; Content="CSV"}
    @{Name="perf_data_02.json"; Type="JSON"; Size=2MB; Content="JSON"}
    @{Name="perf_text_01.txt"; Type="Text"; Size=1MB; Content="TXT"}
    @{Name="perf_text_02.txt"; Type="Text"; Size=1MB; Content="TXT"}
    @{Name="perf_image_03.jpg"; Type="Image"; Size=6MB; Content="JPEG"}
    @{Name="perf_image_04.png"; Type="Image"; Size=4MB; Content="PNG"}
    @{Name="perf_doc_03.pdf"; Type="PDF"; Size=7MB; Content="PDF"}
    @{Name="perf_doc_04.pdf"; Type="PDF"; Size=3MB; Content="PDF"}
    @{Name="perf_data_03.csv"; Type="CSV"; Size=2MB; Content="CSV"}
    @{Name="perf_data_04.json"; Type="JSON"; Size=3MB; Content="JSON"}
    @{Name="perf_text_03.txt"; Type="Text"; Size=1MB; Content="TXT"}
    @{Name="perf_mixed_01.dat"; Type="Mixed"; Size=5MB; Content="DAT"}
    @{Name="perf_image_05.jpg"; Type="Image"; Size=8MB; Content="JPEG"}
    @{Name="perf_doc_05.pdf"; Type="PDF"; Size=9MB; Content="PDF"}
    @{Name="perf_data_05.csv"; Type="CSV"; Size=3MB; Content="CSV"}
    @{Name="perf_final_20.txt"; Type="Text"; Size=2MB; Content="TXT"}
)

$count = 0
foreach ($file in $files) {
    $count++
    $filePath = Join-Path $outputDir $file.Name
    
    Write-Host "[$count/20] Creating $($file.Name) ($($file.Size/1MB)MB)..." -NoNewline
    
    $stream = [System.IO.File]::Create($filePath)
    $header = [System.Text.Encoding]::UTF8.GetBytes("$($file.Type) Test File - $($file.Name)`n")
    $stream.Write($header, 0, $header.Length)
    
    $chunkSize = 1024  # 1KB chunks
    $chunk = [byte[]]::new($chunkSize)
    $totalBytes = $file.Size
    $written = $header.Length
    
    while ($written -lt $totalBytes) {
        $toWrite = [Math]::Min($chunkSize, $totalBytes - $written)
        $stream.Write($chunk, 0, $toWrite)
        $written += $toWrite
    }
    
    $stream.Close()
    Write-Host " ✓" -ForegroundColor Green
}

Write-Host "`n✓ All 20 performance test files created!" -ForegroundColor Green
Write-Host "`nFile Summary:" -ForegroundColor Yellow
Get-ChildItem $outputDir -Filter "perf_*" | 
    Select-Object Name, @{Name="Size (MB)";Expression={"{0:N2}" -f ($_.Length / 1MB)}} | 
    Format-Table -AutoSize

Write-Host "`nTotal Size: $((Get-ChildItem $outputDir -Filter 'perf_*' | Measure-Object -Property Length -Sum).Sum / 1MB) MB" -ForegroundColor Cyan
Write-Host "Ready for PER-02 concurrent upload testing!" -ForegroundColor Green
