<#
   Copyright 2021 Frédéric Jacques

   Licensed under the Apache License, Version 2.0 (the "License");
#>

# Fonction contenant les json de remplacement associé au cas d'essais
function JsonReplacement([string]$nomCasEssais) {
    switch ($nomCasEssais) {
        "input1.json" { return "{'Tags.Confidence':1.0,'RequestId':'0000-0000-0000'}" }
        "input2.json" { return "{'donnees.d': '2021'}" }
        "input3.json" { return "{'capteurs.donnees.id': '000-000-000' }" }
        "input4.xml"  { return "{'/submission/group/@attr1': 'some other text', '/submission/group/item': 'z'}"}
        "input5.xml"  { return "{'/submission/group/@attr1': 'some other text', '/submission/group/item': 'z'}"}
        "input_hl7.xml"  { return "{'/PRPA_IN101104CA/id/@root': '0', '/PRPA_IN101104CA/creationTime/@value': '2009', '/PRPA_IN101104CA/controlActEvent/id/@root': '00'}"}
        Default {
            Write-Host "Aucun json de remplacement pour le cas d'essais " $nomCasEssais;
            exit 1;
        }
    }
}

# Variable pour calculer le résultats des essais
$nbCasEssais = 0;
$occurenceEchec = 0;

# Récupération des cas d'essais
$casEssais = Get-ChildItem -Path ".\exemples" -Filter "input*";

# Créer le répertoire de sortie
if (Test-Path -Path .\TestResults) {
    Write-Host "Le dossier TestResults existe deja";
}
else {
    Write-Host "Creation du dossier TestResults";
    New-Item -Path . -Name "TestResults" -ItemType "directory"
}

# Executer la suite de tests
foreach ($casEssai in $casEssais) {
    $fichierOutput = $casEssai.Name.Replace("input", "output");
    $jsonRemplacement = JsonReplacement($casEssai.Name);

    & .\replaceByJPath.ps1 -inputFileName .\exemples\$casEssai -replaceJson $jsonRemplacement -outputFileName .\TestResults\$fichierOutput | Out-Null

    $resultatAttendue = Get-Content .\exemples\$fichierOutput -Encoding utf8;
    $resultatObtenue = Get-Content .\TestResults\$fichierOutput -Encoding utf8;

    if ([System.String]::Equals($resultatAttendue, $resultatObtenue, [System.StringComparison]::Ordinal) -and
         $resultatAttendue.Length -eq $resultatObtenue.Length) {
        Write-Host "[SUCCES]" -ForegroundColor white -BackgroundColor green -NoNewline;
    }
    else {
        Write-Host "[ECHEC]" -ForegroundColor white -BackgroundColor red -NoNewline;
        $occurenceEchec++;
    }

    Write-Host " cas essais" $casEssai.Name;

    $nbCasEssais++;
}

# Afficher les resultats
Write-Host "Resultat" ($nbCasEssais - $occurenceEchec) "/" $nbCasEssais "cas d'essais ont reussit";

if ($occurenceEchec -gt 0) {
    Write-Host "Echec, corriger le code et recommencer"
    exit 1;
}
