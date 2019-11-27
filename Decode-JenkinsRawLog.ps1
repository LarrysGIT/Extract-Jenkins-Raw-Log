
$Path = "Samplelog"

$PREAMBLE_STR = "\x1B\[8mha:" # regular expression
$POSTAMBLE_STR = "\x1B\[0m" # regular expression

$Content = Get-Content -Path $Path
foreach($line in $Content)
{
    $line_split = $line -split $PREAMBLE_STR -split $POSTAMBLE_STR
    $line_base64data = [System.Convert]::FromBase64String($line_split[1])
    $line_base64data = $line_base64data[40..$($line_base64data.length - 1)]
    $line_ms = [io.memorystream]([byte[]]$line_base64data)
    $gzip = New-Object System.IO.Compression.GzipStream $line_ms, ([IO.Compression.CompressionMode]::Decompress)
    $extract_ms = New-Object System.IO.MemoryStream
    $buffer = New-Object byte[] 1024
    while($true)
    {
        $count = $gzip.Read($buffer, 0, 1024)
        if($count -ge 1)
        {
            $extract_ms.Write($buffer, 0, $count)
        }
        else
        {
            break
        }
    }
    $extract = $extract_ms.ToArray()
    $extract_ms.Close()
    $gzip.Close()
    $line_ms.Close()
    Write-Host "Original line: "
    Write-Host "  $line" -ForegroundColor Yellow
    Write-Host "    Extracted line: "
    Write-host "      Part1: $($line_split[0]) " -ForegroundColor Green
    Write-host "      Part2: $([text.encoding]::UTF8.GetString($extract)) " -ForegroundColor Green
    Write-host "      Part3: $($line_split[1]) " -ForegroundColor Green
}
