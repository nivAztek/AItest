# Generate Test Files for Upload Testing
# Run this script to create necessary test files

Write-Host "Creating test files for AI_Adama validation tests..." -ForegroundColor Cyan

# UPL-06: Create a file larger than 10MB (12MB PDF simulation)
Write-Host "`n[UPL-06] Creating large file (>10MB)..."
$largePath = ".\TestFiles\Uploads\large_file_12mb.pdf"
$content = "PDF SIMULATION - " + ("X" * 1024)  # 1KB chunk
$stream = [System.IO.File]::Create($largePath)
for ($i = 0; $i -lt 12288; $i++) {  # 12MB = 12288 KB
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($content)
    $stream.Write($bytes, 0, $bytes.Length)
}
$stream.Close()
Write-Host "✓ Created: $largePath ($('{0:N2}' -f ((Get-Item $largePath).Length / 1MB)) MB)" -ForegroundColor Green

# UPL-01: Create a simulated 8MB PNG placeholder
Write-Host "`n[UPL-01] Creating 8MB image file..."
$imagePath = ".\TestFiles\Uploads\test_image_8mb.png"
$imageStream = [System.IO.File]::Create($imagePath)
$imageContent = [byte[]]::new(1024)  # 1KB chunks
for ($i = 0; $i -lt 8192; $i++) {  # 8MB
    $imageStream.Write($imageContent, 0, $imageContent.Length)
}
$imageStream.Close()
Write-Host "✓ Created: $imagePath ($('{0:N2}' -f ((Get-Item $imagePath).Length / 1MB)) MB)" -ForegroundColor Green

# UPL-02: Create a simulated 9MB PDF
Write-Host "`n[UPL-02] Creating 9MB PDF file..."
$pdfPath = ".\TestFiles\Uploads\sample_document_9mb.pdf"
$pdfStream = [System.IO.File]::Create($pdfPath)
$pdfHeader = [System.Text.Encoding]::ASCII.GetBytes("%PDF-1.4`n")
$pdfStream.Write($pdfHeader, 0, $pdfHeader.Length)
$pdfContent = [byte[]]::new(1024)
for ($i = 0; $i -lt 9216; $i++) {  # ~9MB
    $pdfStream.Write($pdfContent, 0, $pdfContent.Length)
}
$pdfStream.Close()
Write-Host "✓ Created: $pdfPath ($('{0:N2}' -f ((Get-Item $pdfPath).Length / 1MB)) MB)" -ForegroundColor Green

Write-Host "`n✓ All upload test files created successfully!" -ForegroundColor Green
Write-Host "`nGenerated files:" -ForegroundColor Yellow
Get-ChildItem ".\TestFiles\Uploads" | Select-Object Name, @{Name="Size (MB)";Expression={"{0:N2}" -f ($_.Length / 1MB)}} | Format-Table -AutoSize
