param(
  [string] $inputFileName="",
  [string] $replaceJson="",
  [string] $outputFileName=""
)

# Section validation des paramètres d'entrés

## Transformer l'objet de replacement
$replaceObject = $replaceJson | ConvertFrom-Json;

# Section de définition des fonctions

## Formats JSON in a nicer format than the built-in ConvertTo-Json does.
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

## Function to dynamicaly get value of a property of a json object
function Get-Value($jobject) {
    $a = $jobject.Definition.Split('=');
    $type = $jobject.Definition.Split(' ')[0];

    if ($type -eq "decimal") {
        return [System.Decimal]::Parse($a[$a.Length - 1]);
    }

    if ($a -eq "System.Object[]") {
       [System.Collections.ArrayList]$al = @()

        return $al; # Dans l'état actuel, cela ce transforme en null dans l'objet
    }
    if ($type -eq "object" -and $a[$a.Length - 1] -eq "null") {
       return [System.Object];
    }

    return $a[$a.Length - 1];
}

## Fonction permettant de déduire si une chaine de caractère est un json
function TypeFichier([string] $text) {
  $indiceJson = $text.IndexOf('{');
  $indiceXml  = $text.IndexOf('<');

  if ($indiceJson -eq 0) {
    return "json";
  }

  if ($indiceXml -eq 0) {
    return "xml";
  }

  if (($indiceXml -eq -1 -and $indiceJson -ge 0) -or
       $indiceXml -gt $indiceJson) {
         return "json";
       }

  if (($indiceJson -eq -1 -and $indiceXml -ge 0) -or
       $indiceJson -gt $indiceXml) {
         return "xml";
       }

  return "inconnu";
}

# Algoritme de transformation

## Désérialiser le contenu
$content = Get-Content $inputFileName -Encoding utf8;

$typeFichier = TypeFichier($content);

if ($typeFichier -eq "json") {
  $json = $content | ConvertFrom-Json;

  ## Remplacement générique depuis l'objet de replacement
  foreach ($jpath in $replaceObject | Get-Member -MemberType "NoteProperty") 
  {
      $ref = $json

      $pathElements = $jpath.Name.Split('.');

      for ($i = 0; $i -lt $pathElements.Length - 1; $i++) 
      {
          $ref = $ref.($pathElements[$i]);
      }

      if ($ref -is [system.array]) {
          for ($j = 0; $j -lt $ref.Length; $j++) {
            Write-Output $ref[$j].($pathElements[$pathElements.Length - 1]);
            
            $ref[$j].($pathElements[$pathElements.Length - 1]) = Get-Value($jpath);

            Write-Output $ref[$j].($pathElements[$pathElements.Length - 1]);
          }
      }
      else {
          Write-Output $ref.($pathElements[$pathElements.Length - 1]);

          $ref.($pathElements[$pathElements.Length - 1]) = Get-Value($jpath);

          Write-Output $ref.($pathElements[$pathElements.Length - 1]);
      }
  }

  ## Écrire le contenu dans un fichier
  $outputContent = "";

  if ($json -is [system.array]) {
    $outputContent = ConvertTo-Json @($json) -Depth 64 | Format-Json;
  }
  else {
      $outputContent = ConvertTo-Json @($json)[0] -Depth 64 | Format-Json;
  }

  $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding $False

  [System.IO.File]::WriteAllText($outputFileName, $outputContent, $Utf8NoBomEncoding);
}
elseif ($typeFichier -eq "xml") {
  $xmlDoc = [xml]$content.Replace(' xmlns="', ' notxmlns="');

  ## Remplacement générique depuis l'objet de replacement
  foreach ($jpath in $replaceObject | Get-Member -MemberType "NoteProperty") 
  {
    $nodes = $xmlDoc.SelectNodes($jpath.Name);

    foreach ($node in $nodes) {
      if ($null -ne $node) {
        if ($node.NodeType -eq "Element") {
            Write-Output $node.InnerXml;

            $node.InnerXml = Get-Value($jpath);

            Write-Output $node.InnerXml;
        }
        else {
            Write-Output $node.Value;

            $node.Value = Get-Value($jpath);

            Write-Output $node.Value;
        }
      }
    }
  }

  ## Écrire le contenu dans un fichier
  $xmlString = $xmlDoc.OuterXml;

  $xmlOut = [xml]$xmlString.Replace(' notxmlns="', ' xmlns="');

  $xmlOut.save($outputFileName);
}
else {
  Write-Error "Contenu non reconnu, le fichier n'est ni un json, ni un xml";
}