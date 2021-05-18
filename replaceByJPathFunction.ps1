# Formats JSON in a nicer format than the built-in ConvertTo-Json does.
function Format-Json([Parameter(Mandatory, ValueFromPipeline)][String] $json) {
    $indent = 0;
    $preFormated = ($json -Split '\n' |
      ForEach-Object {
        if ($_ -match '[\}\]]') {
          # This line contains  ] or }, decrement the indentation level
          $indent--
        }
        $line = (' ' * $indent * 2) + $_.TrimStart().Replace(':  ', ': ')
        if ($_ -match '[\{\[]') {
          # This line contains [ or {, increment the indentation level
          $indent++
        }
        $line
    }) -Join "`n";
    $preFormated = $preFormated -replace '\[\s+\]', '[]';
    $preFormated;
  }

# Désérialiser le contenu
$content = Get-Content $args[0];

$json = $content | ConvertFrom-Json;

# Modifier certaines valeurs
foreach ($tag in $json.Tags) {
    $tag.Confidence = 1.0
}

# Écrire le contenu dans un fichier
$outputContent = ConvertTo-Json @($json)[0] -Depth 64 | Format-Json;

[System.IO.File]::WriteAllText($args[1], $outputContent);